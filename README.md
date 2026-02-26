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

## Post-migration cleanup (from Fresh)

After switching from Fresh to chezmoi:

```bash
rm -rf ~/.fresh ~/bin/fresh ~/bin/antigen.zsh ~/bin/pacapt ~/bin/fresh-setup
chezmoi init --apply solomonjames
```
