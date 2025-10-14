# dotfiles

My personal dotfiles (ignore my commit messages).

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
  - Fastfetch
  
- Installs packages via:
  - `dnf` on Fedora (`packages/dnf.list`)
  - Homebrew on macOS (`packages/Brewfile`)

- Idempotent setup (safe to run multiple times)

## 🛠 Usage

```bash
cd ~
git clone https://github.com/kchan139/dotfiles.git
cd dotfiles
./setup.sh
```
