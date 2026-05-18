#!/bin/sh
input=$(cat)

# Context used percentage
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used" ]; then
  ctx=$(printf "%.0f%%" "$used")
else
  ctx="ctx:--"
fi

# Model display name
model=$(echo "$input" | jq -r '.model.display_name // "unknown"')

# Thinking effort
effort=$(echo "$input" | jq -r '.effort.level // empty')
if [ -n "$effort" ]; then
  effort_str="effort:$effort"
else
  effort_str=""
fi

# Plan vs action mode (output_style name)
style=$(echo "$input" | jq -r '.output_style.name // empty')
case "$style" in
  *[Pp]lan*) mode="PLAN" ;;
  *[Aa]ction*|*[Aa]ct*) mode="ACT" ;;
  "") mode="" ;;
  *) mode="$style" ;;
esac

# Assemble parts
parts="ctx:$ctx | $model"
[ -n "$effort_str" ] && parts="$parts | $effort_str"
[ -n "$mode" ] && parts="$parts | $mode"

printf "%s" "$parts"
