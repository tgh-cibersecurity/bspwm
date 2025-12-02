# Setup fzf
# ---------
if [[ ! "$PATH" == */home/cibersecurity/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/cibersecurity/.fzf/bin"
fi

eval "$(fzf --bash)"
