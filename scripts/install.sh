#!/bin/sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}"
echo " ___           _        _ _ "
echo "|_ _|_ __  ___| |_ __ _| | |"
echo " | || '_ \/ __| __/ _\` | | |"
echo " | || | | \__ \ || (_| | | |"
echo "|___|_| |_|___/\__\__,_|_|_|"
echo -e "${NC}"

# Detect OS and architecture
OS=$(uname -s)
ARCH=$(uname -m)

# Set binary name and URL
case "$OS" in
    Linux|Darwin) FILE="i3_spiral_daemon" ;;
    *) echo "${RED}System not supported!${NC}" && exit 1 ;;
esac

GITHUB_REPO="Rodr1goTavares/i3-spiral-tiling-daemon"
URL="https://github.com/$GITHUB_REPO/releases/latest/download/$FILE"

# Installation directory
BIN_DIR="$HOME/.local/bin"
BIN_PATH="$BIN_DIR/$FILE"

# Create directory if it doesn't exist
mkdir -p "$BIN_DIR"

# Download the binary
echo "Downloading $FILE from $URL..."
if ! wget -q --show-progress -O "$BIN_PATH" "$URL"; then
    echo "${RED}❌ Download failed. Check your internet or the URL.${NC}"
    exit 1
fi

# Make it executable
if ! chmod +x "$BIN_PATH"; then
    echo "${RED}❌ Failed to make the binary executable.${NC}"
    exit 1
fi

# Check if the directory is in PATH
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo "${GREEN}Adding $BIN_DIR to PATH...${NC}"
    case "$SHELL" in
        */bash) echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc" ;;
        */zsh)  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" ;;
        */fish) echo 'set -Ux PATH $HOME/.local/bin $PATH' >> "$HOME/.config/fish/config.fish" ;;
        *)      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile" ;;
    esac
fi

# Add I3_SOCKET_PATH export if missing
EXPORT_CMD='export I3_SOCKET_PATH=$(i3 --get-socketpath)'
ADDED_SOCKET_PATH=0
for profile in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
    if [ -f "$profile" ]; then
        if ! grep -q "I3_SOCKET_PATH=" "$profile"; then
            echo "$EXPORT_CMD" >> "$profile"
            ADDED_SOCKET_PATH=1
        fi
    fi
done

if [ $ADDED_SOCKET_PATH -eq 1 ]; then
    echo "${GREEN}I3_SOCKET_PATH has been added to your shell profile.${NC}"
else
    echo "${GREEN}I3_SOCKET_PATH already configured in your environment.${NC}"
fi

echo -e "${GREEN}✅ Installation complete!"

