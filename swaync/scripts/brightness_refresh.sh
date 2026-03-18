#!/usr/bin/env bash
set -euo pipefail
CACHE="${XDG_RUNTIME_DIR:-/tmp}/swaync-brightness"

v="$(ddcutil getvcp 10 --brief 2>/dev/null | awk '{print $4}' | head -n1 || true)"
[[ -n "${v:-}" && "$v" =~ ^[0-9]+$ ]] && echo "$v" > "$CACHE"
