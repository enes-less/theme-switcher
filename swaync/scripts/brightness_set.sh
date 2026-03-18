#!/usr/bin/env bash
set -euo pipefail
RDIR="${XDG_RUNTIME_DIR:-/tmp}"
echo "${1:-0}" > "$RDIR/swaync-brightness.target"
