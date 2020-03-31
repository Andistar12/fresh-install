#!/bin/sh

echo "Setting up computer..."

if [ $EUID != 0 ]; then
    echo "We need to elevate this script..."
    sudo "$0" "$@"
    exit $?
else
    echo "This script must be run as a user"
    exit 1
fi

echo "Will this be a GUI install? GUI also includes multimedia programs"
select gui_install in "Yes" "No"; do
    case $gui_install in
        Yes ) echo "GUI install selected"; break;;
        No ) echo "Terminal-only install selected"; break;;
    esac
done

echo ""
echo "Let's first configure your passwd"

sudo passwd

echo "Updating package lists..."

sudo apt update

echo "Let's now install vim and tmux to get them out of the way"

sudo apt install -y vim tmux
echo "Installing vim and tmux configs..."
# Install vim and tmux configs
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
tmux source-file ~/.tmux.conf
vim +'PlugInstall --sync' +qa

echo "Vim and tmux installed and configured"
echo ""
echo "Let's install more programs"
echo "Installing terminal programs..."

sudo apt install -y vim tmux git unzip python3-pip pylint htop curl 

case $gui_install in
    Yes ) 
        echo "Installing GUI commands"
        sudo apt install -y --simulate pavucontrol default-jre gparted gnome-tweak-tool texlive-full steam chrome-gnome-shell evolution python-opencv openvpn; 
        #sudo snap install --channel=stable vlc audacity gimp inkscape youtube-dl obs-studio discord handbrake-jz google-play-music-desktop-player mp3gain minecraft-launcher-ot ffmpeg;
        break;;
esac

echo "Finally, upgrade system..."

sudo apt upgrade -y
sudo apt autoremove -y
