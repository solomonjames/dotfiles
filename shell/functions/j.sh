# Setup the dotfiles repo locally, or pull latest version from github.
# Create symlinks in the $HOME directory to elements in the repo
jinstall() {
    local SGITURL="https://github.com/jhuntwork/dotfiles/raw/e374d0dbc1754b21a3d36b9df5742d351d7fe460/git-static-x86_64-linux-musl.tar.xz"
    local SGITPATH="${HOME}/.git-static"
    local SGIT=git

    # If not installed globally already
    if ! ${SGIT} --version >/dev/null 2>&1 ; then
        SGIT="${SGITPATH}/git --exec-path=${SGITPATH}/git-core"

        # If the static version isnt available
        if ! ${SGIT} --version >/dev/null 2>&1 ; then
            cd ${HOME}
            curl -sL ${SGITURL} | tar -xJf -
        fi
    fi

    # If fresh seems to be already installed
    if [ -r "${HOME}/.freshrc" ] ; then
        fresh update
    else
        FRESH_LOCAL_SOURCE=solomonjames/dotfiles bash <(curl -sL get.freshshell.com)
    fi
}

# Simple wrapper for ssh which makes jinstall() available in the remote session
# regardless of whether .dotfiles is present remotely or not
jssh() {
    local func=$(typeset -f jinstall)
    ssh -A -t "$@" \
    "${func} ;
    [ -r /etc/motd ] && cat /etc/motd ;
    [ -r \"\$HOME/.bash_profile\" ] && . \"\$HOME/.bash_profile\" ;
    type jssh >/dev/null 2>&1 || jinstall ;
    exec env -i SSH_AUTH_SOCK=\"\$SSH_AUTH_SOCK\" \
      SSH_CONNECTION=\"\$SSH_CONNECTION\" \
      SSH_CLIENT=\"\$SSH_CLIENT\" SSH_TTY=\"\$SSH_TTY\" \
      HOME=\"\$HOME\" TERM=\"\$TERM\" \
      PATH=\"\$PATH\" SHELL=\"\$SHELL\" \
      USER=\"\$USER\" \$SHELL -i"
}
alias ssj="jssh"
