#!/usr/bin/env bash

set -euo pipefail

cookies_file="${YT_MUSIC_COOKIES:-$HOME/.cookies.txt}"
save_dir="${1:-}"

if [[ -z "$save_dir" ]]; then
  printf 'Usage: %s <save-dir>\n' "$(basename "$0")" >&2
  exit 1
fi

if ! command -v yt-dlp >/dev/null 2>&1; then
  printf 'yt-dlp is not installed.\n' >&2
  exit 1
fi

if [[ ! -d "$save_dir" ]]; then
  printf 'Save directory not found: %s\n' "$save_dir" >&2
  exit 1
fi

if [[ ! -f "$cookies_file" ]]; then
  printf 'Cookies file not found: %s\n' "$cookies_file" >&2
  exit 1
fi

escape_ffmpeg_value() {
  local value=${1//$'\n'/ }
  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  printf '%s' "$value"
}

url=""
while [[ -z "$url" ]]; do
  read -r -p 'Link: ' url
done

read -r -p 'Title (optional): ' title
read -r -p 'Artist (optional): ' artist
read -r -p 'Album (optional): ' album

postprocessor_args='ffmpeg:'

if [[ -n "$title" ]]; then
  postprocessor_args+=" -metadata title=\"$(escape_ffmpeg_value "$title")\""
fi

if [[ -n "$artist" ]]; then
  postprocessor_args+=" -metadata artist=\"$(escape_ffmpeg_value "$artist")\""
fi

if [[ -n "$album" ]]; then
  postprocessor_args+=" -metadata album=\"$(escape_ffmpeg_value "$album")\""
fi

args=(
  "$url"
  -f bestaudio
  --embed-metadata
  -P "$save_dir"
  --cookies "$cookies_file"
)

if [[ "$postprocessor_args" != 'ffmpeg:' ]]; then
  args+=(--postprocessor-args "$postprocessor_args")
fi

yt-dlp "${args[@]}"
