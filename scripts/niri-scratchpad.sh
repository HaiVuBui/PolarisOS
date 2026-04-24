#!/usr/bin/env bash

set -euo pipefail

state_file="${XDG_RUNTIME_DIR:-/tmp}/niri-scratchpad-state.tsv"
legacy_scratch_name="__scratchpad"
hide_offset_x="+20000"
hide_offset_y="+20000"

usage() {
  cat <<'EOF'
Usage:
  niri-scratchpad.sh hide-focused
  niri-scratchpad.sh show-last
  niri-scratchpad.sh toggle <app-id> [spawn-command...]

Examples:
  niri-scratchpad.sh hide-focused
  niri-scratchpad.sh show-last
  niri-scratchpad.sh toggle kitty kitty
EOF
}

require_tools() {
  local cmd
  for cmd in jq niri mktemp; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      printf 'missing required command: %s\n' "$cmd" >&2
      exit 1
    fi
  done
}

ensure_state_dir() {
  mkdir -p "$(dirname "$state_file")"
  if [[ ! -f "$state_file" ]]; then
    : > "$state_file"
  fi
}

get_windows_json() {
  niri msg --json windows
}

get_workspaces_json() {
  niri msg --json workspaces
}

get_focused_window_json() {
  niri msg --json focused-window 2>/dev/null || printf 'null\n'
}

