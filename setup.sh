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
    local display_name="$3" # For more descriptive output

    echo "Processing $display_name..."

    # Check if the source file exists
    if [ ! -f "$source_file" ]; then
        echo "  WARNING: Source file '$source_file' does not exist. Skipping."
        return 1
    fi

    # Check if the target file/symlink already exists
    if [ -e "$target_file" ]; then
        if [ -L "$target_file" ]; then
            # If it's already a symlink, check if it points to the correct source
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
            # If it's a regular file, ask to back it up or overwrite
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

    # Create the symbolic link
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
# Ensure the ~/.config/helix directory exists
mkdir -p "$HOME/.config/helix"
if [ $? -ne 0 ]; then
    echo "  ERROR: Failed to create '$HOME/.config/helix'. Skipping Helix setup."
else
    link_file "$SCRIPT_DIR/helix/config.toml" "$HOME/.config/helix/config.toml" "Helix config.toml"
    # Assuming there might be a languages.toml as well from previous discussion
    if [ -f "$SCRIPT_DIR/helix/languages.toml" ]; then
        link_file "$SCRIPT_DIR/helix/languages.toml" "$HOME/.config/helix/languages.toml" "Helix languages.toml"
    else
        echo "  INFO: No languages.toml found in $SCRIPT_DIR/helix. Skipping languages.toml setup."
    fi
fi

# --- WezTerm Configuration ---
echo ""
echo "--- Setting up WezTerm configuration ---"
# Define the preferred WezTerm config directory
WEZTERM_CONFIG_DIR="$HOME/.config/wezterm"
mkdir -p "$WEZTERM_CONFIG_DIR"
if [ $? -ne 0 ]; then
    echo "  ERROR: Failed to create '$WEZTERM_CONFIG_DIR'. Skipping WezTerm setup."
else
    # Link the main wezterm.lua file
    link_file "$SCRIPT_DIR/wezterm/wezterm.lua" "$WEZTERM_CONFIG_DIR/wezterm.lua" "WezTerm wezterm.lua"

    # You might have other WezTerm config files (e.g., in a 'colors' sub-directory)
    # If so, you'd add more linking logic here:
    # Example: If you have a 'colors' directory in your dotfiles for WezTerm themes
    # if [ -d "$SCRIPT_DIR/wezterm/colors" ]; then
    #     echo "  Linking WezTerm colors directory..."
    #     link_file "$SCRIPT_DIR/wezterm/colors" "$WEZTERM_CONFIG_DIR/colors" "WezTerm colors directory"
    # fi
fi

echo ""
echo "Dotfiles setup complete!"
echo "Please remember to source your .bashrc (e.g., 'source ~/.bashrc' or restart your terminal) for changes to take effect."
echo "If you have a separate .zshrc or .profile, you might need to manually link or configure them."
