## Disclaimer
This is in no way affiliated with Cloud Imperium Games and running the launcher through linux is unsupported by them. 

Any issues should be reported here. Use at your own risk.

## What is this?
RSI Launcher packaged in a flatpak based on https://github.com/nmlynch94/com.eveonline.EveOnline

Includes GUI maintenance experience

Command line arguments are available for quickly launching functions from the terminal.

For Star Citizen Linux User Group community tools visit https://github.com/starcitizen-lug


## Configuration 

Override game location using CLI or Flatseal
- flatpak override --user --filesystem=/path/to/your/prefix
- flatpak override --user --env=WINEPREFIX=/path/to/your/prefix io.github.mactan_sc.RSILauncher

Common configuration options
- Shader Cache location
- Logging
- MangoHud / DXVK Hud
- Wayland
- HDR

Use Flatpak CLI, Flatseal, or the provided `RSI Maintenance` tool to open your config file for editing. Configuration is saved in $XDG_CONFIG_HOME/starcitizen-lug
- $HOME/.var/app/io.github.mactan_sc.RSILauncher/config/starcitizen-lug/rsilauncher.cfg
- $HOME/.config/starcitizen-lug/rsilauncher.cfg


## Options
`flatpak run io.github.mactan_sc.RSILauncher`
  - Launch the RSI Launcher

- Launch Wine Control Panel
```
flatpak run --command=umu-run io.github.mactan_sc.RSILauncher control
```

- Launch Wine Winecfg
```
flatpak run --command=umu-run io.github.mactan_sc.RSILauncher winecfg
```

- Launch Wine Regedit
```
flatpak run --command=umu-run io.github.mactan_sc.RSILauncher regedit
```

- Launch Maintenance Menu
```
flatpak run --command=rsi-maintenance  io.github.mactan_sc.RSILauncher
```

## Installation

### Repo (automated updates)
Flatpak repository or [latest release](https://github.com/mactan-sc/rsilauncher/releases/latest)  
1.  Add the repo
```
flatpak remote-add --user --if-not-exists RSILauncher https://mactan-sc.github.io/rsilauncher/RSILauncher.flatpakrepo
```
2.  install the rsi launcher flatpak
```  
flatpak install -y --user --noninteractive RSILauncher io.github.mactan_sc.RSILauncher
```
3.  run the rsi launcher flatpak
```
flatpak run io.github.mactan_sc.RSILauncher
```

<p align="center">
  <img src="https://github.com/user-attachments/assets/b999fb69-9c37-4757-8dd8-524b25624f99" alt="MadeByTheCommunity_White_25" />
</p>
