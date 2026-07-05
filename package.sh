#!/bin/bash

# Munching Millipede - Versioning and Packaging Script
# This script handles version replacement and package creation

set -e

# Get the version from config.json
VERSION=$(grep -o '"version": "[^"]*' config.json | grep -o '[^"]*$')
echo "🎮 Packaging Munching Millipede v$VERSION"

# Verify required tools
if ! command -v c1541 &> /dev/null; then
    echo "❌ Error: c1541 (from VICE) is required but not found"
    exit 1
fi

# Build the C64 project with version injection
echo "🔨 Building C64 project..."

# Temporarily inject version for build
sed -i.bak "s/###VERSION###/$VERSION/g" "c64/src/intro.bas"
trap 'mv -f "c64/src/intro.bas.bak" "c64/src/intro.bas" 2>/dev/null || true' EXIT

# Use Python compiler to rebuild (from VS64 extension)
BC_EXE="$HOME/.vscode/extensions/rosc.vs64-2.6.2/tools/bc.py"

if command -v python3 &> /dev/null && [ -f "$BC_EXE" ]; then
    python3 "$BC_EXE" --crunch --map "c64/build/The Munching Millipede.bmap" \
        -I "c64" -I "c64/build" \
        -o "c64/build/The Munching Millipede.prg" "c64/src/main.bas"
else
    echo "❌ Error: python3 or VS64 compiler tool not found"
    exit 1
fi

# Restore original source file
mv "c64/src/intro.bas.bak" "c64/src/intro.bas"
trap - EXIT

# Create d64 image from the PRG file
echo "💾 Creating d64 image..."
PRG_FILE="c64/build/The Munching Millipede.prg"
D64_FILE="c64/build/The Munching Millipede.d64"

if [ ! -f "$PRG_FILE" ]; then
    echo "❌ Error: PRG file not found at $PRG_FILE"
    exit 1
fi

# Use lowercase here so c1541 writes a PETSCII name that BASIC can resolve
# with LOAD "MILLIPEDE",8,1 in the default C64 character mode.
c1541 -format "munching,00" d64 "$D64_FILE" -write "$PRG_FILE" "millipede"

# Add configured binary assets (for example charset PRGs) to the D64 image.
if [ -f "c64/tools/add_config_binaries.py" ]; then
    echo "🧩 Adding configured binaries to d64 image..."
    python3 "c64/tools/add_config_binaries.py"
fi

# Create the zip package
echo "📦 Creating zip package..."
ZIP_FILE="c64/build/munching-millipede-v${VERSION}.zip"

# Remove old zip if it exists
rm -f "$ZIP_FILE"

(
    cd "c64/build"
    zip -j "munching-millipede-v${VERSION}.zip" "The Munching Millipede.d64" "../../assets/manual.png" "../../readme.txt" >/dev/null
)

echo ""
echo "✅ Packaging complete!"
echo "📦 Created: $ZIP_FILE"
echo "   - The Munching Millipede.d64"
echo "   - assets/manual.png"
echo "   - readme.txt"
