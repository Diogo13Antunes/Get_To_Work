#!/bin/bash

THEME_NAME="gettowork"
GITHUB_USERNAME="Diogo13Antunes"
THEME_REPO="https://github.com/$GITHUB_USERNAME/Get_To_Work.git"
ZSH_THEME_DIR="$HOME/.oh-my-zsh/themes"
ZSHRC_FILE="$HOME/.zshrc"

install_theme() {
    echo "Installing theme..."
    git clone "$THEME_REPO" || { echo "Error: Unable to clone the repository."; exit 1; }
    mkdir -p "$ZSH_THEME_DIR" || { echo "Error: Unable to create directory $ZSH_THEME_DIR."; exit 1; }
    mv "$THEME_NAME.zsh-theme" "$ZSH_THEME_DIR/" || { echo "Error: Unable to move theme file to $ZSH_THEME_DIR."; exit 1; }
    sed -i '' "s/ZSH_THEME=\".*\"/ZSH_THEME=\"$THEME_NAME\"/" "$ZSHRC_FILE" || { echo "Error: Unable to set theme in $ZSHRC_FILE."; exit 1; }
    echo "Theme installed successfully!"
    echo "Please restart your terminal or run 'source $ZSHRC_FILE' to apply the changes."
}

if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed. Please install Git to continue."
    exit 1
fi

if [ ! -d "$ZSH_THEME_DIR" ]; then
    echo "Error: Oh My Zsh is not installed. Please install Oh My Zsh and try again."
    exit 1
fi

if [ -f "$ZSH_THEME_DIR/$THEME_NAME.zsh-theme" ]; then
    echo "Error: A theme with the name '$THEME_NAME' already exists in $ZSH_THEME_DIR."
    exit 1
fi

install_theme
