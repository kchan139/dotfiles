#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
PACKAGE_DIR="$DOTFILES_DIR/packages"
DNF_LIST="$PACKAGE_DIR/dnf.list"
BREWFILE="$PACKAGE_DIR/Brewfile"

mkdir -p "$PACKAGE_DIR"

echo "Updating package lists..."

# DNF (Fedora)
if command -v dnf5 &>/dev/null || command -v dnf &>/dev/null; then
  echo "Generating DNF package list..."
  dnf5 repoquery --userinstalled --qf '%{name}\n' | sort -u > "$DNF_LIST"
  echo "DNF list updated at $DNF_LIST"
else
  echo "DNF not found. Skipping DNF package list."
fi

# Homebrew (macOS)
if command -v brew &>/dev/null; then
  echo "Dumping Brewfile..."
  brew bundle dump --file="$BREWFILE" --force
  echo "Brewfile updated at $BREWFILE"
else
  echo "Homebrew not found. Skipping Brewfile."
fi

echo "All done!"
