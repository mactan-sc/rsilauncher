#!/bin/sh
set -eua pipefail

cd "$XDG_DATA_HOME"
source /app/constants.sh

mkdir -p "$launcher_cfg_path"
if [ ! -f "$launcher_cfg_path/$launcher_cfg" ]; then
  cp "/app/launcher.cfg" "$launcher_cfg_path"
fi
source "$XDG_CONFIG_HOME/starcitizen-lug/launcher.cfg"

VERSION="$(curl -s 'https://install.robertsspaceindustries.com/rel/2/latest.yml' | yq -r '.version')"
Launcher_setup_exe_url="https://install.robertsspaceindustries.com/rel/2/RSI%20Launcher-Setup-$VERSION.exe"
installer_name="RSI-Launcher-setup.exe"

launcher_exe_path="$WINEPREFIX/drive_c/Program Files/Roberts Space Industries/RSI Launcher/RSI Launcher.exe"

# Install if the RSI Launcher exe does not exist
if ! [ -f "$launcher_exe_path" ]; then

  # Format the curl progress bar for zenity
  FIFO=$(mktemp -u)
  mkfifo "$FIFO"
  curl -#L "$Launcher_setup_exe_url" -o "$installer_name" > "$FIFO" 2>&1 & curlpid="$!"
  stdbuf -oL tr '\r' '\n' < "$FIFO" | \
  grep --line-buffered -ve "100" | grep --line-buffered -o "[0-9]*\.[0-9]" | \
  (
      trap 'kill "$curlpid"' ERR
      zenity --progress --auto-close --title="RSI Launcher Installer" --text="Downloading RSI Launcher.\n\nThis might take a moment.\n" 2>/dev/null
  )

  if [ "$?" -eq 1 ]; then
      # User clicked cancel
      debug_print continue "Download aborted. Removing $installer_name..."
      rm --interactive=never "$installer_name"
      rm --interactive=never "$FIFO"
      return 1
  fi
  rm --interactive=never "$FIFO"

  # Temporarily force DX11 while we wait for CIG to fix color inversion in Vulkan
  mkdir -p "${WINEPREFIX}/drive_c/Program Files/Roberts Space Industries/StarCitizen/LIVE"
  echo "r.graphicsRenderer = 0" > "${WINEPREFIX}/drive_c/Program Files/Roberts Space Industries/StarCitizen/LIVE/USER.cfg"

  WINE_NO_PRIV_ELEVATION=1 WINEDLLOVERRIDES="dxwebsetup.exe,dotNetFx45_Full_setup.exe=d" umu-run "$installer_name" /S  | zenity --progress \
    --pulsate \
    --no-cancel \
    --auto-close \
    --title="RSI Launcher Installer" \
    --text="Preparing the proton prefix\n"

  if [ $? -eq 0 ]; then
    zenity --info --text="Installation complete.\n\nyou may now launch the RSI Launcher."
  else
    zenity --error --text="Installation failed."
  fi

  rm "$installer_name"
  exit 0 # Prevent running twice after first installation
fi

echo "Game installation detected. Running now..."
umu-run "$launcher_exe_path"
