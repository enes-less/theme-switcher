#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN=0
SKIP_SYSTEMD=0
NO_BACKUP=0
INSTALL_HOME="${HOME}"
INSTALL_DEPS_MODE="ask"   # ask | yes | no

XDG_CONFIG_BASE=""
SRC_HYPR=""
SRC_SWITCHER=""
SRC_BIN=""
SRC_SWAYNC=""
DEST_HYPR=""
DEST_SWITCHER=""
DEST_SWAYNC=""
DEST_SYSTEMD_USER=""
DEST_BIN=""
TIMESTAMP=""

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --dry-run            Show actions without writing anything
  --skip-systemd       Do not run systemctl --user enable/start
  --no-backup          Do not backup existing ~/.config/hypr
  --home PATH          Install into a fake/alternate HOME
  --install-deps       Install dependencies before copying files
  --no-install-deps    Do not install dependencies
  -h, --help           Show this help
EOF
}

info()  { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2; }
error() { printf '\033[1;31m[ERR ]\033[0m %s\n' "$*" >&2; }

run_cmd() {
  if (( DRY_RUN )); then
    printf '[DRY] '
    printf '%q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

write_file() {
  local target="$1"
  local content="$2"

  if (( DRY_RUN )); then
    printf '[DRY] write file: %s\n' "$target"
    return 0
  fi

  mkdir -p "$(dirname "$target")"
  printf '%s' "$content" > "$target"
}

require_dir() {
  [[ -d "$1" ]] || {
    error "Missing required directory: $1"
    exit 1
  }
}

backup_if_exists() {
  local target="$1"

  (( NO_BACKUP )) && return 0

  if [[ -e "$target" ]]; then
    local backup="${target}.bak.${TIMESTAMP}"
    info "Backing up $target -> $backup"
    run_cmd cp -a "$target" "$backup"
  fi
}

copy_dir_contents() {
  local src="$1"
  local dst="$2"

  run_cmd mkdir -p "$dst"
  run_cmd cp -a "$src"/. "$dst"/
}

replace_dir() {
  local src="$1"
  local dst="$2"

  run_cmd mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" ]]; then
    run_cmd rm -rf "$dst"
  fi
  run_cmd cp -a "$src" "$dst"
}

make_exec_in_tree() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0

  if (( DRY_RUN )); then
    printf '[DRY] chmod +x recursively on *.sh under %s\n' "$dir"
  else
    find "$dir" -type f -name "*.sh" -exec chmod +x {} +
  fi
}

make_exec_top_level_files() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0

  if (( DRY_RUN )); then
    printf '[DRY] chmod +x top-level files under %s\n' "$dir"
  else
    find "$dir" -maxdepth 1 -type f -exec chmod +x {} +
  fi
}

ensure_state_file() {
  local state="$DEST_SWITCHER/current-theme.json"

  if [[ ! -f "$state" ]]; then
    info "Creating $state"
    write_file "$state" '{ "theme": "", "wallpaper": "" }
'
  fi
}

install_brightnessd_service() {
  local service_file="$DEST_SYSTEMD_USER/brightnessd.service"
  local service_content
  service_content='[Unit]
Description=Debounced DDC brightness daemon

[Service]
ExecStart=%h/.config/swaync/scripts/brightnessd.sh
Restart=always
RestartSec=1

[Install]
WantedBy=default.target
'

  info "Installing brightnessd user service -> $service_file"
  write_file "$service_file" "$service_content"

  if (( SKIP_SYSTEMD )); then
    warn "Skipping systemd enable/start because --skip-systemd was used"
    return 0
  fi

  if ! command -v systemctl >/dev/null 2>&1; then
    warn "systemctl not found; service installed but not enabled"
    return 0
  fi

  if (( DRY_RUN )); then
    printf '[DRY] systemctl --user daemon-reload\n'
    printf '[DRY] systemctl --user enable --now brightnessd.service\n'
  else
    systemctl --user daemon-reload
    systemctl --user enable --now brightnessd.service
    info "Enabled and started brightnessd.service"
  fi
}

