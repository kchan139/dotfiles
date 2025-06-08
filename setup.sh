#!/bin/bash

# setup.sh
# This script sets up dotfiles by creating symbolic links from this
# repository to the appropriate locations in the home directory.
# It is designed to work on both Linux and macOS.

# Define the source directory (where this script resides)
# This gets the directory where the script is located, handling symlinks
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Starting dotfiles setup..."
echo "Dotfiles repository located at: $SCRIPT_DIR"

# --- Function to create a symbolic link ---
link_file() {
    local source_file="$1"
    local target_file="$2"
    local display_name="$3"

    echo "Processing $display_name..."

    if [ ! -f "$source_file" ]; then
        echo "  WARNING: Source file '$source_file' does not exist. Skipping."
        return 1
    fi

    if [ -e "$target_file" ]; then
        if [ -L "$target_file" ]; then
            if [ "$(readlink "$target_file")" == "$source_file" ]; then
                echo "  INFO: '$target_file' already correctly symlinked. Skipping."
                return 0
            else
                echo "  WARNING: '$target_file' exists and is a symlink to a different location."
                read -p "    Do you want to overwrite it with a new symlink? (y/N): " response
                if [[ "$response" =~ ^[yY]$ ]]; then
                    rm "$target_file"
                    echo "    Removed existing symlink."
                else
                    echo "    Skipping '$target_file'."
                    return 1
                fi
            fi
        else
            echo "  WARNING: '$target_file' exists and is a regular file/directory."
            read -p "    Do you want to backup the existing file and create a symlink? (y/N): " response
            if [[ "$response" =~ ^[yY]$ ]]; then
                mv "$target_file" "${target_file}.backup_$(date +%Y%m%d%H%M%S)"
                echo "    Backed up existing '$target_file' to '${target_file}.backup_$(date +%Y%m%d%H%M%S)'."
            else
                echo "    Skipping '$target_file' to preserve existing content."
                return 1
            fi
        fi
    fi

    ln -s "$source_file" "$target_file"
    if [ $? -eq 0 ]; then
        echo "  SUCCESS: Linked '$source_file' to '$target_file'."
    else
        echo "  ERROR: Failed to link '$source_file' to '$target_file'."
        return 1
    fi
}

# --- Bash Configuration ---
echo ""
echo "--- Setting up Bash configuration ---"
link_file "$SCRIPT_DIR/bash/.bashrc" "$HOME/.bashrc" ".bashrc"

# --- Git Configuration ---
echo ""
echo "--- Setting up Git configuration ---"
link_file "$SCRIPT_DIR/git/.gitconfig" "$HOME/.gitconfig" ".gitconfig"

# --- Helix Configuration ---
echo ""
echo "--- Setting up Helix configuration ---"

mkdir -p "$HOME/.config/helix"
if [ $? -ne 0 ]; then
    echo "  ERROR: Failed to create '$HOME/.config/helix'. Skipping Helix setup."
else
    link_file "$SCRIPT_DIR/helix/config.toml" "$HOME/.config/helix/config.toml" "Helix config.toml"

    if [ -f "$SCRIPT_DIR/helix/languages.toml" ]; then
        link_file "$SCRIPT_DIR/helix/languages.toml" "$HOME/.config/helix/languages.toml" "Helix languages.toml"
    else
        echo "  INFO: No languages.toml found in $SCRIPT_DIR/helix. Skipping languages.toml setup."
    fi
fi

# --- WezTerm Configuration ---
echo ""
echo "--- Setting up WezTerm configuration ---"
WEZTERM_CONFIG_DIR="$HOME/.config/wezterm"
mkdir -p "$WEZTERM_CONFIG_DIR"
if [ $? -ne 0 ]; then
    echo "  ERROR: Failed to create '$WEZTERM_CONFIG_DIR'. Skipping WezTerm setup."
else
    link_file "$SCRIPT_DIR/wezterm/wezterm.lua" "$WEZTERM_CONFIG_DIR/wezterm.lua" "WezTerm wezterm.lua"

fi

# --- Zsh Configuration ---
echo ""
echo "--- Setting up Zsh configuration ---"
link_file "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc" ".zshrc"

echo ""
echo "Dotfiles setup complete!"
