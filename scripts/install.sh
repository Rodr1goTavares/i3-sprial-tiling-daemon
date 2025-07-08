#!/usr/bin/env bash

set -e

BIN_NAME="i3_spiral_daemon"
INSTALL_DIR="$HOME/.local/bin"
PROFILE_FILES=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile")

# Troque essa URL pela real do seu release (binário Linux x86_64)
DOWNLOAD_URL="https://github.com/seuusuario/seurepositorio/releases/latest/download/$BIN_NAME-linux-amd64"

echo "Baixando $BIN_NAME..."
mkdir -p "$INSTALL_DIR"
wget -q --show-progress -O "$INSTALL_DIR/$BIN_NAME" "$DOWNLOAD_URL"
chmod +x "$INSTALL_DIR/$BIN_NAME"

echo "Configurando variável I3_SOCKET_PATH no perfil do usuário..."

# Detecta shell e adiciona export de I3_SOCKET_PATH se não existir
for profile in "${PROFILE_FILES[@]}"; do
  if [ -f "$profile" ]; then
    if ! grep -q "export I3_SOCKET_PATH=" "$profile"; then
      echo "export I3_SOCKET_PATH=\$(i3 --get-socketpath)" >> "$profile"
      echo "Adicionado export I3_SOCKET_PATH em $profile"
    fi
  fi
done

echo "Instalação concluída! Verifique se $INSTALL_DIR está no seu PATH."
echo "Para aplicar a variável I3_SOCKET_PATH, reinicie seu terminal ou rode:"
echo "source ~/.bashrc  # ou ~/.zshrc, ~/.profile conforme seu shell"
echo "Execute o daemon com: $BIN_NAME"

