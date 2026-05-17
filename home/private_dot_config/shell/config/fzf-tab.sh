# fzf-tab: replace zsh's default completion menu with an fzf picker.
# Sourced after antidote loads the plugin; zstyles are inert if it's absent.

# fzf-tab requires the default menu off (menu select would disable fzf-tab)
zstyle ':completion:*' menu no

# Directory listing preview when completing `cd`
zstyle ':fzf-tab:complete:cd:*' fzf-preview \
  'eza -1 --color=always --group-directories-first $realpath'

# Cycle completion groups with < and >
zstyle ':fzf-tab:*' switch-group '<' '>'
