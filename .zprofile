# Adds `~/.local/bin` to $PATH
export $PATH:$(du "$HOME/.local/bin" | cut -f2 | paste -sd ':')
