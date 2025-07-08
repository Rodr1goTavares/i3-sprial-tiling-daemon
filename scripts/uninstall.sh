#!/bin/sh

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


echo -e "${RED}"
echo " _   _       _           _        _ _  "
echo "| | | |_ __ (_)_ __  ___| |_ __ _| | | "
echo "| | | | '_ \| | '_ \/ __| __/ _\` | | | "
echo "| |_| | | | | | | | \__ \ || (_| | | | "
echo " \___/|_| |_|_|_| |_|___/\__\__,_|_|_| "
echo -e "${NC}"

# Binary paths
LOCAL_BIN="$HOME/.local/bin/i3_spiral_daemon"
GLOBAL_BIN="/usr/local/bin/i3_spiral_daemon"

# Remove from local bin
if [ -f "$LOCAL_BIN" ]; then
    echo "Removing i3_spiral_daemon from $LOCAL_BIN..."
    if rm -f "$LOCAL_BIN"; then
        echo -e "${GREEN}✔ Removed from local bin.${NC}"
    else
        echo -e "${RED}✘ Failed to remove from local bin.${NC}"
    fi
fi

# Remove from global bin (requires sudo)
if [ -f "$GLOBAL_BIN" ]; then
    echo "Removing i3_spiral_daemon from $GLOBAL_BIN..."
    if sudo rm -f "$GLOBAL_BIN"; then
        echo -e "${GREEN}✔ Removed from global bin.${NC}"
    else
        echo -e "${RED}✘ Failed to remove from global bin.${NC}"
    fi
fi

# Remove PATH entries from shell configs
CONFIG_FILES="$HOME/.bashrc $HOME/.zshrc $HOME/.config/fish/config.fish $HOME/.profile"
for CONFIG_FILE in $CONFIG_FILES; do
    if [ -f "$CONFIG_FILE" ]; then
        if grep -q "\.local/bin" "$CONFIG_FILE"; then
            echo "Removing $HOME/.local/bin from $CONFIG_FILE"
            sed -i '/\.local\/bin/d' "$CONFIG_FILE"
        fi
        if grep -q "I3_SOCKET_PATH" "$CONFIG_FILE"; then
            echo "Removing I3_SOCKET_PATH export from $CONFIG_FILE"
            sed -i '/I3_SOCKET_PATH/d' "$CONFIG_FILE"
        fi
    fi
done

echo ""
echo -e "${GREEN}i3_spiral_daemon successfully uninstalled. Restart your terminal to apply changes.${NC}"

