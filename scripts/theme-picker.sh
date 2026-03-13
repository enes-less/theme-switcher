#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/.config/theme-switcher"
THEMES_DIR="$BASE/themes"
THEME_JSON="theme.json"
THUMB_GEN="$(dirname "$(realpath "$0")")/thumb-gen.sh"

# Detect launcher: prefer rofi, fall back to wofi
if command -v rofi >/dev/null 2>&1; then
  LAUNCHER="rofi"
elif command -v wofi >/dev/null 2>&1; then
  LAUNCHER="wofi"
else
  echo "Error: neither rofi nor wofi found" >&2
  exit 1
fi

declare -A MAP
declare -A ICON_MAP
keys=()

while IFS= read -r -d '' dir; do
  id="$(basename "$dir")"
  file="$dir/$THEME_JSON"
  name="$id"
  preview=""

  if [[ -f "$file" ]]; then
    name="$(jq -r '.name // empty' "$file" 2>/dev/null || true)"
    json_id="$(jq -r '.id // empty' "$file" 2>/dev/null || true)"
    [[ -n "${name:-}" ]] || name="$id"
    [[ -n "${json_id:-}" ]] && id="$json_id"

    # Find preview: preview.png > default_wallpaper in theme.json > first image in theme dir
    if [[ -f "$dir/preview.png" ]]; then
      preview="$dir/preview.png"
    else
      wp_rel="$(jq -r '.default_wallpaper // empty' "$file" 2>/dev/null || true)"
      if [[ -n "$wp_rel" && -f "$dir/$wp_rel" ]]; then
        preview="$dir/$wp_rel"
      else
        preview="$(find "$dir" -maxdepth 2 -type f \( -name "*.jpg" -o -name "*.png" \) | head -n1 || true)"
      fi
    fi
  fi

  key="$name"
  if [[ -n "${MAP[$key]+x}" ]]; then
    key="$name [$id]"
  fi

  MAP["$key"]="$id"

  if [[ "$LAUNCHER" == "rofi" && -n "$preview" && -x "$THUMB_GEN" ]]; then
    thumb="$("$THUMB_GEN" "$preview")"
    [[ -n "$thumb" ]] && ICON_MAP["$key"]="$thumb"
  fi

  keys+=("$key")
done < <(find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -print0)

choices_sorted="$(printf "%s\n" "${keys[@]}" | LC_ALL=C sort -f)"

if [[ "$LAUNCHER" == "rofi" ]]; then
  ROFI_CFG="$HOME/.config/rofi/theme-picker.rasi"
  menu_data=""
  while IFS= read -r key; do
    [[ -z "$key" ]] && continue
    if [[ -n "${ICON_MAP[$key]:-}" ]]; then
      menu_data+="${key}\x00icon\x1f${ICON_MAP[$key]}\n"
    else
      menu_data+="${key}\n"
    fi
  done <<< "$choices_sorted"

  rofi_args=(-dmenu -i -p "Theme")
  [[ -f "$ROFI_CFG" ]] && rofi_args+=(-config "$ROFI_CFG")

  choice="$(printf '%b' "$menu_data" | rofi "${rofi_args[@]}")"
else
  choice="$(printf "%s" "$choices_sorted" | wofi --dmenu --prompt "Theme" --sort-order=alphabetical --cache-file=/dev/null)"
  pkill -x wofi >/dev/null 2>&1 || true
  sleep 0.05
fi

[[ -z "${choice:-}" ]] && exit 0

theme_id="${MAP[$choice]}"
"$BASE/apply-theme.sh" "$theme_id"
