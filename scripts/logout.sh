#!/usr/bin/env bash

# Get the hostname dynamically
host_name="$(hostname)"

# --- commands ---
LOCK_CMD="hyprlock"
LOGOUT_CMD="niri msg action quit --skip-confirmation"
REBOOT_CMD="systemctl reboot"
POWEROFF_CMD="systemctl poweroff"
SUSPEND_CMD="systemctl suspend"
HIBERNATE_CMD="systemctl hibernate"

DELAY_BEFORE_SLEEP=3 

# --- rofi config ---
ROFI_CMD=(
  rofi \
    -dmenu \ 
    -i \
    # -p "Deactivating $(hostname)" \
    -l 6 \
    -theme-str '
    window { width: 10%; }
    '
)

# --- menu entries ---
# Define the dynamic string here so we can reuse it in the case statement

options=(
  "  Lock"
  "󰍃  Logout"   
  "  Suspend"
  "  Reboot"
  "  Shutdown"
  "󰤄  Hibernate"
)

choice="$(printf '%s\n' "${options[@]}" | "${ROFI_CMD[@]}")"

case "$choice" in
    "  Lock")
        $LOCK_CMD
        ;;

    "󰍃  Logout")  # <--- Updated to match the variable
        $LOGOUT_CMD
        ;;

    "  Reboot")
        $REBOOT_CMD
        ;;

    "  Shutdown")
        $POWEROFF_CMD
        ;;

    "  Suspend")
        $LOCK_CMD &
        sleep "$DELAY_BEFORE_SLEEP"
        $SUSPEND_CMD
        ;;

    "󰤄  Hibernate")
        $LOCK_CMD &
        sleep "$DELAY_BEFORE_SLEEP"
        $HIBERNATE_CMD
        ;;

    *)
        exit 0
        ;;
esac
