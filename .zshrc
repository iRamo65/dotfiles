# lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/iRamo/.zshrc'

PROMPT='%F{green}%n@%m %F{white}%~ %#%f '
# Aliases
alias pkm='nvim /mnt/c/PKM/'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias env_upgrade='cd ~ && pacman -Qqe > pkglist.txt && config add . && config commit -m "Updated pkglist (auto)" && config push'
autoload -Uz compinit
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
compinit
# End of lines added by compinstall
