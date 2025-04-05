#!/bin/sh
export GAMEID="umu-starcitizen"
export STORE="none"
export WINEPREFIX="$XDG_DATA_HOME"/prefix
export PROTONPATH="$XDG_DATA_HOME/proton"

# Nvidia cache options
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_SIZE=10737418240
export __GL_SHADER_DISK_CACHE_PATH="$WINEPREFIX"
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
# Mesa (AMD/Intel) shader cache options
export MESA_SHADER_CACHE_DIR="$WINEPREFIX"
export MESA_SHADER_CACHE_MAX_SIZE="10G"

export PROTON_LATEST_URL="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton9-26/GE-Proton9-26.tar.gz"
export PROTON_LATEST_SHA512="6589a3d5561948f738f59309c93953f1e74a282f4945077188ee866c517e8a2d8196715f484b8e1097964962f3ec047e22da2012df25e81238a96d25d3285091"