#!/bin/bash
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
LAUNCHER_EXE_NAME="RSI-Launcher.exe"

curl -L "https://install.robertsspaceindustries.com/rel/2/RSI%20Launcher-Setup-2.3.1.exe" -o "$LAUNCHER_EXE_NAME"

wrestool -x --output=RSI-Launcher.ico -t14 "$LAUNCHER_EXE_NAME"
convert "RSI-Launcher.ico" "RSI-Launcher.png"

mkdir -p 256
mv "RSI-Launcher-3.png" "256/RSI-Launcher.png"

# Cleanup
ls -p | grep -v / | grep -v "extract_icons.sh" | xargs -n1 rm
