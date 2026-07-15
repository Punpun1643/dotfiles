#!/usr/bin/env bash
# Symlinks dotfiles into their expected locations in $HOME.
# Safe to re-run: existing non-symlink targets are backed up to <target>.bak.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# repo path (relative to this script)  ->  target in $HOME
link() {
  local src="$DOTFILES/$1"
  local dest="$2"

  if [ ! -e "$src" ]; then
    echo "skip: $src does not exist"
    return
  fi

  # Already the correct symlink? Nothing to do.
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok:   $dest -> $src"
    return
  fi

  mkdir -p "$(dirname "$dest")"

  # Back up anything real that's in the way.
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "back: $dest -> $dest.bak"
    rm -rf "$dest.bak"
    mv "$dest" "$dest.bak"
  fi

  ln -s "$src" "$dest"
  echo "link: $dest -> $src"
}

link "aerospace/aerospace.toml" "$HOME/.aerospace.toml"
link "zshrc/zshrc"              "$HOME/.zshrc"
link "nvim"                     "$HOME/.config/nvim"

echo
echo "Done. Machine-specific shell settings go in ~/.zshrc.local (not tracked)."
