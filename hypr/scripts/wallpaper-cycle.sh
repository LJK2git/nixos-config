#!/usr/bin/env bash
# Cycle wallpapers forward or backward with hyprpaper.
# Usage: wallpaper-cycle.sh next|prev

set -euo pipefail

WALL_DIR="$HOME/.config/wallpapers"
MONITOR="eDP-1"
STATE_FILE="$HOME/.cache/hypr/wall_index"
LOCK_FILE="/tmp/wallpaper-cycle.lock"

mkdir -p "$(dirname "$STATE_FILE")"

# Prevent overlapping runs (e.g. mashing the keybind) which is one of the
# main causes of "invalid hyprpaper request" errors.
exec 9>"$LOCK_FILE"
flock -n 9 || exit 0

DIRECTION="${1:-next}"

# Sorted, numeric-aware list (1.jpg 2.jpg ... not 1.jpg 10.jpg 2.jpg)
mapfile -t WALLS < <(find "$WALL_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" \) | sort -V)

COUNT=${#WALLS[@]}
if [ "$COUNT" -eq 0 ]; then
    notify-send "Wallpaper cycle" "No jpgs found in $WALL_DIR" 2>/dev/null || true
    exit 1
fi

CUR=0
if [ -f "$STATE_FILE" ]; then
    CUR=$(cat "$STATE_FILE")
fi
if ! [[ "$CUR" =~ ^[0-9]+$ ]] || [ "$CUR" -ge "$COUNT" ]; then
    CUR=0
fi

case "$DIRECTION" in
    next) NEW=$(( (CUR + 1) % COUNT )) ;;
    prev) NEW=$(( (CUR - 1 + COUNT) % COUNT )) ;;
    *)
        echo "Usage: $0 [next|prev]" >&2
        exit 1
        ;;
esac

NEW_PATH="${WALLS[$NEW]}"

# On this hyprpaper build, 'preload' and 'reload' both error out with
# "invalid hyprpaper request" -- but calling 'wallpaper' directly works
# fine and loads the image itself. So we just call that.
hyprctl hyprpaper wallpaper "${MONITOR},${NEW_PATH}" >/dev/null

# Best-effort cleanup of anything preloaded-but-unused, so memory doesn't
# creep up over time. Wrapped so it can't abort the script if unsupported.
hyprctl hyprpaper unload unused >/dev/null 2>&1 || true

echo "$NEW" > "$STATE_FILE"
