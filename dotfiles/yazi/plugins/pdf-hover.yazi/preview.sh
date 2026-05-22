#!/usr/bin/env bash
pdf="$1"
pid=$(pgrep -f '/zathura( |$)' | head -n1)

if [ -n "$pid" ] && dbus-send --session --print-reply \
        --dest="org.pwmt.zathura.PID-$pid" \
        /org/pwmt/zathura org.pwmt.zathura.OpenDocument \
        string:"$pdf" string:"" int32:0 >/dev/null 2>&1; then
    exit 0
fi

# adjust-open width in ~/.config/zathura/zathurarc handles fit-to-width on launch.
setsid zathura "$pdf" >/dev/null 2>&1 </dev/null &
