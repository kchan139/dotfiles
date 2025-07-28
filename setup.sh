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

# Define the source directory (where this script resides)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo -e "${CYAN}Starting dotfiles setup...${RESET}"
echo -e "Dotfiles repository located at: ${BLUE}$SCRIPT_DIR${RESET}"

# --- DNF Package Installation ---
echo -e "\n${BOLD}--- Installing system packages from dnf.list ---${RESET}"

DNF_LIST="$SCRIPT_DIR/packages/dnf.list"

if command -v dnf &> /dev/null; then
    if [ -f "$DNF_LIST" ]; then
        echo -e "${YELLOW}Do you want to install system packages from dnf.list?${RESET}"
        read -p "This requires sudo privileges. Continue? (y/N): " confirm
        if [[ "$confirm" =~ ^[yY]$ ]]; then
            echo -e "${CYAN}Requesting sudo permissions...${RESET}"
            sudo -v || { echo -e "${RED}Sudo authentication failed. Skipping package install.${RESET}"; exit 1; }

            echo -e "${CYAN}Installing packages...${RESET}"
            grep -vE '^\s*#' "$DNF_LIST" | xargs sudo dnf install -y
            echo -e "${GREEN}Package installation complete.${RESET}"
        else
            echo -e "${YELLOW}Skipped DNF package installation.${RESET}"
        fi
    else
        echo -e "${YELLOW}  WARNING:${RESET} $DNF_LIST not found. Skipping package installation."
    fi
else
    echo -e "${YELLOW}  WARNING:${RESET} DNF not found. Skipping package installation."
fi

# --- Homebrew Package Installation ---
echo -e "\n${BOLD}--- Installing packages from Brewfile ---${RESET}"

BREWFILE="$SCRIPT_DIR/packages/Brewfile"

if command -v brew &> /dev/null; then
    if [ -f "$BREWFILE" ]; then
        echo -e "${YELLOW}Do you want to install packages from Brewfile?${RESET}"
        read -p "This may take a while. Continue? (y/N): " confirm
        if [[ "$confirm" =~ ^[yY]$ ]]; then
            echo -e "${CYAN}Installing Homebrew packages...${RESET}"
            brew bundle --file="$BREWFILE"
            echo -e "${GREEN}Homebrew package installation complete.${RESET}"
        else
            echo -e "${YELLOW}Skipped Homebrew package installation.${RESET}"
        fi
    else
        echo -e "${YELLOW}  WARNING:${RESET} $BREWFILE not found. Skipping Homebrew installation."
    fi
else
    echo -e "${YELLOW}  WARNING:${RESET} Homebrew not found. Skipping package installation."
fi

# --- Starship Installation ---
echo -e "\n${BOLD}--- Installing Starship prompt ---${RESET}"

if command -v starship &> /dev/null; then
    echo -e "${GREEN}  INFO:${RESET} Starship is already installed."
else
    echo -e "${YELLOW}Do you want to install Starship prompt?${RESET}"
    read -p "This will download and install Starship. Continue? (y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        echo -e "${CYAN}Installing Starship...${RESET}"
        if command -v curl &> /dev/null; then
            curl -sS https://starship.rs/install.sh | sh
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Starship installation complete.${RESET}"
            else
                echo -e "${RED}  ERROR:${RESET} Starship installation failed."
            fi
        else
            echo -e "${RED}  ERROR:${RESET} curl not found. Cannot install Starship."
        fi
    else
        echo -e "${YELLOW}Skipped Starship installation.${RESET}"
    fi
fi

# --- Oh My Zsh Installation ---
echo -e "\n${BOLD}--- Installing Oh My Zsh ---${RESET}"

OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"

if [ -d "$OH_MY_ZSH_DIR" ]; then
    echo -e "${GREEN}  INFO:${RESET} Oh My Zsh is already installed."
else
    echo -e "${YELLOW}Do you want to install Oh My Zsh?${RESET}"
    read -p "This will download and install Oh My Zsh. Continue? (y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        echo -e "${CYAN}Installing Oh My Zsh...${RESET}"
        if command -v wget &> /dev/null; then
            # Download the install script
            wget -q https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O /tmp/oh-my-zsh-install.sh
            if [ $? -eq 0 ]; then
                # Run the install script with unattended mode
                RUNZSH=no sh /tmp/oh-my-zsh-install.sh
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Oh My Zsh installation complete.${RESET}"
                    # Clean up the install script
                    rm -f /tmp/oh-my-zsh-install.sh
                else
                    echo -e "${RED}  ERROR:${RESET} Oh My Zsh installation failed."
                fi
            else
                echo -e "${RED}  ERROR:${RESET} Failed to download Oh My Zsh install script."
            fi
        elif command -v curl &> /dev/null; then
            # Fallback to curl if wget is not available
            curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /tmp/oh-my-zsh-install.sh
            if [ $? -eq 0 ]; then
                # Run the install script with unattended mode
                RUNZSH=no sh /tmp/oh-my-zsh-install.sh
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Oh My Zsh installation complete.${RESET}"
                    # Clean up the install script
                    rm -f /tmp/oh-my-zsh-install.sh
                else
                    echo -e "${RED}  ERROR:${RESET} Oh My Zsh installation failed."
                fi
            else
                echo -e "${RED}  ERROR:${RESET} Failed to download Oh My Zsh install script."
            fi
        else
            echo -e "${RED}  ERROR:${RESET} Neither wget nor curl found. Cannot install Oh My Zsh."
        fi
    else
        echo -e "${YELLOW}Skipped Oh My Zsh installation.${RESET}"
    fi
