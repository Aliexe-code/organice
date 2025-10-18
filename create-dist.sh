#!/bin/bash

# Create Distribution Package Script
# Bundles File Organizer for distribution

set -e

VERSION="1.0.0"
PLATFORM="linux-x64"
DIST_NAME="file-organizer-${VERSION}-${PLATFORM}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Creating distribution package: ${DIST_NAME}${NC}"
echo

# Create distribution directory
echo -e "${BLUE}[1/4]${NC} Creating distribution directory..."
mkdir -p "dist/${DIST_NAME}"

# Copy files
echo -e "${BLUE}[2/4]${NC} Copying files..."
cp organize "dist/${DIST_NAME}/"
cp main.odin "dist/${DIST_NAME}/"
cp README.md "dist/${DIST_NAME}/"
cp INSTALL.md "dist/${DIST_NAME}/"
cp install.sh "dist/${DIST_NAME}/"

# Ensure binary is executable
chmod +x "dist/${DIST_NAME}/organize"
chmod +x "dist/${DIST_NAME}/install.sh"

# Create archives
echo -e "${BLUE}[3/4]${NC} Creating archives..."
cd dist

# Create tar.gz
tar -czf "${DIST_NAME}.tar.gz" "${DIST_NAME}/"
echo -e "${GREEN}✓ Created: ${DIST_NAME}.tar.gz${NC}"

# Create zip
zip -r -q "${DIST_NAME}.zip" "${DIST_NAME}/"
echo -e "${GREEN}✓ Created: ${DIST_NAME}.zip${NC}"

cd ..

# Calculate sizes and checksums
echo -e "${BLUE}[4/4]${NC} Generating checksums..."
cd dist

echo "# File Organizer v${VERSION} - ${PLATFORM}" > checksums.txt
echo "" >> checksums.txt
echo "## SHA256 Checksums" >> checksums.txt
sha256sum "${DIST_NAME}.tar.gz" >> checksums.txt
sha256sum "${DIST_NAME}.zip" >> checksums.txt
echo "" >> checksums.txt
echo "## File Sizes" >> checksums.txt
ls -lh "${DIST_NAME}.tar.gz" "${DIST_NAME}.zip" | awk '{print $9 ": " $5}' >> checksums.txt

cd ..

# Summary
echo
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Distribution packages created!${NC}"
echo -e "${GREEN}=====================================${NC}"
echo
echo -e "${BLUE}Location:${NC} ./dist/"
echo -e "${BLUE}Packages:${NC}"
echo "  - ${DIST_NAME}.tar.gz"
echo "  - ${DIST_NAME}.zip"
echo
echo -e "${BLUE}Size:${NC}"
ls -lh "dist/${DIST_NAME}.tar.gz" "dist/${DIST_NAME}.zip" | awk '{print "  " $9 ": " $5}'
echo
echo -e "${BLUE}Checksums:${NC} dist/checksums.txt"
echo
echo -e "${BLUE}Contents:${NC}"
echo "  - organize (binary, 187KB)"
echo "  - main.odin (source code)"
echo "  - README.md (documentation)"
echo "  - INSTALL.md (installation guide)"
echo "  - install.sh (automated installer)"
echo
echo -e "${GREEN}Ready for distribution!${NC}"
echo
echo -e "${BLUE}Users can install by:${NC}"
echo "  1. Extract the archive"
echo "  2. Run: ./install.sh"
echo "  3. Or manually: sudo cp organize /usr/local/bin/"
echo
