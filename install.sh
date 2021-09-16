#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}

if ! command -v git &>/dev/null ;then
  echo "Installing git..."
  sudo apt install -y git
  if ! command -v git &>/dev/null ;then
    error "git failed to install somehow!"
  fi
fi

DIRECTORY="$(readlink -f "$(dirname "$0")")"

if [ ! -d "$DIRECTORY" ] || [ "$DIRECTORY" == "$HOME" ] || [ "$0" == bash ];then
  echo "Downloading zoom-pwa repo..."
  git clone https://github.com/Botspot/zoom-pwa || error "failed to git clone!"
  DIRECTORY="$(pwd)/zoom-pwa"
fi
echo "Parent folder of this script: $DIRECTORY"

if command -v chromium-browser &>/dev/null;then
  browser="$(command -v chromium-browser)"
elif command -v chromium &>/dev/null;then
  browser="$(command -v chromium)"
elif command -v google-chrome &>/dev/null;then
  browser="$(command -v google-chrome)"
else
  error "You must have Chromium Browser installed to use the Zoom PWA!"
fi

#make chromium config with zoom pre-installed
echo "Generating Chromium config..."
rm -rf ~/.config/Zoom-PWA
mkdir -p ~/.config/Zoom-PWA/Default
cp "$DIRECTORY"/Preferences ~/.config/Zoom-PWA/Default/Preferences
echo '' > ~/'.config/Zoom-PWA/First Run'
sed -i "s+/home/pi+$HOME+g" ~/.config/Zoom-PWA/Default/Preferences

echo "Copying icons to $HOME/.local/share/icons/hicolor ..."
mkdir -p ~/.local/share/icons/hicolor
cp -a "$DIRECTORY"/icons/. ~/.local/share/icons/hicolor

echo "Creating menu launcher..."
rm -f ~/.local/share/applications/*gbmplfifepjenigdepeahbecfkcalfhg*
mkdir -p ~/.local/share/applications
#create menu launcher
echo "#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Terminal=false
Type=Application
Name=Zoom PWA
Comment=Launch the Zoom Progressive Web App with Chromium browser
Exec=$browser --user-data-dir=$HOME/.config/Zoom-PWA --profile-directory=Default --app-id=gbmplfifepjenigdepeahbecfkcalfhg
Icon=chrome-gbmplfifepjenigdepeahbecfkcalfhg-Default
StartupWMClass=crx_gbmplfifepjenigdepeahbecfkcalfhg
Categories=Network;WebBrowser;
StartupNotify=true" >> ~/.local/share/applications/chrome-gbmplfifepjenigdepeahbecfkcalfhg-Zoom-PWA.desktop

echo 'Done!'
