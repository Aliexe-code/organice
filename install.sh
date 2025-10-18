#!/bin/bash

# File Organizer Installation Script
# Automatically installs the file organizer binary

set -e

BINARY="organize"
INSTALL_DIR="/usr/local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  File Organizer Installation Script${NC}"
echo -e "${BLUE}=====================================${NC}"
echo

# Check if running as root for system-wide installation
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}Note: Not running as root.${NC}"
    echo -e "${YELLOW}Will attempt to install to ${INSTALL_DIR} (may require sudo)${NC}"
    echo
    USE_SUDO="sudo"
else
    USE_SUDO=""
fi

# Check if binary exists
if [ ! -f "$SCRIPT_DIR/$BINARY" ]; then
    echo -e "${RED}Error: Binary '$BINARY' not found in $SCRIPT_DIR${NC}"
    echo -e "${YELLOW}Please ensure you're running this script from the file-organizer directory${NC}"
    exit 1
fi

# Make binary executable
echo -e "${BLUE}[1/3]${NC} Making binary executable..."
chmod +x "$SCRIPT_DIR/$BINARY"

# Check if already installed
if [ -f "$INSTALL_DIR/$BINARY" ]; then
    echo -e "${YELLOW}Warning: $BINARY is already installed in $INSTALL_DIR${NC}"
    read -p "Do you want to overwrite it? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        exit 0
    fi
fi

# Copy binary to installation directory
echo -e "${BLUE}[2/3]${NC} Installing to $INSTALL_DIR..."
if $USE_SUDO cp "$SCRIPT_DIR/$BINARY" "$INSTALL_DIR/$BINARY"; then
    echo -e "${GREEN}✓ Binary copied successfully${NC}"
else
    echo -e "${RED}✗ Failed to copy binary${NC}"
    echo -e "${YELLOW}You can manually install by running:${NC}"
    echo -e "  sudo cp $SCRIPT_DIR/$BINARY $INSTALL_DIR/"
    exit 1
fi

# Verify installation
echo -e "${BLUE}[3/3]${NC} Verifying installation..."
if command -v organize &> /dev/null; then
    VERSION_CHECK=$(organize 2>&1 | head -1)
    echo -e "${GREEN}✓ Installation successful!${NC}"
    echo
    echo -e "${GREEN}=====================================${NC}"
    echo -e "${GREEN}  File Organizer installed!${NC}"
    echo -e "${GREEN}=====================================${NC}"
    echo
    echo -e "${BLUE}Usage:${NC}"
    echo -e "  organize <directory>           ${YELLOW}# Organize files${NC}"
    echo -e "  organize <directory> --dry-run ${YELLOW}# Preview changes${NC}"
    echo
    echo -e "${BLUE}Examples:${NC}"
    echo -e "  organize ~/Downloads --dry-run"
    echo -e "  organize ~/Desktop"
    echo
    echo -e "Run ${BLUE}organize${NC} without arguments to see full help."
else
    echo -e "${YELLOW}Warning: 'organize' command not found in PATH${NC}"
    echo -e "${YELLOW}You may need to restart your terminal or run:${NC}"
    echo -e "  source ~/.bashrc"
    echo
    echo -e "Or check your PATH includes: $INSTALL_DIR"
fi

echo
echo -e "${BLUE}Binary location:${NC} $INSTALL_DIR/$BINARY"
echo -e "${BLUE}Documentation:${NC} $SCRIPT_DIR/README.md"
echo -e "${BLUE}Uninstall:${NC} sudo rm $INSTALL_DIR/$BINARY"
echo
