#!/bin/sh
set -eua pipefail

cd "$XDG_DATA_HOME"
source /app/constants.sh

mkdir -p "$launcher_cfg_path"
if [ ! -f "$launcher_cfg_path/$launcher_cfg" ]; then
  cp "/app/launcher.cfg" "$launcher_cfg_path"
fi
source "$XDG_CONFIG_HOME/starcitizen-lug/launcher.cfg"

Launcher_setup_exe_url="https://install.robertsspaceindustries.com/rel/2/RSI%20Launcher-Setup-2.3.1.exe"
installer_name="RSI-Launcher-setup.exe"

launcher_exe_path="$WINEPREFIX/drive_c/Program Files/Roberts Space Industries/RSI Launcher/RSI Launcher.exe"

# Install if the RSI Launcher exe does not exist
if ! [ -f "$launcher_exe_path" ]; then
  curl -o "$installer_name" -L "$Launcher_setup_exe_url"
  WINE_NO_PRIV_ELEVATION=1 umu-run "$installer_name"
  rm "$installer_name"
  exit 0 # Prevent running twice after first installation
fi

echo "Game installation detected. Running now..."
umu-run "$launcher_exe_path"
