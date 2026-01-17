#!/bin/bash

# Visual Forge Fonts - Download Script
# Downloads fonts from official sources
#
# DISCLAIMER: We do not own these fonts. All fonts are downloaded from
# their official sources and retain their original licenses.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo "Visual Forge Fonts - Download Script"
echo "========================================"
echo ""
echo "DISCLAIMER: We do not own these fonts."
echo "All fonts are property of their creators."
echo ""

# Create directories
mkdir -p "$ROOT_DIR/packages/minimal/fonts"
mkdir -p "$ROOT_DIR/packages/minimal/licenses/liberation"
mkdir -p "$ROOT_DIR/packages/minimal/licenses/inter"
mkdir -p "$ROOT_DIR/packages/minimal/licenses/jetbrains-mono"

mkdir -p "$ROOT_DIR/packages/standard/fonts"
mkdir -p "$ROOT_DIR/packages/standard/licenses"

mkdir -p "$ROOT_DIR/packages/full/fonts"
mkdir -p "$ROOT_DIR/packages/full/licenses"

mkdir -p "$ROOT_DIR/packages/code/fonts"
mkdir -p "$ROOT_DIR/packages/code/licenses"

TEMP_DIR=$(mktemp -d)
echo "Using temp directory: $TEMP_DIR"

# Function to download and extract Google Fonts
download_google_font() {
    local font_name="$1"
    local output_dir="$2"
    local license_dir="$3"

    echo "Downloading $font_name from Google Fonts..."

    # Google Fonts API URL
    local url="https://fonts.google.com/download?family=${font_name// /%20}"

    curl -L -o "$TEMP_DIR/${font_name}.zip" "$url" 2>/dev/null || {
        echo "  Warning: Could not download $font_name"
        return 1
    }

    unzip -q -o "$TEMP_DIR/${font_name}.zip" -d "$TEMP_DIR/${font_name}" 2>/dev/null || {
        echo "  Warning: Could not extract $font_name"
        return 1
    }

    # Copy TTF files
    find "$TEMP_DIR/${font_name}" -name "*.ttf" -exec cp {} "$output_dir/" \;

    # Copy license
    find "$TEMP_DIR/${font_name}" -name "OFL.txt" -exec cp {} "$license_dir/LICENSE" \;
    find "$TEMP_DIR/${font_name}" -name "LICENSE*" -exec cp {} "$license_dir/" \;

    echo "  ✓ $font_name downloaded"
}

# Function to download from GitHub releases
download_github_release() {
    local repo="$1"
    local asset_pattern="$2"
    local output_dir="$3"
    local license_dir="$4"
    local font_name="$5"

    echo "Downloading $font_name from GitHub ($repo)..."

    # Get latest release
    local release_url="https://api.github.com/repos/$repo/releases/latest"
    local download_url=$(curl -s "$release_url" | grep "browser_download_url.*$asset_pattern" | head -1 | cut -d '"' -f 4)

    if [ -z "$download_url" ]; then
        echo "  Warning: Could not find release for $font_name"
        return 1
    fi

    curl -L -o "$TEMP_DIR/${font_name}.zip" "$download_url" 2>/dev/null
    unzip -q -o "$TEMP_DIR/${font_name}.zip" -d "$TEMP_DIR/${font_name}" 2>/dev/null

    # Copy TTF files
    find "$TEMP_DIR/${font_name}" -name "*.ttf" -exec cp {} "$output_dir/" \;

    # Copy license
    find "$TEMP_DIR/${font_name}" -name "OFL.txt" -exec cp {} "$license_dir/LICENSE" \;
    find "$TEMP_DIR/${font_name}" -name "LICENSE*" -exec cp {} "$license_dir/" \;

    echo "  ✓ $font_name downloaded"
}

echo ""
echo "=== MINIMAL BUNDLE ==="
echo ""

# Liberation Fonts (from GitHub)
echo "Downloading Liberation Fonts..."
LIBERATION_URL="https://github.com/liberationfonts/liberation-fonts/files/7261482/liberation-fonts-ttf-2.1.5.tar.gz"
curl -L -o "$TEMP_DIR/liberation.tar.gz" "$LIBERATION_URL" 2>/dev/null
tar -xzf "$TEMP_DIR/liberation.tar.gz" -C "$TEMP_DIR"
cp "$TEMP_DIR"/liberation-fonts-ttf-*/Liberation*.ttf "$ROOT_DIR/packages/minimal/fonts/"
cp "$TEMP_DIR"/liberation-fonts-ttf-*/LICENSE "$ROOT_DIR/packages/minimal/licenses/liberation/"
echo "  ✓ Liberation Fonts downloaded"

# Inter (from GitHub)
download_github_release "rsms/inter" "Inter.*zip" "$ROOT_DIR/packages/minimal/fonts" "$ROOT_DIR/packages/minimal/licenses/inter" "Inter"

# JetBrains Mono (from GitHub)
download_github_release "JetBrains/JetBrainsMono" "JetBrainsMono.*zip" "$ROOT_DIR/packages/minimal/fonts" "$ROOT_DIR/packages/minimal/licenses/jetbrains-mono" "JetBrainsMono"

