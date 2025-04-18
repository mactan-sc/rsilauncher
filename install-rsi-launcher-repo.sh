#!/bin/bash
FREEDESKTOP_VERSION="24.08"

set -e

HAS_NVIDIA=0
if [[ -f /proc/driver/nvidia/version ]]; then
    HAS_NVIDIA=1
    NVIDIA_VERSION=$(sed -n 's/^NVRM version:.* \([0-9]\+\.[0-9]\+\.[0-9]\+\) .*/\1/p' /proc/driver/nvidia/version | sed 's/\./-/g')
fi

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user --if-not-exists RSILauncher https://mactan-sc.github.io/rsilauncher/RSILauncher.flatpakrepo

# https://github.com/flatpak/flatpak/issues/3094
flatpak install --user -y --noninteractive flathub \
    org.freedesktop.Platform//${FREEDESKTOP_VERSION} \
    org.freedesktop.Platform.Compat.i386/x86_64/${FREEDESKTOP_VERSION} \
    org.freedesktop.Platform.GL32.default/x86_64/${FREEDESKTOP_VERSION}

if [[ ${HAS_NVIDIA} -eq 1 ]]; then
    flatpak install --user -y --noninteractive flathub \
        org.freedesktop.Platform.GL.nvidia-${NVIDIA_VERSION}/x86_64 \
        org.freedesktop.Platform.GL32.nvidia-${NVIDIA_VERSION}/x86_64
fi

flatpak install -y --user --noninteractive RSILauncher io.github.mactan_sc.RSILauncher

# Perform first time setup
flatpak run io.github.mactan_sc.RSILauncher
echo "DONE. You should now be able to launch from your application menu"
