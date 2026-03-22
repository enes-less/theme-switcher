#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/theme-switcher"

info()  { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2; }
error() { printf '\033[1;31m[ERR ]\033[0m %s\n' "$*" >&2; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    error "Missing required command: $1"
    exit 1
  }
}

check_optional() {
  local missing=()
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done

  if (( ${#missing[@]} > 0 )); then
    warn "Optional commands not found: ${missing[*]}"
  fi
}

copy_tree() {
  local src="$1"
  local dst="$2"
  mkdir -p "$dst"
  cp -a "$src"/. "$dst"/
}

make_scripts_executable() {
  find "$INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} +
}

ensure_state_file() {
  local state="$INSTALL_DIR/current-theme.json"
  if [[ ! -f "$state" ]]; then
    printf '{ "theme": "", "wallpaper": "" }\n' > "$state"
    info "Created $state"
  fi
}

main() {
  require_cmd cp
  require_cmd mkdir
  require_cmd chmod
  require_cmd find

  info "Installing theme-switcher to $INSTALL_DIR"
  mkdir -p "$INSTALL_DIR"

  copy_tree "$REPO_DIR/theme-switcher" "$INSTALL_DIR"
  make_scripts_executable
  ensure_state_file

  check_optional jq sed swww hyprctl rofi wofi waybar kitty matugen fastfetch swaync-client

  info "Install complete."
  printf '\n'
  printf 'Installed to: %s\n' "$INSTALL_DIR"
  printf 'Run themes with: %s/apply-theme.sh <theme>\n' "$INSTALL_DIR"
  printf 'Dynamic theme requires matugen.\n'
}

main "$@"