fi

# --- Tmux Plugin Manager Installation ---
echo -e "\n${BOLD}--- Installing Tmux Plugin Manager ---${RESET}"

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
    echo -e "${GREEN}  INFO:${RESET} Tmux Plugin Manager is already installed."
else
    echo -e "${YELLOW}Do you want to install Tmux Plugin Manager?${RESET}"
    read -p "This will clone the TPM repository. Continue? (y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        echo -e "${CYAN}Installing Tmux Plugin Manager...${RESET}"
        if command -v git &> /dev/null; then
            mkdir -p "$HOME/.tmux/plugins"
            git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Tmux Plugin Manager installation complete.${RESET}"
            else
                echo -e "${RED}  ERROR:${RESET} Failed to clone TPM repository."
            fi
        else
            echo -e "${RED}  ERROR:${RESET} git not found. Cannot install TPM."
        fi
    else
        echo -e "${YELLOW}Skipped TPM installation.${RESET}"
    fi
fi

# --- Function to create a symbolic link ---
link_file() {
    local source_file="$1"
    local target_file="$2"
    local display_name="$3"

    echo -e "${CYAN}Processing ${display_name}...${RESET}"

    if [ ! -f "$source_file" ]; then
        echo -e "${YELLOW}  WARNING:${RESET} Source file '$source_file' does not exist. Skipping."
        return 1
    fi

    if [ -e "$target_file" ]; then
        if [ -L "$target_file" ]; then
            if [ "$(readlink "$target_file")" == "$source_file" ]; then
                echo -e "${GREEN}  INFO:${RESET} '$target_file' already correctly symlinked. Skipping."
                return 0
            else
                echo -e "${YELLOW}  WARNING:${RESET} '$target_file' exists and is a symlink to a different location."
                read -p "    Overwrite with new symlink? (y/N): " response
                if [[ "$response" =~ ^[yY]$ ]]; then
                    rm "$target_file"
                    echo -e "${CYAN}    Removed existing symlink.${RESET}"
                else
                    echo -e "${YELLOW}    Skipping '$target_file'.${RESET}"
                    return 1
                fi
            fi
        else
            echo -e "${YELLOW}  WARNING:${RESET} '$target_file' exists and is a regular file/directory."
            read -p "    Backup and replace with symlink? (y/N): " response
            if [[ "$response" =~ ^[yY]$ ]]; then
                mv "$target_file" "${target_file}.backup_$(date +%Y%m%d%H%M%S)"
                echo -e "${CYAN}    Backed up as '${target_file}.backup_$(date +%Y%m%d%H%M%S)'.${RESET}"
            else
                echo -e "${YELLOW}    Skipping '$target_file'.${RESET}"
                return 1
            fi
        fi
    fi

    ln -s "$source_file" "$target_file"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  SUCCESS:${RESET} Linked '$source_file' to '$target_file'."
    else
        echo -e "${RED}  ERROR:${RESET} Failed to link '$source_file' to '$target_file'."
        return 1
    fi
}

# --- Zsh Configuration ---
echo -e "\n${BOLD}--- Setting up Zsh configuration ---${RESET}"
link_file "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc" ".zshrc"

# --- Git Configuration ---
echo -e "\n${BOLD}--- Setting up Git configuration ---${RESET}"
link_file "$SCRIPT_DIR/git/.gitconfig" "$HOME/.gitconfig" ".gitconfig"
link_file "$SCRIPT_DIR/git/.gitignore_global" "$HOME/.gitignore_global" ".gitignore_global"

# --- Tmux Configuration ---
echo -e "\n${BOLD}--- Setting up Tmux configuration ---${RESET}"
link_file "$SCRIPT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf" ".tmux.conf"

# --- Starship Configuration ---
echo -e "\n${BOLD}--- Setting up Starship configuration ---${RESET}"
link_file "$SCRIPT_DIR/starship/starship.toml" "$HOME/.config/starship.toml" "starship.toml"

