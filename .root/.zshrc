# ZSH Config File
PROMPT=' %F{240}%/ %F{1}root %F{49}>%f '

# Path
export PATH="$HOME/.local/scripts:$PATH"
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"
export EDITOR="vim"
export VISUAL="vim"
export GTK_THEME=Tokyonight-Dark
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_DESKTOP=Hyprland

# Aliases
alias 11='ls -al'
alias ps='ps aux'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# Plugins
source /root/.src/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /root/.src/.zsh/zsh-completions/zsh-completions.zsh

fpath=(/root/.src/.zsh/zsh-completions/src $fpath)

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

fbset -g 2880 1800 2880 1800 32
clear
if [[ -n "$DISPLAY" || "$XDG_SESSION_TYPE" == "wayland" ]]; then
  # In GUI terminal
  fastfetch --logo-type sixel \
            --logo "/root/debianlogor.png" \
            --logo-padding-right 2 \
            --logo-padding-left 2 \
            --logo-padding-top 2 \
            --color-keys magenta \
            --title-color-user 31 \
            --title-color-host magenta
else
  # In TTY
  fastfetch --logo-type none \
            --color-keys magenta \
            --title-color-user 36 \
            --title-color-host magenta
fi
