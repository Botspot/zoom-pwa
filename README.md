# Zoom PWA

Install Zoom's [new Progressive Web App](https://pwa.zoom.us/wc) (PWA) on any Linux computer that has Chromium installed.

## Download:
Run this command in a terminal:
```
git clone https://github.com/Botspot/zoom-pwa
```
## Install:
```
~/zoom-pwa/install.sh
```
After installing the Zoom PWA, the `~/zoom-pwa` folder is unnecessary and can be removed.

## Download and install with one command:
```
wget -qO- https://raw.githubusercontent.com/Botspot/zoom-pwa/main/install.sh | bash
```
## Uninstall:
```
rm -f ~/.local/share/applications/*gbmplfifepjenigdepeahbecfkcalfhg*
rm -rf ~/zoom-pwa
rm -rf ~/.config/Zoom-PWA
```

