# Zoom PWA
Install Zoom's [new Progressive Web App](https://pwa.zoom.us/wc) on any Linux computer that has Chromium installed.

## Easily install with [Pi-Apps](https://github.com/Botspot/pi-apps):
[![badge](https://github.com/Botspot/pi-apps/blob/master/icons/badge.png?raw=true)](https://github.com/Botspot/pi-apps)  

## Manual download:
Run this command in a terminal:
```
git clone https://github.com/Botspot/zoom-pwa
```
## Install:
```
./zoom-pwa/install.sh
```
After installing the Zoom PWA, the `~/zoom-pwa` folder is unnecessary and can be removed.

## Download and install with one command:
```
wget -qO- https://raw.githubusercontent.com/Botspot/zoom-pwa/main/install.sh | bash
```
## Run Zoom:
Menu -> Internet -> Zoom
## Uninstall:
```
rm -f ~/.local/share/applications/*gbmplfifepjenigdepeahbecfkcalfhg*
rm -rf ./zoom-pwa
rm -rf ~/.config/Zoom-PWA
```

