#!/bin/bash

# Install packages
sudo pacman -Syu --needed < pkglist.txt

# Clone or update dotfiles
if [[ ! -d "$HOME/.dotfiles" ]]; then
    echo "[*] Cloning dotfiles..."
    git clone --bare git@github.com:iRamo65/dotfiles.git $HOME/.dotfiles
else
    echo "[*] Updating existing dotfiles repo..."
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME pull
fi

# Checkout dotfiles into $HOME
echo "[*] Checking out dotfiles..."
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout

