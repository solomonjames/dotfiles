# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/). chezmoi handles templating and deploying config files to the home directory, with OS-conditional logic and automated plugin installation.

## Key Commands

```bash
# Bootstrap on a new machine (one command)
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply solomonjames

# Apply changes after editing source files
chezmoi apply

# See what would change
chezmoi diff

# Edit a managed file
chezmoi edit ~/.zshrc

# Pull latest and apply
chezmoi update
```

## Architecture

The repo uses `.chezmoiroot` to set `home/` as the chezmoi source directory, keeping repo-level files (README, CLAUDE.md) separate from the source state.

**`home/`** is the chezmoi source root. It contains:
- **Templated files** (`.tmpl` suffix): `dot_zshrc.tmpl`, `dot_gitconfig.tmpl`, `fs.sh.tmpl` — use `{{ .chezmoi.os }}` for OS-conditional logic
- **Static dotfiles**: `dot_tmux.conf`, `dot_vimrc`, `dot_inputrc`, etc. — deployed as-is
- **Shell fragments** in `private_dot_config/shell/`: aliases, functions, config sourced by `~/.zshrc` via for-loops
- **Bin scripts** in `private_dot_local/private_bin/`: deployed to `~/.local/bin/`
- **Run scripts**: `run_once_before_*` for package installs, `run_onchange_after_*` for plugin management

**chezmoi naming conventions:**
- `dot_` prefix → deployed as `.` (e.g., `dot_zshrc` → `~/.zshrc`)
- `private_` prefix → sets 0700 permissions on directories
- `executable_` prefix → sets executable bit on files
- `.tmpl` suffix → processed as Go template
- `run_once_` → runs once per machine
- `run_onchange_` → re-runs when file content (hash comment) changes

**Directory layout:**
- `home/dot_zshrc.tmpl` — Main zsh config (antigen plugins, env vars, history, sources shell fragments)
- `home/private_dot_config/shell/aliases/` — Shell aliases by domain (git, filesystem, general)
- `home/private_dot_config/shell/functions/` — Shell functions by domain (ssh, symlink, text, colors)
- `home/private_dot_config/shell/config/` — Shell variables (color codes, text formatting, liquidprompt)
- `home/private_dot_local/private_bin/` — Executable scripts on PATH (docker-clean)
- `home/dot_vimrc`, `home/dot_vimrc.config` — Vim config (Vundle-managed plugins)

**Plugin managers in use:**
- Antidote for zsh (oh-my-zsh bundles, liquidprompt, syntax highlighting, zsh-z)
- Vundle for vim (fugitive, nerdtree, syntastic, dracula theme)
- tmux-resurrect for tmux session persistence

## Conventions

- Shell is zsh; `~/.zshrc` is generated from `dot_zshrc.tmpl`
- Shell fragments live in `~/.config/shell/` and are sourced by zshrc via for-loops
- Machine-local overrides go in `~/.localprofile` (sourced at end of zshrc, not tracked)
- Git commit messages follow the template: `[scope] verb:\n\n    * details`
- OS-specific logic uses `{{ if eq .chezmoi.os "darwin" }}` / `"linux"` in `.tmpl` files
- User data (name, email) configured in `home/.chezmoi.toml.tmpl`
