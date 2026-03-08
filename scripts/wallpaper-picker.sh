#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/.config/theme-switcher"
STATE="$BASE/current-theme.json"
THEMES_DIR="$BASE/themes"

theme="$(jq -r '.theme // empty' "$STATE" 2>/dev/null || true)"
[[ -z "$theme" ]] && exit 1

THEME_PATH="$THEMES_DIR/$theme"
WPDIR="$THEME_PATH/wallpapers"
[[ -d "$WPDIR" ]] || exit 1

mapfile -d '' -t files < <(
  find "$WPDIR" -maxdepth 1 -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
    -printf '%f\0' | sort -z
)
[[ ${#files[@]} -gt 0 ]] || exit 1

pgrep -x swww-daemon >/dev/null 2>&1 || (swww-daemon >/dev/null 2>&1 &)

choice="$(printf '%s\n' "${files[@]}" | wofi --dmenu --prompt "Select Wallpaper" --cache-file /dev/null)"
[[ -z "${choice:-}" ]] && exit 0

picked="$WPDIR/$choice"
[[ -f "$picked" ]] || exit 1

for _ in {1..20}; do
  swww query >/dev/null 2>&1 && break
  sleep 0.1
done

# random transition and angle for wallpaper. change
transitions=("outer" "wipe")
angles=(0 29 90 151 180 209 270 331)

t=${transitions[$RANDOM % ${#transitions[@]}]}
a=${angles[$RANDOM % ${#angles[@]}]}

swww img "$picked" --transition-type "$t" --transition-angle "$a" --transition-duration 0.75 --transition-fps 75 --transition-bezier 0.25,0.1,0.25,1

echo "wallpapers/$choice" > "$THEME_PATH/current-wallpaper.txt"
