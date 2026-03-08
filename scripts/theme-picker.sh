#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/.config/theme-switcher"
THEMES_DIR="$BASE/themes"
THEME_JSON="theme.json"

declare -A MAP
keys=()

while IFS= read -r -d '' dir; do
  id="$(basename "$dir")"

  file="$dir/$THEME_JSON"
  name="$id"

  if [[ -f "$file" ]]; then
    name="$(sed -n 's/^[[:space:]]*"name"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p' "$file" | head -n1 || true)"
    json_id="$(sed -n 's/^[[:space:]]*"id"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p' "$file" | head -n1 || true)"

    [[ -n "${name:-}" ]] || name="$id"
    [[ -n "${json_id:-}" ]] && id="$json_id"
  fi

  key="$name"
  if [[ -n "${MAP[$key]+x}" ]]; then
    key="$name [$id]"
  fi

  MAP["$key"]="$id"
  keys+=("$key")
done < <(find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -print0)

menu="$(
  printf "%s\n" "${keys[@]}" | LC_ALL=C sort -f
)"

choice="$(printf "%s" "$menu" | wofi --dmenu --prompt "Theme" --sort-order=alphabetical --cache-file=/dev/null)"
[[ -z "${choice:-}" ]] && exit 0

theme_id="${MAP[$choice]}"

pkill -x wofi >/dev/null 2>&1 || true
sleep 0.05

"$BASE/apply-theme.sh" "$theme_id"
