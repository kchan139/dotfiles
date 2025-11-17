#!/bin/bash

# setup.sh
# This script sets up dotfiles by creating symbolic links from this
# repository to the appropriate locations in the home directory.
# It is designed to work on both Fedora and macOS.

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

SCRIPT_DIR="$(git rev-parse --show-toplevel)"
CONFIG_DIR="$SCRIPT_DIR/config"

echo -e "${CYAN}Starting dotfiles setup...${RESET}"

# ================================================================
# INSTALL PACKAGES
# ================================================================

echo -e "${CYAN}Install packages? (y/N): ${RESET}\c"
read -r install_pkgs

if [[ "$install_pkgs" =~ ^[yY]$ ]]; then
    echo -e "${CYAN}Installing packages...${RESET}"

    # --- DNF packages ---
    if command -v dnf >/dev/null 2>&1; then
        pkg_list="$SCRIPT_DIR/packages/dnf.list"
        if [ -f "$pkg_list" ]; then
            echo -e "${CYAN}Installing DNF packages...${RESET}"
            sudo dnf install -y $(grep -Ev '^\s*#' "$pkg_list")
        else
            echo -e "${YELLOW}Missing: packages/dnf.list${RESET}"
        fi
    fi

    # --- Brew packages ---
    if command -v brew >/dev/null 2>&1; then
        brewfile="$SCRIPT_DIR/packages/Brewfile"
        if [ -f "$brewfile" ]; then
            echo -e "${CYAN}Installing Brew packages...${RESET}"
            brew bundle --file="$brewfile"
        else
            echo -e "${YELLOW}Missing: packages/Brewfile${RESET}"
        fi
    fi

    echo -e "${GREEN}Package installation complete.${RESET}"
else
    echo -e "${YELLOW}Skipped package installation.${RESET}"
fi


# --- Starship ---
if ! command -v starship &>/dev/null; then
    echo -e "${CYAN}Installing Starship...${RESET}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y || true
fi

# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${CYAN}Installing Oh My Zsh...${RESET}"
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- TPM ---
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo -e "${CYAN}Installing Tmux Plugin Manager...${RESET}"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# ================================================================
# FUNCTIONS
# ================================================================

backup_if_needed() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "${target}.backup_$(date +%Y%m%d%H%M%S)"
    elif [ -L "$target" ]; then
        rm -f "$target"
    fi
}

link_file() {
    local src="$1"
    local dst="$2"
    echo -e "${CYAN}Linking file: $dst${RESET}"
    [ -f "$src" ] || { echo -e "${YELLOW}  Missing file: $src${RESET}"; return; }
    backup_if_needed "$dst"
    ln -s "$src" "$dst"
    echo -e "${GREEN}  OK${RESET}"
}

link_dir() {
    local src="$1"
    local dst="$2"
    echo -e "${CYAN}Linking dir:  $dst${RESET}"
    [ -d "$src" ] || { echo -e "${YELLOW}  Missing dir: $src${RESET}"; return; }
    backup_if_needed "$dst"
    ln -s "$src" "$dst"
    echo -e "${GREEN}  OK${RESET}"
}

# ================================================================
# CONFIG MAPPING
# ================================================================

home_files=(
    "zsh/.zshrc"
    "git/.gitconfig"
    "tmux/.tmux.conf"
)

config_dirs=(
    "fastfetch"
    "eza"
    "wezterm"
    "zed"
    "yazi"
    "k9s"
    "helix"
    "starship"
)

# ================================================================
# LINKING
# ================================================================

echo -e "\n${CYAN}Linking home-level dotfiles...${RESET}"
for f in "${home_files[@]}"; do
    src="$CONFIG_DIR/$f"
    base="$(basename "$f")"
    link_file "$src" "$HOME/$base"
done

echo -e "\n${CYAN}Linking ~/.config directories...${RESET}"
mkdir -p "$HOME/.config"
for dir in "${config_dirs[@]}"; do
    link_dir "$CONFIG_DIR/$dir" "$HOME/.config/$dir"
done

echo -e "\n${GREEN}Dotfiles setup complete.${RESET}"
