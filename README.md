# dotfiles 🛠️

Personal macOS configuration — one repo, symlinked into place.

![macOS](https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white)
![Shell](https://img.shields.io/badge/shell-zsh-89e051)
![Neovim](https://img.shields.io/badge/editor-Neovim-57A143?logo=neovim&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

The real config files live here under version control; your `$HOME` gets **symlinks** that point back into the repo. Edit either path — they're the same file — and `git` sees every change. A single `install.sh` recreates all the links on a fresh machine.

## What's inside

| Path | Symlinked to | What it is |
|------|--------------|------------|
| `aerospace/aerospace.toml` | `~/.aerospace.toml` | [AeroSpace](https://github.com/nikitabobko/AeroSpace) tiling window manager config |
| `zshrc/zshrc` | `~/.zshrc` | Zsh shell config (brew plugins, nvm, pyenv, VS Code CLI) |
| `nvim/` | `~/.config/nvim` | Neovim config — lazy.nvim, LSP/Mason, Telescope, kanagawa-paper theme |
| `iterm/` | *(imported via GUI)* | iTerm2 Catppuccin Macchiato color preset |
| `*.tex` | *(templates)* | LaTeX preamble, macros, and document template |

## Install

On a fresh machine:

```bash
git clone https://github.com/Punpun1643/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The script symlinks `aerospace`, `zshrc`, and `nvim` into their expected locations. It's **safe to re-run**: any existing real file in the way is backed up to `<target>.bak` before the symlink is created, and correct symlinks are left untouched.

```
ok:   ~/.aerospace.toml -> ~/dotfiles/aerospace/aerospace.toml
back: ~/.zshrc -> ~/.zshrc.bak
link: ~/.zshrc -> ~/dotfiles/zshrc/zshrc
link: ~/.config/nvim -> ~/dotfiles/nvim
```

## Machine-specific settings

Anything private or per-machine (corporate certs, secrets, one-off paths) stays **out of the repo**. The tracked `zshrc` ends by sourcing an untracked local file if it exists:

```sh
# machine-specific overrides (untracked, not committed)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
```

So on each machine, put its own settings in `~/.zshrc.local`:

```sh
# ~/.zshrc.local — never committed
export NODE_EXTRA_CA_CERTS=$HOME/corp-ca.pem
```

## The pieces

### AeroSpace

A tiling window manager for macOS configured in `aerospace/aerospace.toml`. AeroSpace reads `~/.aerospace.toml`, which is a symlink into this repo — edit it anywhere and reload with `aerospace reload-config`.

### Zsh

`zshrc/zshrc` wires up Homebrew's `zsh-autocomplete` and `zsh-autosuggestions`, the VS Code `code` CLI, `nvm`, and `pyenv`. Machine-specific bits load from `~/.zshrc.local` (see above).

### Neovim

A [lazy.nvim](https://github.com/folke/lazy.nvim)-based config under `nvim/`. Highlights: LSP via `nvim-lspconfig` + Mason, completion with `nvim-cmp`, fuzzy finding with Telescope, file tree, which-key, Treesitter, and the `kanagawa-paper` colorscheme. `nvim/lazy-lock.json` pins plugin versions for reproducible installs.

### iTerm2

`iterm/` holds the Catppuccin Macchiato `.itermcolors` preset. iTerm imports colors through its GUI rather than a symlink — see [`iterm/README.md`](iterm/README.md) for the import steps.

### LaTeX templates

`template.tex`, `preamble.tex`, and `macros.tex` are a reusable document setup (report class with a customized preamble). Copy them into a project rather than symlinking.

## Adding a new config

1. Move the real file into the repo: `mv ~/.foorc ~/dotfiles/foo/foorc`
2. Add a `link` line to `install.sh`:
   ```bash
   link "foo/foorc" "$HOME/.foorc"
   ```
3. Run `./install.sh` and commit.

## License

MIT
