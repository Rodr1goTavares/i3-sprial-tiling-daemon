#!/bin/sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}"
echo " ___           _        _ _ "
echo "|_ _|_ __  ___| |_ __ _| | |"
echo " | || '_ \\/ __| __/ _\` | | |"
echo " | || | | \\__ \\ || (_| | | |"
echo "|___|_| |_|___/\\__\\__,_|_|_|"
echo -e "${NC}"

# Detect OS and architecture
OS=$(uname -s)
ARCH=$(uname -m)

# Set binary name and URL
case "$OS" in
    Linux|Darwin) FILE="i3std" ;;
    *) echo -e "${RED}❌ System not supported!${NC}" && exit 1 ;;
esac

GITHUB_REPO="Rodr1goTavares/i3-sprial-tiling-daemon"
URL="https://github.com/$GITHUB_REPO/releases/latest/download/$FILE"

# Installation directory
BIN_DIR="$HOME/.local/bin"
BIN_PATH="$BIN_DIR/$FILE"

# Create directory if it doesn't exist
mkdir -p "$BIN_DIR"

# Download the binary
echo "Downloading $FILE from $URL..."
if ! wget -q --show-progress -O "$BIN_PATH" "$URL"; then
    echo -e "${RED}❌ Download failed. Check your internet or the URL.${NC}"
    exit 1
fi

# Make it executable
if ! chmod +x "$BIN_PATH"; then
    echo -e "${RED}❌ Failed to make the binary executable.${NC}"
    exit 1
fi

# Function to add a line to shell config if missing
add_line_if_missing() {
    local file=$1
    local line=$2

    if [ -f "$file" ]; then
        if ! grep -Fxq "$line" "$file"; then
            echo "$line" >> "$file"
            echo -e "${GREEN}✔ Added to $file:${NC} $line"
            return 0
        fi
    fi
    return 1
}

# Add BIN_DIR to PATH persistently
case "$SHELL" in
    */bash)
        add_line_if_missing "$HOME/.bashrc" "export PATH=\"$BIN_DIR:\$PATH\""
        ;;
    */zsh)
        add_line_if_missing "$HOME/.zshrc" "export PATH=\"$BIN_DIR:\$PATH\""
        ;;
    */fish)
        if [ -f "$HOME/.config/fish/config.fish" ]; then
            if ! grep -q "set -Ux PATH $BIN_DIR" "$HOME/.config/fish/config.fish"; then
                echo "set -Ux PATH $BIN_DIR \$PATH" >> "$HOME/.config/fish/config.fish"
                echo -e "${GREEN}✔ Added to fish config.fish:${NC} set -Ux PATH $BIN_DIR \$PATH"
            fi
        fi
        ;;
    *)
        add_line_if_missing "$HOME/.profile" "export PATH=\"$BIN_DIR:\$PATH\""
        ;;
esac

# Add I3_SOCKET_PATH export permanently
I3_SOCKET_EXPORT='export I3_SOCKET_PATH=$(i3 --get-socketpath 2>/dev/null)'

ADDED_SOCKET_PATH=0

for profile in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
    if add_line_if_missing "$profile" "$I3_SOCKET_EXPORT"; then
        ADDED_SOCKET_PATH=1
    fi
done

if [ $ADDED_SOCKET_PATH -eq 1 ]; then
    echo -e "${GREEN}✔ I3_SOCKET_PATH export added to your shell profiles.${NC}"
else
    echo -e "${GREEN}ℹ I3_SOCKET_PATH export already configured.${NC}"
fi

echo -e "${GREEN}✅ Installation complete!"
echo -e "⚠️ Please run 'source ~/.bashrc' or 'source ~/.zshrc' or reopen your terminal to apply changes.${NC}"

