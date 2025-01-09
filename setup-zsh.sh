#!/bin/bash
OHMYZSH_INSTALL_SCRIPT="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# Check if zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "zsh not found. Installing zsh..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install zsh || { echo "Failed to install zsh on macOS"; exit 1; }
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sudo apt update && sudo apt install -y zsh || { echo "Failed to install zsh on Linux"; exit 1; }
    else
        echo "Unsupported OS. Please install zsh manually."
        exit 1
    fi
else
    echo "zsh is already installed."
fi

# Set zsh as the default shell
if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "Setting zsh as the default shell..."
    chsh -s "$(command -v zsh)" || { echo "Failed to set zsh as default shell"; exit 1; }
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(sh -c "$(curl -fsSL $OHMYZSH_INSTALL_SCRIPT)")" || { echo "Oh My Zsh installation failed"; exit 1; }
else
    echo "Oh My Zsh is already installed."
fi

# Install Plugins
# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed."
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting already installed."
fi

# Install Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "Powerlevel10k theme already installed."
fi


# Copy config files to $HOME
ZSHRC_SRC="./.zshrc"
P10K_SRC="./.p10k.zsh"
ZSHRC_DEST="$HOME/.zshrc"
P10K_DEST="$HOME/.p10k.zsh"

# Copy .zshrc to home if not already there or if it's different
if [ ! -f "$ZSHRC_DEST" ] || ! cmp -s "$ZSHRC_SRC" "$ZSHRC_DEST"; then
    echo "Installing .zshrc to $HOME..."
    cp "$ZSHRC_SRC" "$ZSHRC_DEST"
else
    echo ".zshrc is already up to date."
fi

# Copy .p10k.zsh to home if not already there or if it's different
if [ ! -f "$P10K_DEST" ] || ! cmp -s "$P10K_SRC" "$P10K_DEST"; then
    echo "Installing .p10k.zsh to $HOME..."
    cp "$P10K_SRC" "$P10K_DEST"
else
    echo ".p10k.zsh is already up to date."
fi


echo "Zsh and Oh My Zsh setup complete! Please restart your terminal."
