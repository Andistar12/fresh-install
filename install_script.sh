#!/bin/bash

echo "Setting up computer..."
echo ""
echo "Let's first configure your passwd"

sudo passwd # This also elevates the script, assuming it's run as user

echo ""
echo "Let's configure git"

echo "Enter preferred user.name var:"
read git_username
echo "Enter preferred user.email var:"
read git_email

echo ""
echo "Thank you. You may now sit back"

# Start timer
start=`date +%s`

echo ""
echo "Updating package lists..."

sudo apt update

echo ""
echo "Installing terminal programs..."

sudo apt install -y vim tmux git unzip python3-pip pylint htop curl docker.io docker-compose neofetch
sudo python3 -m pip install pipenv

echo ""
echo "Installing vim and tmux configs..."

# Assume fresh-install repo has been cloned, copy config files to home directory
cp ./.bashrc ~/.bashrc
cp ./.tmux.conf ~/.tmux.conf
cp ./.vimrc ~/.vimrc
# Install vim-plug, tmux plugin maanger, apply configs
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux source-file ~/.tmux.conf
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa

echo "Vim and tmux installed and configured"

echo "Setting up git vars"
git config --global user.name "$git_username"
git config --global user.email "$git_email"

echo ""
echo "Finally, upgrade system..."

sudo apt upgrade -y
sudo apt autoremove -y

# End timer
end=`date +%s`
runtime=$((end-start))

echo ""
echo "Installation process finished ($runtime secs). A system reboot is recommended"
