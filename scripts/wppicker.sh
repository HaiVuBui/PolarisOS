#!/usr/bin/env bash
# pick-wall.sh — choose a wallpaper via rofi and set it with swww

set -euo pipefail
IFS=$'\n\t'

# --- config ---
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_WALLPAPERS="$(cd -- "$SCRIPT_DIR/.." && pwd)/wallpapers"
DEFAULT_DIR="${HOME}/Wallpapers"
if [[ ! -d "$DEFAULT_DIR" && -d "$REPO_WALLPAPERS" ]]; then
  DEFAULT_DIR="$REPO_WALLPAPERS"
fi
DIR="${1:-$DEFAULT_DIR}"

TRANSITION_FPS=120
TRANSITION_TYPE=outer
TRANSITION_DURATION=3
MAX_ROWS=10

usage() {
  cat >&2 <<EOF
Usage: ${0##*/} [DIRECTORY]

Pick a wallpaper from DIRECTORY (default: $DEFAULT_DIR)
using rofi and set it via awww or swww.
EOF
  exit 1
}

if [[ "${1-}" == "-h" || "${1-}" == "--help" ]]; then
  usage
fi

# --- required base commands (except fd/find, handled separately) ---
for cmd in rofi sort; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: required command not found in PATH: $cmd" >&2
    exit 1
  fi
done

# --- choose wallpaper backend ---
WALL_BACKEND=""
if command -v awww >/dev/null 2>&1; then
  WALL_BACKEND="awww"
elif command -v swww >/dev/null 2>&1; then
  WALL_BACKEND="swww"
else
  echo "Error: neither awww nor swww is available in PATH." >&2
  exit 1
fi

if [[ "$WALL_BACKEND" == "awww" ]] && ! command -v awww-daemon >/dev/null 2>&1; then
  echo "Error: awww is installed but awww-daemon is missing from PATH." >&2
  exit 1
fi

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
      . "$DIR" 2>/dev/null | LC_ALL=C sort -z
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
      \) -print0 2>/dev/null | LC_ALL=C sort -z
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

# --- show relative paths in rofi, get INDEX back ---
display=()
for f in "${files[@]}"; do
  display+=("${f#"$DIR"/}")
done

index="$(
  printf '%s\n' "${display[@]}" |
rofi -dmenu \
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

# --- ensure backend daemon is running ---
if [[ "$WALL_BACKEND" == "awww" ]]; then
  if ! awww query >/dev/null 2>&1; then
    awww-daemon --quiet >/dev/null 2>&1 &
    ready=0
    for _ in {1..30}; do
      if awww query >/dev/null 2>&1; then
        ready=1
        break
      fi
      sleep 0.1
    done
    if (( ready == 0 )); then
      echo "Error: failed to start awww-daemon." >&2
      exit 1
    fi
  fi

  # --- set wallpaper via awww ---
  awww img "$selection" \
    --transition-fps "$TRANSITION_FPS" \
    --transition-type "$TRANSITION_TYPE" \
    --transition-duration "$TRANSITION_DURATION"
else
  if ! swww query >/dev/null 2>&1; then
    if ! swww init >/dev/null 2>&1; then
      echo "Error: failed to initialize swww." >&2
      exit 1
    fi
    sleep 0.1
  fi

  # --- set wallpaper via swww ---
  swww img "$selection" \
    --transition-fps "$TRANSITION_FPS" \
    --transition-type "$TRANSITION_TYPE" \
    --transition-duration "$TRANSITION_DURATION"
fi