detect_pkg_manager() {
  if command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  elif command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v zypper >/dev/null 2>&1; then
    echo "zypper"
  else
    echo ""
  fi
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

want_interactive_dep_prompt() {
  [[ "$INSTALL_DEPS_MODE" == "ask" ]] || return 1
  [[ $# -eq 0 ]]
}

prompt_install_deps_if_needed() {
  local argc="$1"

  if [[ "$INSTALL_DEPS_MODE" != "ask" ]]; then
    return 0
  fi

  if [[ "$argc" -eq 0 ]]; then
    local answer
    printf 'Do you also want to install all dependencies? [Y/n] '
    read -r answer || true
    answer="${answer:-Y}"

    case "$answer" in
      [Yy]|[Yy][Ee][Ss])
        INSTALL_DEPS_MODE="yes"
        ;;
      [Nn]|[Nn][Oo])
        INSTALL_DEPS_MODE="no"
        ;;
      *)
        warn "Invalid answer, defaulting to yes"
        INSTALL_DEPS_MODE="yes"
        ;;
    esac
  else
    INSTALL_DEPS_MODE="no"
  fi
}

install_dependencies() {
  [[ "$INSTALL_DEPS_MODE" == "yes" ]] || return 0

  local pkgm
  pkgm="$(detect_pkg_manager)"

  if [[ -z "$pkgm" ]]; then
    warn "No supported package manager found. Skipping dependency installation."
    return 0
  fi

  info "Installing dependencies using $pkgm"

  local common_pkgs=()
  local rofi_group=()
  local extra_pkgs=()

  case "$pkgm" in
    pacman)
      common_pkgs=(
        jq
        sed
        findutils
        coreutils
        procps-ng
        hyprland
        swww
        waybar
        swaynotificationcenter
        kitty
        fastfetch
        ddcutil
        inotify-tools
        imagemagick
        matugen-bin
      )
      rofi_group=(rofi wofi)
      ;;
    apt)
      common_pkgs=(
        jq
        sed
        findutils
        coreutils
        procps
        swww
        waybar
        kitty
        fastfetch
        ddcutil
        inotify-tools
        imagemagick
      )
      rofi_group=(rofi wofi)
      extra_pkgs=(matugen)
      ;;
    dnf)
      common_pkgs=(
        jq
        sed
        findutils
        coreutils
        procps-ng
        swww
        waybar
        kitty
        fastfetch
        ddcutil
        inotify-tools
        ImageMagick
      )
      rofi_group=(rofi wofi)
      extra_pkgs=(matugen)
      ;;
    zypper)
      common_pkgs=(
        jq
        sed
        findutils
        coreutils
        procps
        swww
        waybar
        kitty
        fastfetch
        ddcutil
        inotify-tools
        ImageMagick
      )
      rofi_group=(rofi wofi)
      extra_pkgs=(matugen)
      ;;
    *)
      warn "Unsupported package manager: $pkgm"
      return 0
      ;;
  esac

  local launcher_pkgs=()
  if command_exists rofi || command_exists wofi; then
    info "A launcher already exists (rofi or wofi), skipping launcher package install"
  else
    launcher_pkgs=("${rofi_group[@]}")
  fi

  local install_list=("${common_pkgs[@]}" "${launcher_pkgs[@]}" "${extra_pkgs[@]}")

  if (( ${#install_list[@]} == 0 )); then
    info "No dependencies to install"
    return 0
  fi

  if (( DRY_RUN )); then
    case "$pkgm" in
      pacman)
        printf '[DRY] sudo pacman -Syu --needed %s\n' "${install_list[*]}"
        ;;
      apt)
        printf '[DRY] sudo apt-get update\n'
        printf '[DRY] sudo apt-get install -y %s\n' "${install_list[*]}"
        ;;
      dnf)
        printf '[DRY] sudo dnf install -y %s\n' "${install_list[*]}"
        ;;
      zypper)
        printf '[DRY] sudo zypper install -y %s\n' "${install_list[*]}"
        ;;
    esac
    return 0
  fi

  sudo -v

  case "$pkgm" in
    pacman)
      sudo pacman -Syu --needed "${install_list[@]}"
      ;;
    apt)
      sudo apt-get update
      sudo apt-get install -y "${install_list[@]}"
      ;;
    dnf)
      sudo dnf install -y "${install_list[@]}"
      ;;
    zypper)
      sudo zypper install -y "${install_list[@]}"
      ;;
  esac
}

