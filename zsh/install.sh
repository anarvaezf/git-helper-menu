#!/usr/bin/env bash

set -e

INSTALL_DIR="$HOME/.git-helper-menu"
ZSHRC="$HOME/.zshrc"
SOURCE_LINE="source $INSTALL_DIR/git-helpers.zsh"

echo "Installing git-helper-menu..."

mkdir -p "$INSTALL_DIR"

cp git-helpers.zsh "$INSTALL_DIR/git-helpers.zsh"

if ! grep -q "$SOURCE_LINE" "$ZSHRC"; then
  echo "" >> "$ZSHRC"
  echo "# Git Helper Menu" >> "$ZSHRC"
  echo "$SOURCE_LINE" >> "$ZSHRC"
  echo "Added git helpers to .zshrc"
else
  echo "git helpers already configured in .zshrc"
fi

echo ""
echo "Installation complete."
echo "Restart your terminal or run:"
echo ""
echo "source ~/.zshrc"
echo ""
echo "Then press Ctrl + G to open the menu."