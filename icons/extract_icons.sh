#!/bin/bash
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
LAUNCHER_EXE_NAME="RSI-Launcher.exe"

curl -L "https://install.robertsspaceindustries.com/rel/2/RSI%20Launcher-Setup-2.4.0.exe" -o "$LAUNCHER_EXE_NAME"

wrestool -x --output=RSI-Launcher.ico -t14 "$LAUNCHER_EXE_NAME"
convert "RSI-Launcher.ico" "RSI-Launcher.png"
convert RSI-Launcher-3.png wrench-256.png -geometry 75x75+175+10 -composite RSI-Launcher-Maintenance.png

mkdir -p 256
mv "RSI-Launcher-3.png" "256/RSI-Launcher.png"
mv "RSI-Launcher-Maintenance.png" "256/RSI-Launcher-Maintenance.png"

# Cleanup
ls -p | grep -v / | grep -v "extract_icons.sh\|wrench-256.png" | xargs -n1 rm
