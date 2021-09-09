#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}

if ! command -v yad &>/dev/null ;then
  echo "Installing yad..."
  sudo apt install -y yad
  if ! command -v yad &>/dev/null ;then
    error "YAD failed to install somehow!"
  fi
fi

if ! command -v git &>/dev/null ;then
  echo "Installing git..."
  sudo apt install -y git
  if ! command -v git &>/dev/null ;then
    error "git failed to install somehow!"
  fi
fi

if [ ! -d ~/zoom-pwa ];then
  echo "Downloading zoom-pwa repo now..."
  cd ~/
  git clone https://github.com/Botspot/zoom-pwa || error "failed to git clone!"
fi
cd ~/zoom-pwa

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
rm -rf ~/.config/Zoom-PWA
mkdir -p ~/.config/Zoom-PWA/Default
cp "$(pwd)"/Preferences ~/.config/Zoom-PWA/Default/Preferences
echo '' > ~/'.config/Zoom-PWA/First Run'
sed -i "s+/home/pi+$HOME+g" ~/.config/Zoom-PWA/Default/Preferences

#icons
mkdir -p ~/.local/share/icons/hicolor
cp -a "$(pwd)"/icons/. ~/.local/share/icons/hicolor

#menu button
rm -f ~/.local/share/applications/*gbmplfifepjenigdepeahbecfkcalfhg*
mkdir -p ~/.local/share/applications
#create menu launcher
echo "#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Terminal=false
Type=Application
Name=Zoom
Comment=Launch the Zoom Progressive Web App
Exec=$browser --user-data-dir=$HOME/.config/Zoom-PWA --profile-directory=Default --app-id=gbmplfifepjenigdepeahbecfkcalfhg
Icon=chrome-gbmplfifepjenigdepeahbecfkcalfhg-Default
StartupWMClass=crx_gbmplfifepjenigdepeahbecfkcalfhg
Categories=Network;WebBrowser;
StartupNotify=true" >> ~/.local/share/applications/chrome-gbmplfifepjenigdepeahbecfkcalfhg-Zoom-PWA.desktop

echo 'Done!'
