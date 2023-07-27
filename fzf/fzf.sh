# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/bin/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/bin/shell/key-bindings.zsh"
