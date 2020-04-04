#!/bin/sh

echo "Setting up computer..."

echo "Will this be a GUI install? GUI also includes multimedia programs. This requires snaps"
select gui_install in "Yes" "No"; do
    case $gui_install in
        Yes ) echo "GUI install selected"; break;;
        No ) echo "Terminal-only install selected"; break;;
    esac
done

echo ""
echo "Let's first configure your passwd"

sudo passwd # This also elevates the script, assuming it's run as user

echo ""
echo "Let's configure git really quickly"

echo "Enter preferred user.name var:"
read git_username
echo "Enter preferred user.email var:"
read git_email

echo ""
echo "Thank you. You may now sit back"

echo ""
echo "Updating package lists..."

sudo apt update

echo ""
echo "Installing terminal programs..."

sudo apt install -y vim tmux git unzip python3-pip pylint htop curl 

case $gui_install in
    Yes ) 
        echo "";
        echo "Installing GUI commands";
        sudo apt install -y --simulate snapd pavucontrol default-jre gparted gnome-tweak-tool texlive-full steam chrome-gnome-shell evolution python-opencv openvpn; 
        #sudo snap install --channel=stable vlc audacity gimp inkscape youtube-dl obs-studio discord handbrake-jz google-play-music-desktop-player mp3gain minecraft-launcher-ot ffmpeg;
        break;;
esac

echo ""
echo "Installing vim and tmux configs..."

# Assume fresh-install repo has been cloned, copy config files to home directory
cp ./.bashrc ~/.bashrc
cp ./.tmux.conf ~/.tmux.conf
cp ./.vimrc ~/.vimrc
# Install vim-plug, tmux plugin maanger, apply both
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
tmux source-file ~/.tmux.conf
vim +'PlugInstall --sync' +qa
~/.tmux/plugins/tpm/scripts/install_plugins.sh

echo "Vim and tmux installed and configured"

echo "Setting up git vars"
git config --global user.name "$git_username"
git config --global user.email "$git_email"


echo ""
echo "Finally, upgrade system..."

sudo apt upgrade -y
sudo apt autoremove -y

echo ""
echo "Installation process finished. A system reboot is recommended if snapd was not preinstalled"
