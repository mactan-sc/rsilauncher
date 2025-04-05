#!/bin/bash
set -euo pipefail

cd icons
./extract_icons.sh
cd ..

flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak-builder --repo=out --default-branch=stable --gpg-sign=61FC62350FD19AAE4FE015577A958B0126A889A4 --require-changes --rebuild-on-sdk-change --install --install-deps-from=flathub --user --ccache --force-clean build-dir com.rsilauncher.RSILauncher.yml
flatpak build-update-repo --gpg-sign=61FC62350FD19AAE4FE015577A958B0126A889A4 out --title="RSI Launcher" --generate-static-deltas --default-branch=stable --prune
