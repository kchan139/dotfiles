# dotfiles

My personal dotfiles.

## ✨ Features

- Symlinks config files for:
  - Zsh
  - Git
  - Starship
  - Helix
  - WezTerm
  - Zed
  - Tmux
  - Yazi
- Installs packages via:
  - `dnf` on Fedora (`packages/dnf.list`)
  - Homebrew on macOS (`packages/Brewfile`)
- Idempotent setup (safe to run multiple times)

## 🛠 Usage

```bash
git clone https://github.com/kchan139/dotfiles.git
cd dotfiles
./setup.sh
```
