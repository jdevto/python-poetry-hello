#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Display system information
echo "System Information:"
uname -a

# Install Poetry
echo "Installing Poetry..."
if ! command -v poetry &> /dev/null; then
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "Poetry is already installed."
fi

# Verify Poetry installation
if ! command -v poetry &> /dev/null; then
    echo "Error: Poetry installation failed."
    exit 1
fi

# Configure Poetry to create virtual environments inside the project
poetry config virtualenvs.in-project true

# Install dependencies via Poetry
echo "Installing dependencies with Poetry..."
poetry install --with dev

# Ensure PYTHONPATH is set in the current session and persists across sessions
PYTHONPATH_ENTRY="/workspaces/test/src"
if ! grep -Fxq "export PYTHONPATH=$PYTHONPATH_ENTRY:\$PYTHONPATH" ~/.bashrc; then
    echo "Configuring PYTHONPATH..."
    echo "export PYTHONPATH=$PYTHONPATH_ENTRY:\$PYTHONPATH" >> ~/.bashrc
fi

# Add the Poetry virtual environment's `bin` directory to PATH
VENV_BIN_PATH="/workspaces/test/.venv/bin"
if ! grep -Fxq "export PATH=$VENV_BIN_PATH:\$PATH" ~/.bashrc; then
    echo "Adding Poetry virtual environment to PATH..."
    echo "export PATH=$VENV_BIN_PATH:\$PATH" >> ~/.bashrc
fi

# Load the updated bashrc configuration for the current session
source ~/.bashrc

# Validate that validate-devschema is accessible
echo "Validating script installation..."
if ! validate-devschema --help &> /dev/null; then
    echo "Error: validate-devschema script is not globally accessible."
    exit 1
else
    echo "validate-devschema is installed and ready to use."
fi

# Display completion message
echo "Development container setup complete!"
