#!/bin/bash

# Check if .bashrc or .bash_profile exist, and set the appropriate configuration file
if [ -f "$HOME/.bashrc" ]; then
  CONFIG_FILE="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
  CONFIG_FILE="$HOME/.bash_profile"
elif [ -f "$HOME/.zshrc" ]; then
  CONFIG_FILE="$HOME/.zshrc"
else
  echo "Neither .bashrc nor .bash_profile were found. Exiting."
  exit 1
fi

# Install pyenv only if it doesn't exist
if [ ! -d "$HOME/.pyenv" ]; then
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
else
  echo "pyenv already exists. Skipping clone."
fi

# Set up environment variables
if ! grep -q 'export PYENV_ROOT="$HOME/.pyenv"' "$CONFIG_FILE"; then
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$CONFIG_FILE"
fi

if ! grep -q 'export PATH="$PYENV_ROOT/bin:$PATH"' "$CONFIG_FILE"; then
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> "$CONFIG_FILE"
fi

if ! grep -q 'if command -v pyenv 1>/dev/null 2>&1; then' "$CONFIG_FILE"; then
  echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init --path)"\nfi' >> "$CONFIG_FILE"
fi

# Apply the changes to the current shell
source "$CONFIG_FILE"
exec $SHELL
# Check if pyenv is installed
if command -v pyenv 1>/dev/null 2>&1; then
  echo "pyenv installed successfully."
else
  echo "Something went wrong. pyenv not found in PATH."
  exit 1
fi
