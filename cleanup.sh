#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

echo -e "${CYAN}Starting dotfiles cleanup...${RESET}"

# ===========================================================================
# FUNCTIONS
# ===========================================================================

unlink_if_symlink() {
    local target="$1"
    echo -e "${CYAN}Checking: $target${RESET}"

    if [ -L "$target" ]; then
        rm -f "$target"
        echo -e "${GREEN}  Removed symlink${RESET}"
    else
        echo -e "${YELLOW}  Not a symlink, skipped${RESET}"
    fi
}

unlink_dir_symlink() {
    local target="$1"
    echo -e "${CYAN}Checking dir: $target${RESET}"

    if [ -L "$target" ]; then
        rm -f "$target"
        echo -e "${GREEN}  Removed symlinked directory${RESET}"
    else
        echo -e "${YELLOW}  Not a symlinked directory, skipped${RESET}"
    fi
}

# ===========================================================================
# CONFIG MAPPING
# ===========================================================================

home_files=(
    "$HOME/.zshrc"
    "$HOME/.gitconfig"
    "$HOME/.gitignore_global"
    "$HOME/.tmux.conf"
)

config_dirs=(
    "$HOME/.config/fastfetch"
    "$HOME/.config/eza"
    "$HOME/.config/wezterm"
    "$HOME/.config/zed"
    "$HOME/.config/yazi"
    "$HOME/.config/k9s"
    "$HOME/.config/helix"
    "$HOME/.config/starship"
)

# ===========================================================================
# CLEANING
# ===========================================================================

echo -e "\n${CYAN}Removing home-level dotfile symlinks...${RESET}"
for f in "${home_files[@]}"; do
    unlink_if_symlink "$f"
done

echo -e "\n${CYAN}Removing ~/.config directory symlinks...${RESET}"
for d in "${config_dirs[@]}"; do
    unlink_dir_symlink "$d"
done

echo -e "\n${GREEN}Cleanup complete.${RESET}"
echo -e "${YELLOW}Note: backups and real config directories remain untouched.${RESET}"
