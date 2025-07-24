# dotfiles

My personal dotfiles.

## ✨ Features

- Symlinks config files for:
  - Bash, Zsh
  - Git
  - Starship
  - Helix
  - WezTerm
  - Zed
- Installs packages via:
  - `dnf` on Fedora (`packages/dnf.list`)
  - Homebrew on macOS or Linux (`packages/Brewfile`)
- Idempotent setup (safe to run multiple times)

## 🛠 Usage

```bash
./setup.sh

