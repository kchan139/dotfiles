# dotfiles

My personal dotfiles (ignore my commit messages).

## ✨ Features

- Symlinks config files for:
  - Zsh
  - Git
  - Eza
  - Zed
  - Tmux
  - Yazi
  - Helix
  - WezTerm
  - Starship
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
