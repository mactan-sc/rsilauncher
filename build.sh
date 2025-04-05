#!/bin/bash
set -euo pipefail

cd icons
./extract_icons.sh
cd ..

flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak-builder --repo=out --default-branch=stable --gpg-sign=857F4253FD6E81B8C19F4869554B1F4AE6FB20F8 --require-changes --rebuild-on-sdk-change --install --install-deps-from=flathub --user --ccache --force-clean build-dir com.rsilauncher.RSILauncher.yml
flatpak build-update-repo --gpg-sign=857F4253FD6E81B8C19F4869554B1F4AE6FB20F8 out --title="RSI Launcher" --generate-static-deltas --default-branch=stable --prune
