# Simple helper to remove and make symlinks
function h.symlink() {
    # If this isnt a symlink
    if [ ! -L "$2" ]; then
        # Backup the file
        mv "$2" "$2.backup" >/dev/null 2>&1

        # Now remove it, dirs too
        rm -rf "$2" >/dev/null 2>&1
    fi

    # If the target is already a symlink
    if [ -L "$2" ]; then
        rm "$2" >/dev/null 2>&1
    fi

    # Create that symlink!
    ln -s $1 $2
}