focused_workspace_ref() {
  jq -r '
    first(.[] | select(.is_focused) | (.name // (.idx | tostring))) // empty
  '
}

legacy_scratch_workspace_ref() {
  jq -r --arg name "$legacy_scratch_name" '
    first(.[] | select(.name == $name) | $name) // empty
  '
}

hidden_ids_json() {
  ensure_state_dir

  local ids=()
  local id app_id was_floating
  while IFS=$'\t' read -r id app_id was_floating; do
    if [[ -n "${id:-}" ]]; then
      ids+=("$id")
    fi
  done < "$state_file"

  if (( ${#ids[@]} == 0 )); then
    printf '[]\n'
    return 0
  fi

  printf '%s\n' "${ids[@]}" | jq -Rsc 'split("\n")[:-1] | map(tonumber)'
}

prune_state() {
  ensure_state_dir

  local windows_json="$1"
  local tmp_file id app_id was_floating
  declare -A live_ids=()

  while IFS= read -r id; do
    if [[ -n "$id" ]]; then
      live_ids["$id"]=1
    fi
  done < <(printf '%s\n' "$windows_json" | jq -r '.[].id')

  tmp_file="$(mktemp)"
  while IFS=$'\t' read -r id app_id was_floating; do
    if [[ -n "${id:-}" && -n "${live_ids[$id]:-}" ]]; then
      printf '%s\t%s\t%s\n' "$id" "$app_id" "$was_floating" >> "$tmp_file"
    fi
  done < "$state_file"

  mv "$tmp_file" "$state_file"
}

remove_hidden_window() {
  ensure_state_dir

  local target_id="$1"
  local tmp_file id app_id was_floating

  tmp_file="$(mktemp)"
  while IFS=$'\t' read -r id app_id was_floating; do
    if [[ -n "${id:-}" && "$id" != "$target_id" ]]; then
      printf '%s\t%s\t%s\n' "$id" "$app_id" "$was_floating" >> "$tmp_file"
    fi
  done < "$state_file"

  mv "$tmp_file" "$state_file"
}

add_hidden_window() {
  ensure_state_dir

  local id="$1"
  local app_id="$2"
  local was_floating="$3"

  remove_hidden_window "$id"
  printf '%s\t%s\t%s\n' "$id" "$app_id" "$was_floating" >> "$state_file"
}

hidden_window_meta() {
  ensure_state_dir

  local target_id="$1"
  local id app_id was_floating
  while IFS=$'\t' read -r id app_id was_floating; do
    if [[ -n "${id:-}" && "$id" == "$target_id" ]]; then
      printf '%s\t%s\n' "$app_id" "$was_floating"
      return 0
    fi
  done < "$state_file"

  return 1
}

last_hidden_window_id() {
  ensure_state_dir

  local target_app_id="${1:-}"
  local last_id=""
  local id app_id was_floating

  while IFS=$'\t' read -r id app_id was_floating; do
    if [[ -z "${id:-}" ]]; then
      continue
    fi
    if [[ -z "$target_app_id" || "$app_id" == "$target_app_id" ]]; then
      last_id="$id"
    fi
  done < "$state_file"

  printf '%s\n' "$last_id"
}

cleanup_legacy_scratch_workspace() {
  local workspaces_json="$1"
  local windows_json="$2"
  local legacy_ref legacy_has_windows

  legacy_ref="$(printf '%s\n' "$workspaces_json" | legacy_scratch_workspace_ref)"
  if [[ -z "$legacy_ref" ]]; then
    return 0
  fi

  legacy_has_windows="$(printf '%s\n' "$windows_json" | jq -r --arg name "$legacy_scratch_name" --argjson workspaces "$workspaces_json" '
    ($workspaces | first(.[] | select(.name == $name) | .id)) as $workspace_id
    | any(.[]; .workspace_id == $workspace_id)
  ')"

  if [[ "$legacy_has_windows" == "false" ]]; then
    niri msg action unset-workspace-name "$legacy_ref" >/dev/null
  fi
}

hide_window() {
  local window_id="$1"
  local app_id="$2"
  local was_floating="$3"

  if [[ "$was_floating" != "true" ]]; then
    niri msg action move-window-to-floating --id "$window_id" >/dev/null
  fi

  niri msg action move-floating-window --id "$window_id" --x "$hide_offset_x" --y "$hide_offset_y" >/dev/null
  add_hidden_window "$window_id" "$app_id" "$was_floating"
  niri msg action focus-window-previous >/dev/null 2>&1 || true
}

show_window() {
  local window_id="$1"
  local workspaces_json="$2"
  local app_id was_floating current_ref

  current_ref="$(printf '%s\n' "$workspaces_json" | focused_workspace_ref)"
  if [[ -z "$current_ref" ]]; then
    printf 'failed to resolve current workspace\n' >&2
    exit 1
  fi

  IFS=$'\t' read -r app_id was_floating < <(hidden_window_meta "$window_id" || printf '\ttrue\n')

  niri msg action move-window-to-workspace --window-id "$window_id" --focus false "$current_ref" >/dev/null
  niri msg action focus-window --id "$window_id" >/dev/null

  if [[ "$was_floating" == "true" ]]; then
    niri msg action center-window --id "$window_id" >/dev/null
  else
    niri msg action move-window-to-tiling --id "$window_id" >/dev/null
    niri msg action focus-window --id "$window_id" >/dev/null
  fi

  remove_hidden_window "$window_id"
}

hide_focused() {
  local focused_window focused_id focused_app_id was_floating windows_json workspaces_json hidden_id

  focused_window="$(get_focused_window_json)"
  if [[ "$focused_window" == "null" ]]; then
    exit 0
  fi

  focused_id="$(printf '%s\n' "$focused_window" | jq -r '.id // empty')"
  focused_app_id="$(printf '%s\n' "$focused_window" | jq -r '.app_id // empty')"
  was_floating="$(printf '%s\n' "$focused_window" | jq -r '.is_floating')"
  if [[ -z "$focused_id" ]]; then
    exit 0
  fi

  windows_json="$(get_windows_json)"
  prune_state "$windows_json"
  workspaces_json="$(get_workspaces_json)"
  cleanup_legacy_scratch_workspace "$workspaces_json" "$windows_json"

  hidden_id="$(last_hidden_window_id)"
  if [[ "$hidden_id" == "$focused_id" ]]; then
    exit 0
  fi

  hide_window "$focused_id" "$focused_app_id" "$was_floating"
}

show_last() {
  local windows_json workspaces_json window_id

  windows_json="$(get_windows_json)"
  prune_state "$windows_json"
  workspaces_json="$(get_workspaces_json)"
  cleanup_legacy_scratch_workspace "$workspaces_json" "$windows_json"

  window_id="$(last_hidden_window_id)"
  if [[ -z "$window_id" ]]; then
    exit 0
  fi

  show_window "$window_id" "$workspaces_json"
}

toggle_app() {
  local app_id="$1"
  shift || true

  local spawn_cmd=("$@")
  local windows_json workspaces_json focused_window focused_id focused_app_id was_floating hidden_window_id hidden_ids visible_window_id

  windows_json="$(get_windows_json)"
  prune_state "$windows_json"
  workspaces_json="$(get_workspaces_json)"
  cleanup_legacy_scratch_workspace "$workspaces_json" "$windows_json"
  focused_window="$(get_focused_window_json)"
  hidden_window_id="$(last_hidden_window_id "$app_id")"
  hidden_ids="$(hidden_ids_json)"

  focused_id="$(printf '%s\n' "$focused_window" | jq -r '.id // empty')"
  focused_app_id="$(printf '%s\n' "$focused_window" | jq -r '.app_id // empty')"
  was_floating="$(printf '%s\n' "$focused_window" | jq -r '.is_floating // false')"

  if [[ "$focused_app_id" == "$app_id" && -n "$focused_id" ]]; then
    hide_window "$focused_id" "$focused_app_id" "$was_floating"
    exit 0
  fi

  if [[ -n "$hidden_window_id" ]]; then
    show_window "$hidden_window_id" "$workspaces_json"
    exit 0
  fi

  visible_window_id="$(printf '%s\n' "$windows_json" | jq -r --arg app_id "$app_id" --argjson hidden_ids "$hidden_ids" '
    [ .[]
      | select(.app_id == $app_id)
      | select(($hidden_ids | index(.id)) | not)
      | { id, secs: (.focus_timestamp.secs // 0), nanos: (.focus_timestamp.nanos // 0) }
    ]
    | sort_by(.secs, .nanos)
    | last
    | .id // empty
  ')"

  if [[ -n "$visible_window_id" ]]; then
    niri msg action focus-window --id "$visible_window_id" >/dev/null
    exit 0
  fi

  if [[ ${#spawn_cmd[@]} -gt 0 ]]; then
    niri msg action spawn "${spawn_cmd[@]}" >/dev/null
  fi
}

main() {
  require_tools
  ensure_state_dir

  if [[ $# -lt 1 ]]; then
    usage
    exit 1
  fi

  case "$1" in
    hide-focused)
      hide_focused
      ;;
    show-last)
      show_last
      ;;
    toggle)
      if [[ $# -lt 2 ]]; then
        usage
        exit 1
      fi
      shift
      toggle_app "$@"
      ;;
    -h|--help|help)
      usage
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