echo ""
echo "=== STANDARD BUNDLE ==="
echo "(Includes all minimal fonts plus more)"
echo ""

# Copy minimal fonts to standard
cp -r "$ROOT_DIR/packages/minimal/fonts/"* "$ROOT_DIR/packages/standard/fonts/" 2>/dev/null || true
cp -r "$ROOT_DIR/packages/minimal/licenses/"* "$ROOT_DIR/packages/standard/licenses/" 2>/dev/null || true

# Additional fonts for standard bundle
STANDARD_FONTS=(
    "EB Garamond"
    "Merriweather"
    "Source Sans Pro"
    "Source Serif Pro"
    "Source Code Pro"
    "Roboto"
    "Open Sans"
    "Lato"
    "Fira Code"
    "Oswald"
    "Montserrat"
)

for font in "${STANDARD_FONTS[@]}"; do
    mkdir -p "$ROOT_DIR/packages/standard/licenses/${font// /-}"
    download_google_font "$font" "$ROOT_DIR/packages/standard/fonts" "$ROOT_DIR/packages/standard/licenses/${font// /-}"
done

echo ""
echo "=== CODE BUNDLE ==="
echo ""

# Code-specific fonts
CODE_FONTS=(
    "JetBrains Mono"
    "Fira Code"
    "Source Code Pro"
    "IBM Plex Mono"
    "Inconsolata"
    "Roboto Mono"
    "Ubuntu Mono"
    "Space Mono"
    "Anonymous Pro"
)

for font in "${CODE_FONTS[@]}"; do
    mkdir -p "$ROOT_DIR/packages/code/licenses/${font// /-}"
    download_google_font "$font" "$ROOT_DIR/packages/code/fonts" "$ROOT_DIR/packages/code/licenses/${font// /-}"
done

# Cascadia Code (from Microsoft GitHub)
download_github_release "microsoft/cascadia-code" "CascadiaCode.*zip" "$ROOT_DIR/packages/code/fonts" "$ROOT_DIR/packages/code/licenses/cascadia-code" "CascadiaCode"

# Hack (from GitHub)
download_github_release "source-foundry/Hack" "Hack.*ttf.zip" "$ROOT_DIR/packages/code/fonts" "$ROOT_DIR/packages/code/licenses/hack" "Hack"

# Victor Mono (from GitHub)
download_github_release "rubjo/victor-mono" "VictorMono.*zip" "$ROOT_DIR/packages/code/fonts" "$ROOT_DIR/packages/code/licenses/victor-mono" "VictorMono"

echo ""
echo "=== FULL BUNDLE ==="
echo "(Includes all fonts)"
echo ""

# Copy standard fonts to full
cp -r "$ROOT_DIR/packages/standard/fonts/"* "$ROOT_DIR/packages/full/fonts/" 2>/dev/null || true
cp -r "$ROOT_DIR/packages/standard/licenses/"* "$ROOT_DIR/packages/full/licenses/" 2>/dev/null || true

# Copy code-specific fonts to full
cp -r "$ROOT_DIR/packages/code/fonts/"* "$ROOT_DIR/packages/full/fonts/" 2>/dev/null || true
cp -r "$ROOT_DIR/packages/code/licenses/"* "$ROOT_DIR/packages/full/licenses/" 2>/dev/null || true

# Additional fonts for full bundle
FULL_ADDITIONAL_FONTS=(
    "Libre Baskerville"
    "Crimson Pro"
    "Lora"
    "Playfair Display"
    "Cormorant"
    "Spectral"
    "Noto Serif"
    "Nunito"
    "Work Sans"
    "Poppins"
    "IBM Plex Sans"
    "Fira Sans"
    "Barlow"
    "Outfit"
    "Manrope"
    "Raleway"
    "Bebas Neue"
    "Anton"
    "Archivo"
    "DM Sans"
    "Space Grotesk"
    "Sora"
    "Lexend"
    "Noto Sans"
)

for font in "${FULL_ADDITIONAL_FONTS[@]}"; do
    mkdir -p "$ROOT_DIR/packages/full/licenses/${font// /-}"
    download_google_font "$font" "$ROOT_DIR/packages/full/fonts" "$ROOT_DIR/packages/full/licenses/${font// /-}"
done

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "========================================"
echo "Download complete!"
echo "========================================"
echo ""
echo "Package sizes:"
du -sh "$ROOT_DIR/packages/minimal/fonts" 2>/dev/null || echo "  minimal: (empty)"
du -sh "$ROOT_DIR/packages/standard/fonts" 2>/dev/null || echo "  standard: (empty)"
du -sh "$ROOT_DIR/packages/full/fonts" 2>/dev/null || echo "  full: (empty)"
du -sh "$ROOT_DIR/packages/code/fonts" 2>/dev/null || echo "  code: (empty)"
echo ""
echo "REMINDER: All fonts retain their original licenses."
echo "See licenses/ directory in each package."
echo ""
