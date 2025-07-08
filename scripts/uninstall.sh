#!/bin/sh

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}"
echo " _   _       _           _        _ _  "
echo "| | | |_ __ (_)_ __  ___| |_ __ _| | | "
echo "| | | | '_ \\| | '_ \\/ __| __/ _\` | | | "
echo "| |_| | | | | | | | \\__ \\ || (_| | | | "
echo " \\___/|_| |_|_|_| |_|___/\\__\\__,_|_|_| "
echo -e "${NC}"

BIN_NAME="i3std"
BIN_PATH="$HOME/.local/bin/$BIN_NAME"

# Remove the local binary
if [ -f "$BIN_PATH" ]; then
    echo "Removing $BIN_NAME from $BIN_PATH..."
    if rm -f "$BIN_PATH"; then
        echo -e "${GREEN}✔ Successfully removed.${NC}"
    else
        echo -e "${RED}✘ Failed to remove the binary.${NC}"
    fi
else
    echo -e "${RED}Binary not found at $BIN_PATH.${NC}"
fi

# Remove PATH and I3_SOCKET_PATH exports from shell config files
CONFIG_FILES="$HOME/.bashrc $HOME/.zshrc $HOME/.profile $HOME/.config/fish/config.fish"
for FILE in $CONFIG_FILES; do
    if [ -f "$FILE" ]; then
        # Remove lines adding ~/.local/bin to PATH
        if grep -q "\.local/bin" "$FILE"; then
            echo "Removing ~/.local/bin from PATH in $FILE"
            sed -i '/\.local\/bin/d' "$FILE"
        fi
        # Remove export of I3_SOCKET_PATH
        if grep -q "I3_SOCKET_PATH" "$FILE"; then
            echo "Removing export I3_SOCKET_PATH from $FILE"
            sed -i '/I3_SOCKET_PATH/d' "$FILE"
        fi
    fi
done

echo ""
echo -e "${GREEN}✔ i3std successfully uninstalled. Please restart your terminal to apply changes.${NC}"

