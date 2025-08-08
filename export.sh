#!/bin/bash

# VS Code Configuration Export Script
# Run this script to export all your VS Code settings

echo "🔧 Exporting VS Code Configuration..."

# Create export directory
mkdir -p vscode-config
cd vscode-config

# 1. Export installed extensions list
echo "📦 Exporting extensions list..."
code --list-extensions > extensions.txt

# 2. Copy settings.json (macOS paths)
echo "⚙️  Copying settings.json..."
if [ -f "$HOME/Library/Application Support/Code/User/settings.json" ]; then
    cp "$HOME/Library/Application Support/Code/User/settings.json" ./settings.json
else
    echo "❌ settings.json not found"
fi

# 3. Copy keybindings.json
echo "⌨️  Copying keybindings.json..."
if [ -f "$HOME/Library/Application Support/Code/User/keybindings.json" ]; then
    cp "$HOME/Library/Application Support/Code/User/keybindings.json" ./keybindings.json
else
    echo "❌ keybindings.json not found"
fi

# 4. Copy snippets folder
echo "📝 Copying snippets..."
if [ -d "$HOME/Library/Application Support/Code/User/snippets" ]; then
    cp -r "$HOME/Library/Application Support/Code/User/snippets" ./snippets/
else
    echo "❌ snippets folder not found"
fi

# 5. Copy workspace settings if they exist
echo "🗂️  Copying workspace settings..."
if [ -d "$HOME/Library/Application Support/Code/User/workspaceStorage" ]; then
    # Only copy the global workspace settings
    mkdir -p workspaceStorage
    # This is optional - workspace storage can be large
fi

# 6. Create a restore script
echo "📜 Creating restore script..."
cat > restore.sh << 'EOF'
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
EOF

chmod +x restore.sh

echo "✅ Export complete!"
echo "📁 All files saved in: $(pwd)"
echo ""
echo "Files exported:"
echo "  - extensions.txt (list of installed extensions)"
echo "  - settings.json (your settings)"
echo "  - keybindings.json (custom keybindings)"
echo "  - snippets/ (custom snippets folder)"
echo "  - restore.sh (script to restore everything)"
echo ""
echo "🚀 To use on another machine:"
echo "  1. Copy this entire folder to the target machine"
echo "  2. Run: ./restore.sh"