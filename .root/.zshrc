# ZSH Config File
PROMPT='%F{240}%/ %F{1}root %F{49}>%f '

# Path
export PATH="$HOME/.local/scripts:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"

# Aliases
alias ff="fastfetch --logo-type chafa --logo "/root/debianlogo.png" --logo-padding-top 2 --logo-padding-left 2 --color-keys magenta --title-color-user 36 --title-color-host magenta"
alias hyp="Hyprland"

# Plugins
source /root/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /root/.zsh/zsh-completions/zsh-completions.zsh

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

fpath=(/root/.zsh/zsh-completions/src $fpath)

fbset -g 2880 1800 2880 1800 32
clear
if [[ -n "$DISPLAY" || "$XDG_SESSION_TYPE" == "wayland" ]]; then
  # In GUI terminal
  fastfetch --logo-type chafa \
            --logo "/root/debianlogo.png" \
            --logo-padding-top 2 \
            --logo-padding-left 2 \
            --color-keys magenta \
            --title-color-user 36 \
            --title-color-host magenta
else
  # In TTY
  fastfetch --logo-type none \
            --color-keys magenta \
            --title-color-user 36 \
            --title-color-host magenta
fi

