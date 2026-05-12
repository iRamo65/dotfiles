#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$HOME"
PKGLIST="$SCRIPT_DIR/pkglist.txt"
DOTFILES_REPO="https://github.com/iRamo65/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

echo "[*] Installing tmux..."
sudo pacman -Sy --needed --noconfirm tmux

# Create session and attach immediately so you're watching from the start
tmux new-session -d -s setup
tmux attach-session -t setup &

# Window 0: mirrorlist — switch to it so you see it kick off
tmux rename-window -t setup:0 'mirrorlist'
tmux send-keys -t setup:mirrorlist "sudo pacman -S --needed --noconfirm reflector rsync && sudo reflector --verbose --sort rate --save /etc/pacman.d/mirrorlist --download-timeout 60" Enter
tmux select-window -t setup:mirrorlist
sleep 2

# Window 1: update — open it and switch to it so you see it start
tmux new-window -t setup -n 'update'
tmux select-window -t setup:update
tmux send-keys -t setup:update "
echo '[*] Installing packages from $PKGLIST...'
sudo pacman -Syu --needed --noconfirm - < '$PKGLIST'

if [[ ! -d '$DOTFILES_DIR' || ! -f '$DOTFILES_DIR/HEAD' ]]; then
    echo '[*] Cloning dotfiles repo (HTTPS)...'
    rm -rf '$DOTFILES_DIR'
    git clone --bare '$DOTFILES_REPO' '$DOTFILES_DIR'
else
    echo '[*] Updating existing dotfiles repo...'
    /usr/bin/git --git-dir='$DOTFILES_DIR' --work-tree='$HOME' fetch
    /usr/bin/git --git-dir='$DOTFILES_DIR' --work-tree='$HOME' pull
fi

echo '[*] Checking out dotfiles...'
if ! /usr/bin/git --git-dir='$DOTFILES_DIR' --work-tree='$HOME' checkout; then
    echo '[!] Conflict detected. Backing up existing files...'
    mkdir -p '$HOME/.dotfiles-backup'
    /usr/bin/git --git-dir='$DOTFILES_DIR' --work-tree='$HOME' checkout 2>&1 | \
      grep -E '^\s+\.' | tr -d '\t' | while read -r file; do
          echo \"    Backing up \$file\"
          mv '$HOME/'\"\$file\" '$HOME/.dotfiles-backup/'
      done
    echo '[*] Retrying checkout...'
    /usr/bin/git --git-dir='$DOTFILES_DIR' --work-tree='$HOME' checkout
fi

echo '[*] Setting git config for dotfiles...'
/usr/bin/git --git-dir='$DOTFILES_DIR' --work-tree='$HOME' config --local status.showUntrackedFiles no
echo ' ✔ Dotfiles setup complete!'
mv ~/dotfiles ~/.dotfiles
" Enter
" Enter
