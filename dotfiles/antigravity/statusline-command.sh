#!/usr/bin/env bash
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

# Thinking effort (in case it gets added to Antigravity CLI)
effort=$(echo "$input" | jq -r '.effort.level // empty')
if [ -n "$effort" ] && [ "$effort" != "null" ]; then
  effort_str="effort:$effort"
else
  effort_str=""
fi

# Dynamic detection of active model quota (gemini vs 3p)
model_id_lower=$(echo "$input" | jq -r '.model.id // "unknown"' | tr '[:upper:]' '[:lower:]')
if [[ "$model_id_lower" == *gemini* ]]; then
  quota_prefix="gemini"
else
  quota_prefix="3p"
fi

# 5-hour session rate limit
five_pct=$(echo "$input" | jq -r ".quota[\"${quota_prefix}-5h\"].remaining_fraction | select(. != null) | (1 - .) * 100 | round")
five_reset_in_seconds=$(echo "$input" | jq -r ".quota[\"${quota_prefix}-5h\"].reset_in_seconds // empty")

if [ -n "$five_pct" ] && [ "$five_pct" != "null" ]; then
  if [ -n "$five_reset_in_seconds" ] && [ "$five_reset_in_seconds" != "null" ] && [ "$five_reset_in_seconds" -gt 0 ]; then
    secs_left=$five_reset_in_seconds
    mins_left=$(( secs_left / 60 ))
    hrs_left=$(( mins_left / 60 ))
    mins_rem=$(( mins_left % 60 ))
    if [ "$hrs_left" -gt 0 ]; then
      five_str="5h:${five_pct}% (${hrs_left}h${mins_rem}m)"
    else
      five_str="5h:${five_pct}% (${mins_left}m)"
    fi
  else
    five_str="5h:${five_pct}%"
  fi
else
  five_str=""
fi

# Weekly rate limit
week_pct=$(echo "$input" | jq -r ".quota[\"${quota_prefix}-weekly\"].remaining_fraction | select(. != null) | (1 - .) * 100 | round")
week_reset_in_seconds=$(echo "$input" | jq -r ".quota[\"${quota_prefix}-weekly\"].reset_in_seconds // empty")

if [ -n "$week_pct" ] && [ "$week_pct" != "null" ]; then
  if [ -n "$week_reset_in_seconds" ] && [ "$week_reset_in_seconds" != "null" ] && [ "$week_reset_in_seconds" -gt 0 ]; then
    secs_left=$week_reset_in_seconds
    days_left=$(( secs_left / 86400 ))
    hrs_rem=$(( (secs_left % 86400) / 3600 ))
    if [ "$days_left" -gt 0 ]; then
      week_str="7d:${week_pct}% (${days_left}d${hrs_rem}h)"
    else
      mins_left=$(( secs_left / 60 ))
      if [ "$mins_left" -gt 60 ]; then
        hrs_left=$(( mins_left / 60 ))
        mins_rem=$(( mins_left % 60 ))
        week_str="7d:${week_pct}% (${hrs_left}h${mins_rem}m)"
      else
        week_str="7d:${week_pct}% (${mins_left}m)"
      fi
    fi
  else
    week_str="7d:${week_pct}%"
  fi
else
  week_str=""
fi

# Assemble parts
parts="ctx:$ctx | $model"
[ -n "$effort_str" ] && parts="$parts | $effort_str"
[ -n "$five_str" ]   && parts="$parts | $five_str"
[ -n "$week_str" ]   && parts="$parts | $week_str"

printf "%s" "$parts"
