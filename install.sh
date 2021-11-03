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
  rm -rf zoom-pwa || sudo rm -rf zoom-pwa
  git clone https://github.com/Botspot/zoom-pwa || error "failed to git clone!"
  DIRECTORY="$(pwd)/zoom-pwa"
fi
echo "Parent folder of this script: $DIRECTORY"

if command -v chromium-browser &>/dev/null;then	
  browser_path="$(command -v chromium-browser)"
  browser_type="chromium"
elif command -v chromium &>/dev/null;then	
  browser_path="$(command -v chromium)"	
  browser_type="chromium"
elif command -v google-chrome &>/dev/null;then	
  browser_path="$(command -v google-chrome)"	
  browser_type="chromium"
elif command -v firefox &>/dev/null;then	
  browser_path="$(command -v firefox)"	
  browser_type="firefox"
elif command -v firefox-esr &>/dev/null;then
  browser_path="$(command -v firefox-esr)"
  browser_type="firefox"
else
  error "You must have Chromium Browser or Firefox installed to use the Zoom PWA!"
fi

#make chromium config with zoom pre-installed
if [ "$browser_type" == "chromium" ];then
  echo "Generating Chromium config..."
  rm -rf $HOME/.config/Zoom-PWA || sudo rm -rf $HOME/.config/Zoom-PWA
  mkdir -p $HOME/.config/Zoom-PWA/Default || error "Failed to create $HOME/.config/Zoom-PWA/Default directory!"
  cp "$DIRECTORY"/Preferences $HOME/.config/Zoom-PWA/Default/Preferences || error "Failed to copy config!"
  echo '' > $HOME/'.config/Zoom-PWA/First Run'
  sed -i "s+/home/pi+$HOME+g" $HOME/.config/Zoom-PWA/Default/Preferences
else
  echo "Generating Firefox config..."
  rm -rf $HOME/.config/Zoom-PWA || sudo rm -rf $HOME/.config/Zoom-PWA
  cp "$DIRECTORY"/Zoom-PWA.zip $HOME/.config/ || error "Failed to copy "$DIRECTORY"/Zoom-PWA.zip to $HOME/.config/!"
  unzip -qo $HOME/.config/Zoom-PWA.zip -d $HOME/.config || error "Failed to unzip config zip!"
fi

echo "Copying icons to $HOME/.local/share/icons/hicolor ..."
mkdir -p $HOME/.local/share/icons/hicolor
cp -a "$DIRECTORY"/icons/. $HOME/.local/share/icons/hicolor || error "Failed to copy icons!"

echo "Creating menu launcher..."
if [ "$browser_type" == "chromium" ];then
  mkdir -p $HOME/.local/share/applications
  #create menu launcher
  echo "[Desktop Entry]
Version=1.0
Terminal=false
Type=Application
Name=Zoom PWA
Comment=Launch the Zoom Progressive Web App with Chromium browser
Exec=$browser_path --user-data-dir=$HOME/.config/Zoom-PWA --profile-directory=Default --app-id=gbmplfifepjenigdepeahbecfkcalfhg --app=https://pwa.zoom.us/wc
Icon=chrome-gbmplfifepjenigdepeahbecfkcalfhg-Default
StartupWMClass=crx_gbmplfifepjenigdepeahbecfkcalfhg
Categories=Network;WebBrowser;
StartupNotify=true" > $HOME/.local/share/applications/Zoom-PWA-chromium.desktop
else
  mkdir -p $HOME/.local/share/applications
  #create menu launcher
  echo "[Desktop Entry]
Version=1.0
Name=Zoom PWA test
Comment=Launch the Zoom Progressive Web App with Firefox
Exec=bash -c 'rm -f $HOME/.config/Zoom-PWA/serviceworker.txt && XAPP_FORCE_GTKWINDOW_ICON=$HOME/.local/share/icons/hicolor/48x48/apps/chrome-gbmplfifepjenigdepeahbecfkcalfhg-Default.png $browser_path --class Zoom-PWA --profile $HOME/.config/Zoom-PWA --no-remote https://pwa.zoom.us/wc'
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=chrome-gbmplfifepjenigdepeahbecfkcalfhg-Default
Categories=GTK;Network;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupWMClass=ZoomPWA
StartupNotify=true" > $HOME/.local/share/applications/Zoom-PWA-firefox.desktop
fi

echo 'Done!'
