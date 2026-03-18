#!/usr/bin/env bash
set -euo pipefail

RDIR="${XDG_RUNTIME_DIR:-/tmp}"
CACHE="$RDIR/swaync-brightness"
TS="$RDIR/swaync-brightness.ts"
MAX_AGE_MS=500

now_ms() { date +%s%3N; }

# taze cache varsa onu dön
if [[ -f "$CACHE" && -f "$TS" ]]; then
  age=$(( $(now_ms) - $(cat "$TS" 2>/dev/null || echo 0) ))
  if (( age >= 0 && age <= MAX_AGE_MS )); then
    cat "$CACHE"
    exit 0
  fi
fi

# cache yok/eskimiş -> ddcutil'dan oku
v="$(ddcutil getvcp 10 --brief 2>/dev/null | awk '{print $4}' | head -n1 || true)"
if [[ -n "${v:-}" && "$v" =~ ^[0-9]+$ ]]; then
  echo "$v" > "$CACHE"
  now_ms > "$TS"
  echo "$v"
else
  # son cache varsa onu dön, yoksa 50
  cat "$CACHE" 2>/dev/null || echo 50
fi
