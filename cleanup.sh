#!/bin/bash

# cleanup.sh
# This script removes symbolic links created by setup.sh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

echo -e "${CYAN}Starting dotfiles cleanup...${RESET}"
echo -e "${YELLOW}This will remove symlinks created by setup.sh${RESET}\n"

# Function to remove a symbolic link
unlink_file() {
    local target_file="$1"
    local display_name="$2"

    echo -e "${CYAN}Processing ${display_name}...${RESET}"

    if [ ! -e "$target_file" ]; then
        echo -e "${YELLOW}  INFO:${RESET} '$target_file' does not exist. Skipping."
        return 0
    fi

    if [ -L "$target_file" ]; then
        read -p "    Remove symlink '$target_file'? (y/N): " response
        if [[ "$response" =~ ^[yY]$ ]]; then
            rm "$target_file"
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}  SUCCESS:${RESET} Removed '$target_file'."
            else
                echo -e "${RED}  ERROR:${RESET} Failed to remove '$target_file'."
                return 1
            fi
        else
            echo -e "${YELLOW}    Skipped '$target_file'.${RESET}"
        fi
    else
        echo -e "${YELLOW}  WARNING:${RESET} '$target_file' is not a symlink. Skipping."
    fi
}

# --- Zsh Configuration ---
echo -e "\n${BOLD}--- Removing Zsh configuration ---${RESET}"
unlink_file "$HOME/.zshrc" ".zshrc"

# --- Git Configuration ---
echo -e "\n${BOLD}--- Removing Git configuration ---${RESET}"
unlink_file "$HOME/.gitconfig" ".gitconfig"

# --- Tmux Configuration ---
echo -e "\n${BOLD}--- Removing Tmux configuration ---${RESET}"
unlink_file "$HOME/.tmux.conf" ".tmux.conf"

# --- Starship Configuration ---
echo -e "\n${BOLD}--- Removing Starship configuration ---${RESET}"
unlink_file "$HOME/.config/starship.toml" "starship.toml"

# --- Helix Configuration ---
echo -e "\n${BOLD}--- Removing Helix configuration ---${RESET}"
unlink_file "$HOME/.config/helix/config.toml" "Helix config.toml"
unlink_file "$HOME/.config/helix/languages.toml" "Helix languages.toml"

# --- WezTerm Configuration ---
echo -e "\n${BOLD}--- Removing WezTerm configuration ---${RESET}"
unlink_file "$HOME/.config/wezterm/wezterm.lua" "WezTerm wezterm.lua"
unlink_file "$HOME/.config/wezterm/events.lua" "WezTerm events.lua"
unlink_file "$HOME/.config/wezterm/config.lua" "WezTerm config.lua"

# --- Zed Configuration ---
echo -e "\n${BOLD}--- Removing Zed configuration ---${RESET}"
unlink_file "$HOME/.config/zed/settings.json" "Zed settings.json"
unlink_file "$HOME/.config/zed/keymap.json" "Zed keymap.json"

# --- Yazi Configuration ---
echo -e "\n${BOLD}--- Removing Yazi configuration ---${RESET}"
for config_file in yazi.toml keymap.toml theme.toml; do
    unlink_file "$HOME/.config/yazi/$config_file" "Yazi $config_file"
done

# --- Fastfetch Configuration ---
echo -e "\n${BOLD}--- Removing Fastfetch configuration ---${RESET}"
unlink_file "$HOME/.config/fastfetch/config.jsonc" "Fastfetch config.jsonc"

# --- Eza Configuration ---
echo -e "\n${BOLD}--- Removing Eza configuration ---${RESET}"
unlink_file "$HOME/.config/eza/theme.yml" "eza theme.yml"

echo -e "\n${GREEN}Cleanup complete!${RESET}"
echo -e "${YELLOW}Note: This script only removes symlinks. Backup files and installed packages remain.${RESET}"
