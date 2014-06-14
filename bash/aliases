# Setup all aliases here

[ "$(uname -s)" = "Linux" ] && alias ls='ls --color'
alias ll='ls -lh'
alias la='ls -lha'

alias tmux-attach="ssh-save ; tmux attach ; ssh-restore"

# This requires some ssh setup
alias pbcopy="cat | nc -q1 localhost 2224"

# Transverse helpers
alias ..="cd .."

# Git helpers
alias gst="git status 2> /dev/null || echo '${RED}[OOPS]${NORMAL} : Not a git repo'"
alias gadd="git add -p && git status"
