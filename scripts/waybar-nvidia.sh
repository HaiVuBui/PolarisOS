#!/usr/bin/env bash

STATE_FILE="/tmp/waybar-nvidia-mode"

if [ "${1:-}" = "toggle" ]; then
  if [ -f "${STATE_FILE}" ] && grep -q '^vram$' "${STATE_FILE}"; then
    echo "percent" > "${STATE_FILE}"
  else
    echo "vram" > "${STATE_FILE}"
  fi
  exit 0
fi

if ! command -v nvidia-smi >/dev/null 2>&1; then
  echo "n/a"
  exit 0
fi

mode="percent"
if [ -f "${STATE_FILE}" ]; then
  mode="$(cat "${STATE_FILE}" 2>/dev/null)"
fi

case "${mode}" in
  percent)
    read -r util < <(LC_ALL=C nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n 1 | tr -d '\r')
    if [ -z "${util}" ]; then
      echo "n/a"
      exit 0
    fi
    util="${util%.*}"
    echo "${util}%"
    ;;
  vram|*)
    read -r util mem_used mem_total < <(LC_ALL=C nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits | head -n 1 | tr -d '\r' | tr -d ',')
    if [ -z "${mem_used}" ] || [ -z "${mem_total}" ]; then
      echo "n/a"
      exit 0
    fi
    mem_used="${mem_used%.*}"
    mem_total="${mem_total%.*}"
    echo "${mem_used}/${mem_total}MB"
    ;;
esac