# --- Helix Configuration ---
echo -e "\n${BOLD}--- Setting up Helix configuration ---${RESET}"

mkdir -p "$HOME/.config/helix"
if [ $? -ne 0 ]; then
    echo -e "${RED}  ERROR:${RESET} Failed to create '$HOME/.config/helix'. Skipping Helix setup."
else
    link_file "$SCRIPT_DIR/helix/config.toml" "$HOME/.config/helix/config.toml" "Helix config.toml"

    if [ -f "$SCRIPT_DIR/helix/languages.toml" ]; then
        link_file "$SCRIPT_DIR/helix/languages.toml" "$HOME/.config/helix/languages.toml" "Helix languages.toml"
    else
        echo -e "${GREEN}  INFO:${RESET} No languages.toml found. Skipping."
    fi
fi

# --- WezTerm Configuration ---
echo -e "\n${BOLD}--- Setting up WezTerm configuration ---${RESET}"
WEZTERM_CONFIG_DIR="$HOME/.config/wezterm"
mkdir -p "$WEZTERM_CONFIG_DIR"
if [ $? -ne 0 ]; then
    echo -e "${RED}  ERROR:${RESET} Failed to create '$WEZTERM_CONFIG_DIR'. Skipping WezTerm setup."
else
    link_file "$SCRIPT_DIR/wezterm/wezterm.lua" "$WEZTERM_CONFIG_DIR/wezterm.lua" "WezTerm wezterm.lua"
    link_file "$SCRIPT_DIR/wezterm/events.lua" "$WEZTERM_CONFIG_DIR/events.lua" "WezTerm events.lua"
    link_file "$SCRIPT_DIR/wezterm/config.lua" "$WEZTERM_CONFIG_DIR/config.lua" "WezTerm config.lua"
fi

# --- Zed Configuration ---
echo -e "\n${BOLD}--- Setting up Zed configuration ---${RESET}"
ZED_CONFIG_DIR="$HOME/.config/zed"
mkdir -p "$ZED_CONFIG_DIR"
if [ $? -ne 0 ]; then
    echo -e "${RED}  ERROR:${RESET} Failed to create '$ZED_CONFIG_DIR'. Skipping Zed setup."
else
    link_file "$SCRIPT_DIR/zed/settings.json" "$ZED_CONFIG_DIR/settings.json" "Zed settings.json"
    link_file "$SCRIPT_DIR/zed/keymap.json" "$ZED_CONFIG_DIR/keymap.json" "Zed keymap.json"
fi

# --- Yazi Configuration ---
echo -e "\n${BOLD}--- Setting up Yazi configuration ---${RESET}"
YAZI_CONFIG_DIR="$HOME/.config/yazi"
mkdir -p "$YAZI_CONFIG_DIR"
if [ $? -ne 0 ]; then
    echo -e "${RED}  ERROR:${RESET} Failed to create '$YAZI_CONFIG_DIR'. Skipping Yazi setup."
else
    # Link all yazi config files if they exist
    for config_file in yazi.toml keymap.toml theme.toml; do
        if [ -f "$SCRIPT_DIR/yazi/$config_file" ]; then
            link_file "$SCRIPT_DIR/yazi/$config_file" "$YAZI_CONFIG_DIR/$config_file" "Yazi $config_file"
        fi
    done
fi

# --- Fastfetch Configuration ---
echo -e "\n${BOLD}--- Setting up Fastfetch configuration ---${RESET}"
FASTFETCH_CONFIG_DIR="$HOME/.config/fastfetch"
mkdir -p "$FASTFETCH_CONFIG_DIR"
if [ $? -ne 0 ]; then
    echo -e "${RED}  ERROR:${RESET} Failed to create '$FASTFETCH_CONFIG_DIR'. Skipping Fastfetch setup."
else
    link_file "$SCRIPT_DIR/fastfetch/config.jsonc" "$FASTFETCH_CONFIG_DIR/config.jsonc" "Fastfetch config.jsonc"
fi

# --- Btop Configuration ---
echo -e "\n${BOLD}--- Setting up Btop configuration ---${RESET}"
BTOP_CONFIG_DIR="$HOME/.config/btop"
mkdir -p "$BTOP_CONFIG_DIR"
if [ $? -ne 0 ]; then
    echo -e "${RED}  ERROR:${RESET} Failed to create '$BTOP_CONFIG_DIR'. Skipping Btop setup."
else
    link_file "$SCRIPT_DIR/btop/btop.conf" "$BTOP_CONFIG_DIR/btop.conf" "Btop btop.conf"
fi


echo -e "\n${GREEN}Dotfiles setup complete!${RESET}"
