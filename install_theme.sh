#!/bin/bash

THEME_NAME="gettowork"
GITHUB_USERNAME="Diogo13Antunes"
THEME_REPO="https://github.com/$GITHUB_USERNAME/Get_To_Work.git"
ZSH_THEME_DIR="$HOME/.oh-my-zsh/themes"
ZSHRC_FILE="$HOME/.zshrc"

install_dependencies() {
	echo "Checking and installing dependencies..."

	if ! command -v git &> /dev/null; then
		echo "Installing Git..."
		if [ "$(uname)" == "Darwin" ]; then
			brew install git
		else
			sudo apt-get update
			sudo apt-get install git -y
		fi
	fi

	if [ ! -d "$ZSH_THEME_DIR" ]; then
		echo "Installing Oh My Zsh..."
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	fi

	echo "Dependencies installed successfully!"
}

install_theme() {
	echo "Installing theme..."
	git clone "$THEME_REPO" || { echo "Error: Unable to clone the repository."; exit 1; }
	mkdir -p "$ZSH_THEME_DIR" || { echo "Error: Unable to create directory $ZSH_THEME_DIR."; exit 1; }
	cp "Get_To_Work/$THEME_NAME.zsh-theme" "$ZSH_THEME_DIR/" || { echo "Error: Unable to move theme file to $ZSH_THEME_DIR."; exit 1; }

	if [ ! -f "$ZSHRC_FILE" ]; then
		echo "Error: .zshrc file not found. Please create it in your home directory and try again."
		exit 1
	fi

	if [ "$(uname)" == "Darwin" ]; then
		sed -i '' "s/ZSH_THEME=\".*\"/ZSH_THEME=\"$THEME_NAME\"/" "$ZSHRC_FILE" || { echo "Error: Unable to set theme in $ZSHRC_FILE."; exit 1; }
	else
		sed -i "s/ZSH_THEME=\".*\"/ZSH_THEME=\"$THEME_NAME\"/" "$ZSHRC_FILE" || { echo "Error: Unable to set theme in $ZSHRC_FILE."; exit 1; }
	fi

	echo "Theme installed successfully!"
	echo "Please restart your terminal or run 'source $ZSHRC_FILE' to apply the changes."
}

install_dependencies

cleanup_installation() {
    echo "Cleaning up installation files..."
    rm -rf Get_To_Work
    echo "Cleanup complete!"
}

if ! command -v git &> /dev/null || [ ! -d "$ZSH_THEME_DIR" ]; then
	echo "Error: Some dependencies were not installed properly."
	exit 1
fi

if [ -f "$ZSH_THEME_DIR/$THEME_NAME.zsh-theme" ]; then
	echo "Error: A theme with the name '$THEME_NAME' already exists in $ZSH_THEME_DIR."
	exit 1
fi

install_theme

cleanup_installation
