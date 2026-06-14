#!/usr/bin/env bash
# PreToolUse(Bash) guard: redirect token-heavy commands to rtk wrappers.
# ponytail: first-word match only; good enough, widen the regex if it misses cases.
cmd=$(jq -r '.tool_input.command // ""' | sed -E 's/^[[:space:]]*//')
first=${cmd%%[[:space:]]*}

case "$first" in
  rtk|sudo) exit 0 ;;
  ls|tree|grep|find|git|gh|cat|wc|wget|diff)
    echo "Use 'rtk $first' instead of '$first' — rtk proxies it with token-optimized output." >&2
    exit 2
    ;;
esac
exit 0