check_runtime_hints() {
  local missing=()

  local expected=(
    bash
    jq
    sed
    find
    cp
    chmod
    grep
    hyprctl
    swww
    ddcutil
    inotifywait
    matugen
  )

  for dep in "${expected[@]}"; do
    command -v "$dep" >/dev/null 2>&1 || missing+=("$dep")
  done

  if ! command -v rofi >/dev/null 2>&1 && ! command -v wofi >/dev/null 2>&1; then
    missing+=("rofi|wofi")
  fi

  if (( ${#missing[@]} > 0 )); then
    warn "Missing runtime dependencies/features: ${missing[*]}"
  fi
}

init_paths() {
  XDG_CONFIG_BASE="${XDG_CONFIG_HOME:-$INSTALL_HOME/.config}"

  SRC_HYPR="$REPO_DIR/hyprland"
  SRC_SWITCHER="$REPO_DIR/theme-switcher"
  SRC_BIN="$REPO_DIR/scripts"
  SRC_SWAYNC="$REPO_DIR/swaync/scripts"

  DEST_HYPR="$XDG_CONFIG_BASE/hypr"
  DEST_SWITCHER="$XDG_CONFIG_BASE/theme-switcher"
  DEST_SWAYNC="$XDG_CONFIG_BASE/swaync/scripts"
  DEST_SYSTEMD_USER="$XDG_CONFIG_BASE/systemd/user"
  DEST_BIN="$INSTALL_HOME/bin"

  TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      --skip-systemd)
        SKIP_SYSTEMD=1
        shift
        ;;
      --no-backup)
        NO_BACKUP=1
        shift
        ;;
      --home)
        [[ $# -ge 2 ]] || { echo "Missing value for --home" >&2; exit 1; }
        INSTALL_HOME="$2"
        shift 2
        ;;
      --install-deps)
        INSTALL_DEPS_MODE="yes"
        shift
        ;;
      --no-install-deps)
        INSTALL_DEPS_MODE="no"
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 1
        ;;
    esac
  done
}

main() {
  local original_argc="$#"

  parse_args "$@"
  init_paths
  prompt_install_deps_if_needed "$original_argc"

  require_dir "$SRC_HYPR"
  require_dir "$SRC_SWITCHER"
  require_dir "$SRC_BIN"
  require_dir "$SRC_SWAYNC"

  info "Repo dir: $REPO_DIR"
  info "Install home: $INSTALL_HOME"
  info "Config dir: $XDG_CONFIG_BASE"

  install_dependencies

  if [[ -d "$DEST_HYPR" ]]; then
    backup_if_exists "$DEST_HYPR"
  fi
  info "Installing Hyprland config -> $DEST_HYPR"
  copy_dir_contents "$SRC_HYPR" "$DEST_HYPR"

  info "Installing theme-switcher -> $DEST_SWITCHER"
  replace_dir "$SRC_SWITCHER" "$DEST_SWITCHER"

  info "Installing scripts -> $DEST_BIN"
  run_cmd mkdir -p "$DEST_BIN"
  copy_dir_contents "$SRC_BIN" "$DEST_BIN"

  info "Installing swaync scripts -> $DEST_SWAYNC"
  run_cmd mkdir -p "$DEST_SWAYNC"
  copy_dir_contents "$SRC_SWAYNC" "$DEST_SWAYNC"

  make_exec_in_tree "$DEST_SWITCHER"
  make_exec_in_tree "$DEST_SWAYNC"
  make_exec_top_level_files "$DEST_BIN"

  ensure_state_file
  install_brightnessd_service
  check_runtime_hints

  info "Installation finished"
  printf '\n'
  printf 'Installed paths:\n'
  printf '  Hyprland:       %s\n' "$DEST_HYPR"
  printf '  Theme switcher: %s\n' "$DEST_SWITCHER"
  printf '  User scripts:   %s\n' "$DEST_BIN"
  printf '  SwayNC scripts: %s\n' "$DEST_SWAYNC"
  printf '\n'
  printf 'Next:\n'
  printf '  1. Choose a theme using mainMod + T (start key + T)\n'
  printf '  2. Choose a wallpaper using mainMod + W (start key + W)\n'
  printf '  3. Enjoy\n'
}

main "$@"