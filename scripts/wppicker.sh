#!/usr/bin/env bash
# pick-wall.sh — choose a wallpaper via rofi and set it with swww

set -euo pipefail
IFS=$'\n\t'

# --- config ---
DEFAULT_DIR="${HOME}/Wallpapers"
DIR="${1:-$DEFAULT_DIR}"

TRANSITION_FPS=120
TRANSITION_TYPE=outer
TRANSITION_DURATION=3
MAX_ROWS=10

usage() {
  cat >&2 <<EOF
Usage: ${0##*/} [DIRECTORY]

Pick a wallpaper from DIRECTORY (default: $DEFAULT_DIR)
using rofi and set it via swww.
EOF
  exit 1
}

if [[ "${1-}" == "-h" || "${1-}" == "--help" ]]; then
  usage
fi

# --- required commands (except fd/find, handled separately) ---
for cmd in rofi swww sort; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: required command not found in PATH: $cmd" >&2
    exit 1
  fi
done

if [[ ! -d "$DIR" ]]; then
  echo "Error: directory not found: $DIR" >&2
  exit 1
fi

if [[ ! -r "$DIR" || ! -x "$DIR" ]]; then
  echo "Error: directory not readable/searchable: $DIR" >&2
  exit 1
fi

# --- decide on fd vs find ---
FD=""
if command -v fd >/dev/null 2>&1; then
  FD="fd"
elif command -v fdfind >/dev/null 2>&1; then
  FD="fdfind"
fi

# --- collect files (full paths) ---
mapfile -d '' -t files < <(
  if [[ -n "$FD" ]]; then
    # fd: fast path
    "$FD" -t f -0 \
      -e jpg  -e jpeg -e png  -e webp \
      -e bmp  -e svg  -e avif \
      -e gif  -e tiff -e tif \
      . "$DIR" 2>/dev/null | sort -z
  else
    # fallback: find
    if ! command -v find >/dev/null 2>&1; then
      echo "Error: neither fd nor find is available." >&2
      exit 1
    fi
    find "$DIR" -type f \( \
        -iname '*.jpg'  -o -iname '*.jpeg' -o -iname '*.png'  -o \
        -iname '*.webp' -o -iname '*.bmp'  -o -iname '*.svg'  -o \
        -iname '*.avif' -o -iname '*.gif'  -o \
        -iname '*.tiff' -o -iname '*.tif' \
      \) -print0 2>/dev/null | sort -z
  fi
)

if ((${#files[@]} == 0)); then
  echo "Error: no image files found in: $DIR" >&2
  exit 1
fi

# --- decide how many rows rofi should show ---
rows=${#files[@]}
if (( rows > MAX_ROWS )); then
  rows=$MAX_ROWS
fi

# --- show only basenames in rofi, get INDEX back ---
index="$(
  printf '%s\0' "${files[@]##*/}" |
rofi -dmenu \
  -sep '\0' \
  -i \
  -no-custom \
  -format 'i' \
  -l "$rows" \
  -theme-str '
    window { width: 20%; }
  '
)"

# User cancelled
if [[ -z "${index:-}" ]]; then
  exit 0
fi

# Sanity-check index
if ! [[ "$index" =~ ^[0-9]+$ ]]; then
  echo "Error: rofi returned an invalid index: $index" >&2
  exit 1
fi
if (( index < 0 || index >= ${#files[@]} )); then
  echo "Error: selected index out of range: $index" >&2
  exit 1
fi

selection=${files[index]}

# File might have been deleted meanwhile
if [[ ! -f "$selection" ]]; then
  echo "Error: selected file no longer exists: $selection" >&2
  exit 1
fi

# --- ensure swww is running ---
if ! swww query >/dev/null 2>&1; then
  if ! swww init >/dev/null 2>&1; then
    echo "Error: failed to initialize swww." >&2
    exit 1
  fi
  sleep 0.1
fi

# --- set wallpaper ---
swww img "$selection" \
  --transition-fps "$TRANSITION_FPS" \
  --transition-type "$TRANSITION_TYPE" \
  --transition-duration "$TRANSITION_DURATION"

