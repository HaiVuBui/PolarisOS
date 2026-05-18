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

# 5-hour session rate limit
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [ -n "$five_pct" ]; then
  five_used=$(printf "%.0f" "$five_pct")
  if [ -n "$five_reset" ]; then
    now=$(date +%s)
    secs_left=$(( five_reset - now ))
    if [ "$secs_left" -le 0 ]; then
      five_str="5h:${five_used}% (reset)"
    else
      mins_left=$(( secs_left / 60 ))
      hrs_left=$(( mins_left / 60 ))
      mins_rem=$(( mins_left % 60 ))
      if [ "$hrs_left" -gt 0 ]; then
        five_str="5h:${five_used}% (${hrs_left}h${mins_rem}m)"
      else
        five_str="5h:${five_used}% (${mins_left}m)"
      fi
    fi
  else
    five_str="5h:${five_used}%"
  fi
else
  five_str=""
fi

# 7-day weekly rate limit
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
if [ -n "$week_pct" ]; then
  week_used=$(printf "%.0f" "$week_pct")
  if [ -n "$week_reset" ]; then
    now=$(date +%s)
    secs_left=$(( week_reset - now ))
    if [ "$secs_left" -le 0 ]; then
      week_str="7d:${week_used}% (reset)"
    else
      days_left=$(( secs_left / 86400 ))
      hrs_rem=$(( (secs_left % 86400) / 3600 ))
      if [ "$days_left" -gt 0 ]; then
        week_str="7d:${week_used}% (${days_left}d${hrs_rem}h)"
      else
        mins_left=$(( secs_left / 60 ))
        week_str="7d:${week_used}% (${mins_left}m)"
      fi
    fi
  else
    week_str="7d:${week_used}%"
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
