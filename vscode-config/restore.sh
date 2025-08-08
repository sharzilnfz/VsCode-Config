#!/bin/bash

echo "🔧 Restoring VS Code Configuration..."

# Detect OS and set paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    VSCODE_USER_DIR="$HOME/.config/Code/User"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    # Windows (Git Bash)
    VSCODE_USER_DIR="$APPDATA/Code/User"
else
    echo "❌ Unsupported OS"
    exit 1
fi

echo "📍 Using directory: $VSCODE_USER_DIR"

# Create user directory if it doesn't exist
mkdir -p "$VSCODE_USER_DIR"

# 1. Install extensions
if [ -f "extensions.txt" ]; then
    echo "📦 Installing extensions..."
    while IFS= read -r extension; do
        echo "Installing: $extension"
        code --install-extension "$extension"
    done < extensions.txt
else
    echo "❌ extensions.txt not found"
fi

# 2. Copy settings.json
if [ -f "settings.json" ]; then
    echo "⚙️  Copying settings.json..."
    cp settings.json "$VSCODE_USER_DIR/settings.json"
else
    echo "❌ settings.json not found"
fi

# 3. Copy keybindings.json
if [ -f "keybindings.json" ]; then
    echo "⌨️  Copying keybindings.json..."
    cp keybindings.json "$VSCODE_USER_DIR/keybindings.json"
else
    echo "❌ keybindings.json not found"
fi

# 4. Copy snippets
if [ -d "snippets" ]; then
    echo "📝 Copying snippets..."
    cp -r snippets "$VSCODE_USER_DIR/"
else
    echo "❌ snippets folder not found"
fi

echo "✅ Configuration restored! Please restart VS Code."
