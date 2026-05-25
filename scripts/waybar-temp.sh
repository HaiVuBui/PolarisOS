#!/usr/bin/env bash

# Read CPU temp from the coretemp or k10temp hwmon entry (index shifts across boots)
cpu_temp=""
for hwmon in /sys/class/hwmon/hwmon*; do
    name="$(cat "$hwmon/name" 2>/dev/null)"
    if [ "$name" = "coretemp" ] || [ "$name" = "k10temp" ]; then
        raw="$(cat "$hwmon/temp1_input" 2>/dev/null)"
        if [ -n "$raw" ]; then
            cpu_temp="$((raw / 1000))°C"
        fi
        break
    fi
done

[ -z "$cpu_temp" ] && cpu_temp="n/a"

if command -v nvidia-smi >/dev/null 2>&1; then
    gpu_temp="$(LC_ALL=C nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n 1 | tr -d '\r ')"
    if [ -n "$gpu_temp" ]; then
        echo "${cpu_temp}  󰾲 ${gpu_temp}°C"
        exit 0
    fi
fi

echo "$cpu_temp"
