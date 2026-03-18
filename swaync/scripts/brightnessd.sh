#!/usr/bin/env bash
set -euo pipefail

RDIR="${XDG_RUNTIME_DIR:-/tmp}"
TARGET="$RDIR/swaync-brightness.target"
TIMER_PID="$RDIR/swaync-brightness.timer.pid"

apply() {
  local v
  v="$(cat "$TARGET" 2>/dev/null || echo 0)"
  [[ "$v" =~ ^[0-9]+$ ]] || v=0
  ddcutil setvcp 10 "$v"
}

command -v inotifywait >/dev/null 2>&1 || {
  echo "inotifywait missing: install inotify-tools" >&2
  exit 1
}

mkdir -p "$RDIR"
touch "$TARGET"

while inotifywait -q -e close_write "$TARGET" >/dev/null 2>&1; do

  if [[ -f "$TIMER_PID" ]]; then
    kill "$(cat "$TIMER_PID")" 2>/dev/null || true
    rm -f "$TIMER_PID"
  fi

  (
    sleep 0.2
    apply
  ) &

  echo $! > "$TIMER_PID"

done
