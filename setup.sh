#!/bin/bash
set -e  # exit on error

cd "$HOME"   # <-- ensure we are in a valid directory

PKGLIST="pkglist.txt"
DOTFILES_REPO="https://github.com/iRamo65/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

echo "[*] Installing reflector and updating mirrorlist..."
sudo pacman -Sy --needed reflector
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

echo "[*] Installing packages..."
sudo pacman -Syu --needed - < "$PKGLIST"

# Clone or update dotfiles
if [[ ! -d "$DOTFILES_DIR" || ! -f "$DOTFILES_DIR/HEAD" ]]; then
    echo "[*] Cloning dotfiles repo (HTTPS)..."
    rm -rf "$DOTFILES_DIR"   # clean up in case it's a broken folder
    git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
else
    echo "[*] Updating existing dotfiles repo..."
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" fetch
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" pull
fi

# Checkout dotfiles into $HOME
echo "[*] Checking out dotfiles..."
if ! /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" checkout; then
    echo "[!] Conflict detected. Backing up existing files..."
    mkdir -p "$HOME/.dotfiles-backup"
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" checkout 2>&1 | \
      grep -E "^\s+\." | tr -d '\t' | while read -r file; do
          echo "    Backing up $file"
          mv "$HOME/$file" "$HOME/.dotfiles-backup/"
      done
    echo "[*] Retrying checkout..."
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" checkout
fi

# Configure repo to hide untracked files
echo "[*] Setting git config for dotfiles..."
/usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" config --local status.showUntrackedFiles no

echo "[✔] Dotfiles setup complete!"
