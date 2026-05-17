# Dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/).

## One-command bootstrap (new machine)

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply solomonjames
```

## Usage

```bash
# Apply changes after editing source files
chezmoi apply

# See what would change
chezmoi diff

# Edit a managed file (opens source, applies on save)
chezmoi edit ~/.zshrc

# Pull latest from remote and apply
chezmoi update

# Add a new file to be managed
chezmoi add ~/.some-config
```

## Installed programs

Bootstrap installs these via Homebrew (macOS) or apt/yum (Linux), defined in
`home/run_once_before_install-packages.sh.tmpl`:

| Program | Binary | Replaces | Purpose |
|---------|--------|----------|---------|
| [neovim](https://neovim.io/) | `nvim` | vim | Editor (LazyVim config in `~/.config/nvim`) |
| [tmux](https://github.com/tmux/tmux) | `tmux` | — | Terminal multiplexer (sessions persisted via tpm + resurrect) |
| [wget](https://www.gnu.org/software/wget/) | `wget` | — | File downloader |
| [tig](https://jonas.github.io/tig/) | `tig` | — | ncurses git history/blame browser |
| [git-extras](https://github.com/tj/git-extras) | `git *` | — | Extra git subcommands (`git summary`, `git ignore`, …) |
| [lazygit](https://github.com/jesseduffield/lazygit) | `lazygit` | — | Full-screen git TUI (stage/commit/rebase/push) |
| [fzf](https://github.com/junegunn/fzf) | `fzf` | — | Fuzzy finder, wired into zsh keybindings |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `rg` | `grep -r` | Fast recursive search, `.gitignore`-aware |
| [fd](https://github.com/sharkdp/fd) | `fd` | `find` | Fast file finder, `.gitignore`-aware |
| [bat](https://github.com/sharkdp/bat) | `bat` | `cat` | Pager with syntax highlighting; also the `man` pager |
| [eza](https://github.com/eza-community/eza) | `eza` | `ls` | Listing with git columns, icons, tree view |
| [git-delta](https://github.com/dandavison/delta) | `delta` | git's pager | Syntax-highlighted git diffs (pager + diff filter) |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `z` | `cd` | Frecency-based directory jumping |
| [yazi](https://github.com/sxyazi/yazi) | `yazi` / `y` | — | TUI file manager with previews; `y` cd's to its exit dir |

zsh plugins (managed by [antidote](https://github.com/mattmc3/antidote), listed
in `~/.config/zsh/.zsh_plugins.txt`): oh-my-zsh libs (brew/composer/nvm),
liquidprompt, **fzf-tab**, **zsh-autosuggestions**, **zsh-syntax-highlighting**.

> **Linux note:** Debian/Ubuntu apt names `fd` as `fd-find` (binary `fdfind`)
> and `bat` as `batcat`, and older repos lack `eza`/`git-delta`. The shared
> package list targets Homebrew names; a Linux bootstrap may need adjustments.

## Cheatsheet

### zsh shell (autosuggestions, completion, history)

Inline suggestions appear in grey as you type, drawn from history:

| Key | Action |
|-----|--------|
| `→` (right arrow) / `End` | Accept the full suggestion |
| `Ctrl-→` | Accept one word of the suggestion |
| `Ctrl-E` | Accept and move to end of line |

Tab completion is powered by **fzf-tab** — pressing `Tab` opens an fzf
picker instead of the plain menu:

| Key (in the fzf-tab picker) | Action |
|-----------------------------|--------|
| `Tab` | Open the fuzzy completion picker |
| type to filter, `Enter` | Accept selection |
| `<` / `>` | Cycle between completion groups |
| `Ctrl-Space` | Multi-select (where applicable) |

`cd <Tab>` shows an `eza` directory preview. History is now zsh-native:
shared live across all open shells, written per-command, deduped, and
commands typed with a leading space are not recorded.

### fzf (fuzzy finder)

| Key / command | Action |
|---------------|--------|
| `Ctrl-R` | Fuzzy-search command history |
| `Ctrl-T` | Insert file path into the command line (uses `fd`) |
| `Alt-C` | `cd` into a subdirectory (uses `fd`) |
| `cmd **<Tab>` | Fuzzy-complete args, e.g. `vim **<Tab>`, `cd **<Tab>` |
| `kill -9 **<Tab>` | Fuzzy-pick a process |

### zoxide (smart cd)

| Command | Action |
|---------|--------|
| `z foo` | Jump to highest-ranked dir matching `foo` |
| `z foo bar` | Jump to dir matching all of `foo` and `bar` |
| `z ..` / `z -` | Parent / previous directory |
| `zi foo` | Interactive pick among matches (fzf) |
| `z` (no args) | Jump home |

Database builds up as you navigate; no manual seeding needed.

### ripgrep (search)

```bash
rg pattern                 # recursive search from cwd, skips .gitignore + binaries
rg -i pattern              # case-insensitive
rg -t py pattern           # only Python files
rg -g '!*.lock' pattern    # exclude a glob
rg -l pattern              # list matching files only
rg -A 3 -B 1 pattern       # context lines (after / before)
rg --hidden pattern        # include dotfiles
```

### fd (find files)

```bash
fd pattern                 # find by substring, skips .gitignore
fd -e md                   # by extension
fd -t f / -t d             # type: file / directory
fd -H pattern              # include hidden files
fd pattern -x cmd {}       # execute cmd per result
```

### bat (cat)

```bash
bat file                   # syntax-highlighted, with line numbers + git gutter
bat -p file                # plain (no decorations), pipe-friendly
bat -A file                # show non-printable characters
man tmux                   # man pages render through bat automatically
```

### eza (ls)

| Alias | Expands to |
|-------|-----------|
| `ls` | `eza --group-directories-first` |
| `ll` | `eza -lh --group-directories-first --git` |
| `la` | `eza -lha --group-directories-first --git` |
| `lt` | `eza --tree --level=2` |

```bash
eza --tree --level=3 --git-ignore   # deeper tree, honor .gitignore
eza -l --sort=modified              # sort by mtime
```

### yazi (file manager)

Use `y` (not `yazi`) so the shell follows you to the directory you quit in:

| Key | Action |
|-----|--------|
| `y` | Launch the file manager (cd's to exit dir on quit) |
| `h` / `j` / `k` / `l` | Navigate (parent / down / up / enter) |
| `Space` | Toggle selection; `v` visual mode |
| `y` / `x` / `p` | Yank / cut / paste |
| `d` / `D` | Trash / delete permanently |
| `a` / `r` | Create file/dir (trailing `/` = dir) / rename |
| `/` `n` `N` | Search; `s` find by `fd`; `S` search content by `rg` |
| `z` / `Z` | Jump via zoxide / fzf |
| `.` | Toggle hidden files |
| `Tab` | Toggle preview pane; `q` quit, `Q` quit without cd |

### delta (git diffs)

Active automatically for `git diff`, `git show`, `git log -p`, `git add -p`.

| Key (in a delta pager) | Action |
|------------------------|--------|
| `n` / `N` | Next / previous file or hunk |
| `q` | Quit pager |

```bash
git diff                   # side-by-side-ish, syntax highlighted
git diff --stat            # summary only (unchanged behavior)
DELTA_FEATURES=+side-by-side git diff   # force side-by-side for one command
```

### tmux (sessions)

Prefix is `Ctrl-Space`. Sessions auto-save (continuum) and restore on
start; nvim sessions are restored too (resurrect).

| Key | Action |
|-----|--------|
| `<prefix> f` | **Project switcher** — fuzzy-pick a dir (zoxide + `~/src`) and open/switch a session named after it |
| `<prefix> r` | Reload `~/.tmux.conf` |
| `<prefix> "` / `%` | Split horizontal / vertical (inherits cwd) |
| `Shift-←` / `Shift-→` | Previous / next window |
| `<prefix> Ctrl-s` / `Ctrl-r` | Manual save / restore session state |
| `Ctrl-h/j/k/l` | Move between panes and vim splits (vim-tmux-navigator) |

`tmux-sessionizer <path>` can also be run directly with a path argument to
jump straight to that project's session.

### lazygit / tig (git TUIs)

```bash
lazygit                    # full git TUI: stage, commit, branch, rebase, push
tig                        # browse history; Enter = show commit, b = blame
tig blame <file>           # blame view for a file
```

## Post-migration cleanup (from Fresh)

After switching from Fresh to chezmoi:

```bash
rm -rf ~/.fresh ~/bin/fresh ~/bin/antigen.zsh ~/bin/pacapt ~/bin/fresh-setup
chezmoi init --apply solomonjames
```
