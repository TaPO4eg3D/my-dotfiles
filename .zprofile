# Adds `~/.local/bin` to $PATH
export PATH=$PATH:$(du "$HOME/.local/bin" | cut -f2 | paste -sd ':')

# Default programs:
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="google-chrome"
export READER="zathura"
