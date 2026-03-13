#!/usr/bin/env bash
# thumb-gen.sh - Generate thumbnails for the theme picker
# Usage: thumb-gen.sh <image-path>
# Returns: path to cached thumbnail, or empty string if unavailable

THUMB_DIR="$HOME/.cache/theme-picker/thumbs"
mkdir -p "$THUMB_DIR"

# Prefer ImageMagick 7 (magick), fall back to ImageMagick 6 (convert)
if command -v magick >/dev/null 2>&1; then
  IM_CMD="magick"
elif command -v convert >/dev/null 2>&1; then
  IM_CMD="convert"
else
  echo ""
  exit 0
fi

get_thumb() {
  local src="$1"
  local hash
  hash=$(md5sum <<< "$src" | cut -c1-32)
  local thumb="$THUMB_DIR/$hash.jpg"

  if [[ ! -f "$thumb" || "$src" -nt "$thumb" ]]; then
    $IM_CMD "$src"[0] -strip -thumbnail 500x500^ -gravity center -extent 500x500 -quality 85 "$thumb" 2>/dev/null || {
      echo ""
      return
    }
  fi
  echo "$thumb"
}

if [[ -n "${1:-}" ]]; then
  get_thumb "$1"
fi
