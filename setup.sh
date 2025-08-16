#!/bin/bash
set -e  # exit on error

PKGLIST="pkglist.txt"
DOTFILES_REPO_SSH="git@github.com:iRamo65/dotfiles.git"
DOTFILES_REPO_HTTPS="https://github.com/iRamo65/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

echo "[*] Installing packages..."
sudo pacman -Syu --needed - < "$PKGLIST"

# Check if dotfiles repo already exists
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "[*] Cloning dotfiles repo..."

    # Test if SSH works
    if ssh -o BatchMode=yes -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "    -> Using SSH"
        git clone --bare "$DOTFILES_REPO_SSH" "$DOTFILES_DIR"
    else
        echo "    -> SSH not set up, falling back to HTTPS"
        git clone --bare "$DOTFILES_REPO_HTTPS" "$DOTFILES_DIR"
    fi
else
    echo "[*] Updating existing dotfiles repo..."
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" fetch
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" pull
fi

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

echo "[*] Setting git config for dotfiles..."
/usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" config --local status.showUntrackedFiles no

echo "[✔] Dotfiles setup complete!"
