#!/bin/bash

THEME_NAME="gettowork"
DEFAULT_THEME="robbyrussell"
ZSH_THEME_DIR="$HOME/.oh-my-zsh/themes"
ZSHRC_FILE="$HOME/.zshrc"
ORIGINAL_ZSHRC="$HOME/.zshrc.original"

uninstall_theme() {
	echo "Uninstalling theme..."

	if [ -f "$ZSH_THEME_DIR/$THEME_NAME.zsh-theme" ]; then
		rm "$ZSH_THEME_DIR/$THEME_NAME.zsh-theme" || { echo "Error: Unable to remove theme file from $ZSH_THEME_DIR."; exit 1; }
		echo "Theme file removed successfully."
	else
		echo "Warning: Theme file '$THEME_NAME.zsh-theme' not found in $ZSH_THEME_DIR."
	fi

	if [ -f "$ORIGINAL_ZSHRC" ]; then
		mv "$ORIGINAL_ZSHRC" "$ZSHRC_FILE" || { echo "Error: Unable to restore original .zshrc file."; exit 1; }
		echo "Original .zshrc file restored successfully."
	else
		echo "Warning: Original .zshrc file not found. It may not have been modified."
	fi

	sed -i "s/ZSH_THEME=\"$THEME_NAME\"/ZSH_THEME=\"$DEFAULT_THEME\"/" "$ZSHRC_FILE" || { echo "Error: Unable to set theme in $ZSHRC_FILE."; exit 1; }
    echo "ZSH_THEME set to default theme '$DEFAULT_THEME'."

	echo "Theme uninstalled successfully!"
	echo "Restart your Terminal!"
}

if [ -f "$ZSH_THEME_DIR/$THEME_NAME.zsh-theme" ] || [ -f "$ORIGINAL_ZSHRC" ]; then
	uninstall_theme
else
	echo "Error: The theme '$THEME_NAME' doesn't seem to be installed."
	exit 1
fi
