#!/bin/sh
set -eua pipefail

cd "$XDG_DATA_HOME"
source /app/constants.sh

Launcher_setup_exe_url="https://install.robertsspaceindustries.com/rel/2/RSI%20Launcher-Setup-2.3.1.exe"
installer_name="RSI-Launcher-setup.exe"

launcher_exe_path="$WINEPREFIX/drive_c/Program Files/Roberts Space Industries/RSI Launcher/RSI Launcher.exe"

# Install if the RSI Launcher exe does not exist
if ! [ -f "$launcher_exe_path" ]; then
  echo "First time install"
  curl -o "proton.tar.gz" -L "$PROTON_LATEST_URL"

  # Validate checksum
  echo "Validating checksum equals $PROTON_LATEST_SHA512"
  echo "$PROTON_LATEST_SHA512 proton.tar.gz" | sha512sum --check
  echo "Checksum is valid"

  # Install proton
  mkdir proton
  tar -xzf "proton.tar.gz" -C proton --strip-components=1

  # Install dotnet8 and launch
  umu-run winetricks -q arial tahoma powershell win10
  curl -o "$installer_name" -L "$Launcher_setup_exe_url"
  WINE_NO_PRIV_ELEVATION=1 umu-run "$installer_name"
  rm "$installer_name"
  exit 0 # Prevent running twice after first installation
fi

echo "Game installation detected. Running now..."
umu-run "$launcher_exe_path"
