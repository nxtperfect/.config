#!/bin/sh

USER=nxtperfect

PID=$(pgrep -u "$USER" -x mango | head -n1)
[ -n "$PID" ] || exit 1

tr '\0' '\n' < "/proc/$PID/environ" |
grep -E '^(DBUS_SESSION_BUS_ADDRESS|WAYLAND_DISPLAY|DISPLAY|XDG_RUNTIME_DIR)=' |
while IFS='=' read -r key value; do
    printf 'export %s=%q\n' "$key" "$value"
done
printf 'export DISPLAY=:1'
