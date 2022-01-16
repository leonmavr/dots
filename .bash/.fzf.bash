# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.bash"

# Appearance
# ------------
export FZF_DEFAULT_OPTS="--height=70% --layout=reverse --info=inline --border --margin=2"
