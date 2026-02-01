#!/bin/bash
# This script creates symlinks from the home directory to the dotfiles in this repository.


# 1. Install SW
if command -v apt &> /dev/null; then
    sudo apt update
    sudo apt install -y neovim tmux git curl tar ripgrep tig clang nodejs-lts python golang
elif command -v pkg &> /dev/null; then
    termux-setup-storage
    pkg update
    pkg install -y termux-api
    pkg install -y neovim tmux git curl tar ripgrep tig clang nodejs-lts python golang
    go install github.com/d-kuro/gwq/cmd/gwq@latest
    go install github.com/x-motemen/ghq@latest
    npm install -g @google/gemini-cli --ignore-scripts
elif command -v dnf &> /dev/null; then
    # RHEL/CentOS/Fedora系の場合
    sudo dnf install -y neovim tmux git curl tar ripgrep tig clang nodejs-lts python golang
else
    echo "Can't detect Package Manager !!!"
fi


# Get the directory of this script
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to copy a file and create its parent directory if needed
# $1: source file in dotfiles repo
# $2: target file in home directory
copy_file_and_create_dir() {
    local source_file="$1"
    local target_file="$2"
    local target_dir

    # Ensure the source file exists
    if [ ! -e "$source_file" ]; then
        echo "Source file not found: $source_file"
        return
    fi

    # Create parent directory of target if it doesn't exist
    target_dir=$(dirname "$target_file")
    if [ ! -d "$target_dir" ]; then
        echo "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi

    # Remove existing file or symlink at the target location (not needed for cp -f)
    # if [ -e "$target_file" ] || [ -L "$target_file" ]; then
    #     echo "Removing existing file: $target_file"
    #     rm -rf "$target_file"
    # fi

    # Copy the file
    echo "Copying file: $target_file <- $source_file"
    cp -f "$source_file" "$target_file"
    echo "---------------------------------"
}

# Bash
copy_file_and_create_dir "$DOTFILES_DIR/bashrc.sh" "$HOME/.bashrc"

# Tig
copy_file_and_create_dir "$DOTFILES_DIR/tig.rc" "$HOME/.tigrc"

# Tmux
copy_file_and_create_dir "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"

# Alacritty
copy_file_and_create_dir "$DOTFILES_DIR/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# Lazygit
copy_file_and_create_dir "$DOTFILES_DIR/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

# Neovim
copy_file_and_create_dir "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
copy_file_and_create_dir "$DOTFILES_DIR/nvim/coc-settings.json" "$HOME/.config/nvim/coc-settings.json"

# Vim
copy_file_and_create_dir "$DOTFILES_DIR/vim/vimrc.vim" "$HOME/.vimrc"
copy_file_and_create_dir "$DOTFILES_DIR/vim/vim/statusline.vim" "$HOME/.vim/statusline.vim"

# Git
copy_file_and_create_dir "$DOTFILES_DIR/git/config" "$HOME/.gitconfig"

# Ghq
copy_file_and_create_dir "$DOTFILES_DIR/gwq/config.toml" "$HOME/.config/ghq/config.toml"

echo "Setup complete."
