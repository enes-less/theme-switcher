#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN=0
SKIP_SYSTEMD=0
NO_BACKUP=0
INSTALL_HOME="${HOME}"

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --dry-run            Show actions without writing anything
  --skip-systemd       Do not run systemctl --user enable/start
  --no-backup          Do not backup existing ~/.config/hypr
  --home PATH          Install into a fake/alternate HOME
  -h, --help           Show this help
EOF
}

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

info()  { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2; }
error() { printf '\033[1;31m[ERR ]\033[0m %s\n' "$*" >&2; }

require_dir() {
  [[ -d "$1" ]] || {
    error "Missing required directory: $1"
    exit 1
  }
}

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

check_optional_deps() {
  local missing=()
  local deps=(
    jq
    sed
    find
    cp
    chmod
    grep
    hyprctl
    swww
    rofi
    wofi
    waybar
    swaync
    swaync-client
    kitty
    fastfetch
    ddcutil
    inotifywait
    matugen
  )

  for dep in "${deps[@]}"; do
    command -v "$dep" >/dev/null 2>&1 || missing+=("$dep")
  done

  if (( ${#missing[@]} > 0 )); then
    warn "Missing optional dependencies: ${missing[*]}"
  fi
}

main() {
  require_dir "$SRC_HYPR"
  require_dir "$SRC_SWITCHER"
  require_dir "$SRC_BIN"
  require_dir "$SRC_SWAYNC"

  info "Repo dir: $REPO_DIR"
  info "Install home: $INSTALL_HOME"
  info "Config dir: $XDG_CONFIG_BASE"

  # 1) hyprland -> ~/.config/hypr (backup existing first)
  if [[ -d "$DEST_HYPR" ]]; then
    backup_if_exists "$DEST_HYPR"
  fi
  info "Installing Hyprland config -> $DEST_HYPR"
  copy_dir_contents "$SRC_HYPR" "$DEST_HYPR"

  # 2) theme-switcher -> ~/.config/theme-switcher
  info "Installing theme-switcher -> $DEST_SWITCHER"
  replace_dir "$SRC_SWITCHER" "$DEST_SWITCHER"

  # 3) scripts/* -> ~/bin/
  info "Installing scripts -> $DEST_BIN"
  run_cmd mkdir -p "$DEST_BIN"
  copy_dir_contents "$SRC_BIN" "$DEST_BIN"

  # 4) swaync/scripts/* -> ~/.config/swaync/scripts/
  info "Installing swaync scripts -> $DEST_SWAYNC"
  run_cmd mkdir -p "$DEST_SWAYNC"
  copy_dir_contents "$SRC_SWAYNC" "$DEST_SWAYNC"

  # permissions
  make_exec_in_tree "$DEST_SWITCHER"
  make_exec_in_tree "$DEST_SWAYNC"
  make_exec_top_level_files "$DEST_BIN"

  # state file
  ensure_state_file

  # 5) brightness daemon service
  install_brightnessd_service

  # dependency hints
  check_optional_deps

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