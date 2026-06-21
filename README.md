# dotfiles

**English** | [简体中文](README.zh-CN.md)

Personal configuration for ThinkPad X1 Carbon / Arch Linux + KDE Plasma (Wayland), managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each subdirectory is a stow "package"; files inside are laid out by their path relative to `$HOME`, and stow symlinks them back into the home directory.

## Packages

| Package | Links to | Notes |
|---------|----------|-------|
| `zsh` | `~/.zshrc` | Hand-written, framework-free zsh (fzf/zoxide/eza/bat, built-in completion & highlighting) |
| `git` | `~/.gitconfig` | Identity + modern defaults + aliases (GPG-signed commits) |
| `vim` | `~/.vimrc` | Minimal, no plugins |
| `bash` | `~/.bashrc` `~/.bash_profile` | Fallback shell only |
| `konsole` | `~/.local/share/konsole/*` | Catppuccin Mocha scheme + Nerd Font profile |
| `fontconfig` | `~/.config/fontconfig/fonts.conf` | Synthetic oblique/bold + subpixel rendering |

## Install

```sh
sudo pacman -S stow          # if not already installed
git clone git@github.com:CatWhiteAngel/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow zsh git vim bash konsole fontconfig
```

Install a single package: `stow konsole`. Uninstall (remove symlinks): `stow -D konsole`.

### Personal identity (one-time, per machine)

Git identity (name / email / signing key) lives in `~/.gitconfig.local`, which is **not** tracked. The repo's `git/.gitconfig` just `include`s it. On a new machine, create it from the template:

```sh
cp ~/dotfiles/git/.gitconfig.local.example ~/.gitconfig.local
chmod 600 ~/.gitconfig.local            # then edit in your name/email/signingkey
```

A missing `~/.gitconfig.local` is silently ignored by git, so the rest of the config still works.

## Deliberately excluded

The following are auto-generated machine state or contain private data, and are **not** tracked:

- GTK `settings.ini` (rewritten by kded, contains machine DPI)
- `kglobalshortcutsrc` / `plasmashellrc` / `kwinoutputconfig.json` and other KDE rc files
- `emailidentities` / `akonadi*` / `kwallet` (mail identities, credentials)
- `*history` / `.viminfo` and other history / local state

## Dependencies (install manually)

```sh
sudo pacman -S zsh stow fzf zoxide eza bat vim konsole \
               ttf-dejavu-nerd ttf-hack
```

> The default `vim` package is built `-clipboard`; install `gvim` if you want system-clipboard integration.
