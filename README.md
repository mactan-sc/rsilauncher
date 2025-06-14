## Disclaimer
This is in no way affiliated with Cloud Imperium Games and running the launcher through linux is unsupported by them. 

Any issues should be reported here. Use at your own risk.

## What is this?
RSI Launcher packaged in a flatpak based on https://github.com/nmlynch94/com.eveonline.EveOnline

Zenity menus are used for a GUI maintenance experience

Command line arguments are available for quickly launching functions from the terminal.

For Star Citizen Linux User Group community tools visit https://github.com/starcitizen-lug


## Configuration 

Configuration is saved in $XDG_CONFIG_HOME/starcitizen-lug/
- $HOME/.var/app/io.github.mactan_sc.RSILauncher/config/starcitizen-lug/rsilauncher.cfg
- $HOME/.config/starcitizen-lug/rsilauncher.cfg


## Options
`flatpak run io.github.mactan_sc.RSILauncher`
  - Launch the RSI Launcher

`flatpak run --command=control io.github.mactan_sc.RSILauncher`
  - Launch Wine Control Panel

`flatpak run --command=winecfg io.github.mactan_sc.RSILauncher`
  - Launch Wine Winecfg

`flatpak run --command=rsi-maintenance  io.github.mactan_sc.RSILauncher`
  - Launch Maintenance Menu

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
