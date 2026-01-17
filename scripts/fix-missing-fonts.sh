#!/bin/bash

# Fix Missing Fonts - Downloads fonts that failed in initial script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TEMP_DIR=$(mktemp -d)

echo "Fixing missing fonts..."
echo "Temp dir: $TEMP_DIR"
echo ""

# ============================================
# STANDARD PACKAGE - Missing fonts
# ============================================

echo "=== STANDARD PACKAGE ==="

# 1. Source Serif Pro (use Desktop.zip which contains TTF)
echo "Downloading Source Serif Pro..."
curl -L -o "$TEMP_DIR/source-serif.zip" \
    "https://github.com/adobe-fonts/source-serif/releases/download/4.005R/source-serif-4.005_Desktop.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/source-serif"
unzip -q -o "$TEMP_DIR/source-serif.zip" -d "$TEMP_DIR/source-serif" 2>/dev/null || true
find "$TEMP_DIR/source-serif" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/standard/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/standard/licenses/SourceSerifPro"
find "$TEMP_DIR/source-serif" -name "LICENSE*" -o -name "OFL*" -exec cp {} "$ROOT_DIR/packages/standard/licenses/SourceSerifPro/" \; 2>/dev/null || true
echo "  Done: $(ls "$ROOT_DIR/packages/standard/fonts"/SourceSerif*.ttf 2>/dev/null | wc -l) files"

# 2. Open Sans (no releases - download from repo directly)
echo "Downloading Open Sans..."
curl -L -o "$TEMP_DIR/opensans.zip" \
    "https://github.com/googlefonts/opensans/archive/refs/heads/main.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/opensans"
unzip -q -o "$TEMP_DIR/opensans.zip" -d "$TEMP_DIR/opensans" 2>/dev/null || true
find "$TEMP_DIR/opensans" -path "*/fonts/ttf/*.ttf" -exec cp {} "$ROOT_DIR/packages/standard/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/standard/licenses/OpenSans"
find "$TEMP_DIR/opensans" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/standard/licenses/OpenSans/" \; 2>/dev/null || true
echo "  Done: $(ls "$ROOT_DIR/packages/standard/fonts"/OpenSans*.ttf 2>/dev/null | wc -l) files"

# 3. Montserrat (no release assets - download from repo)
echo "Downloading Montserrat..."
curl -L -o "$TEMP_DIR/montserrat.zip" \
    "https://github.com/JulietaUla/Montserrat/archive/refs/heads/master.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/montserrat"
unzip -q -o "$TEMP_DIR/montserrat.zip" -d "$TEMP_DIR/montserrat" 2>/dev/null || true
find "$TEMP_DIR/montserrat" -path "*/fonts/ttf/*.ttf" -exec cp {} "$ROOT_DIR/packages/standard/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/standard/licenses/Montserrat"
find "$TEMP_DIR/montserrat" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/standard/licenses/Montserrat/" \; 2>/dev/null || true
echo "  Done: $(ls "$ROOT_DIR/packages/standard/fonts"/Montserrat*.ttf 2>/dev/null | wc -l) files"

# 4. EB Garamond (fix - need to look in correct path)
echo "Re-downloading EB Garamond..."
curl -L -o "$TEMP_DIR/ebgaramond.zip" \
    "https://github.com/georgd/EB-Garamond/archive/refs/heads/master.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/ebgaramond"
unzip -q -o "$TEMP_DIR/ebgaramond.zip" -d "$TEMP_DIR/ebgaramond" 2>/dev/null || true
# EB Garamond stores TTF in ttf/ subfolder
find "$TEMP_DIR/ebgaramond" -path "*/ttf/*.ttf" -exec cp {} "$ROOT_DIR/packages/standard/fonts/" \; 2>/dev/null || true
# Also try OTF if no TTF
if [ $(ls "$ROOT_DIR/packages/standard/fonts"/EBGaramond*.ttf 2>/dev/null | wc -l) -eq 0 ]; then
    find "$TEMP_DIR/ebgaramond" -path "*/otf/*.otf" -exec cp {} "$ROOT_DIR/packages/standard/fonts/" \; 2>/dev/null || true
fi
echo "  Done: $(ls "$ROOT_DIR/packages/standard/fonts"/EBGaramond* 2>/dev/null | wc -l) files"

# 5. Lato (fix - the latofonts.com URL may be broken)
echo "Re-downloading Lato..."
# Try Google Fonts github
curl -L -o "$TEMP_DIR/lato.zip" \
    "https://github.com/googlefonts/latoGFVersion/archive/refs/heads/main.zip" 2>/dev/null || \
curl -L -o "$TEMP_DIR/lato.zip" \
    "https://github.com/betsegaw/lato/archive/refs/heads/master.zip" 2>/dev/null || true
mkdir -p "$TEMP_DIR/lato"
unzip -q -o "$TEMP_DIR/lato.zip" -d "$TEMP_DIR/lato" 2>/dev/null || true
find "$TEMP_DIR/lato" -name "Lato*.ttf" -exec cp {} "$ROOT_DIR/packages/standard/fonts/" \; 2>/dev/null || true
find "$TEMP_DIR/lato" -path "*/fonts/ttf/*.ttf" -exec cp {} "$ROOT_DIR/packages/standard/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/standard/licenses/Lato"
find "$TEMP_DIR/lato" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/standard/licenses/Lato/" \; 2>/dev/null || true
echo "  Done: $(ls "$ROOT_DIR/packages/standard/fonts"/Lato*.ttf 2>/dev/null | wc -l) files"

# Remove FiraCode from standard (it's a duplicate with code package)
echo "Removing FiraCode from standard (duplicate)..."
rm -f "$ROOT_DIR/packages/standard/fonts"/FiraCode*.ttf 2>/dev/null || true
rm -rf "$ROOT_DIR/packages/standard/licenses/FiraCode" 2>/dev/null || true
echo "  Done"

echo ""
echo "=== CODE PACKAGE ==="

# Victor Mono
echo "Downloading Victor Mono..."
curl -L -o "$TEMP_DIR/victorymono.zip" \
    "https://github.com/rubjo/victor-mono/raw/master/public/VictorMonoAll.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/victormono"
unzip -q -o "$TEMP_DIR/victorymono.zip" -d "$TEMP_DIR/victormono" 2>/dev/null || true
find "$TEMP_DIR/victormono" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/code/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/code/licenses/VictorMono"
find "$TEMP_DIR/victormono" -name "LICENSE*" -o -name "OFL*" -exec cp {} "$ROOT_DIR/packages/code/licenses/VictorMono/" \; 2>/dev/null || true
echo "  Done: $(ls "$ROOT_DIR/packages/code/fonts"/VictorMono*.ttf 2>/dev/null | wc -l) files"

# IBM Plex Mono (verify it's there)
echo "Verifying IBM Plex Mono..."
if [ $(ls "$ROOT_DIR/packages/code/fonts"/IBMPlexMono*.ttf 2>/dev/null | wc -l) -eq 0 ]; then
    echo "  Downloading IBM Plex Mono..."
    curl -L -o "$TEMP_DIR/ibmplex.zip" \
        "https://github.com/IBM/plex/releases/download/v6.4.2/TrueType.zip" 2>/dev/null
    mkdir -p "$TEMP_DIR/ibmplex"
    unzip -q -o "$TEMP_DIR/ibmplex.zip" -d "$TEMP_DIR/ibmplex" 2>/dev/null || true
    find "$TEMP_DIR/ibmplex" -path "*Mono*" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/code/fonts/" \; 2>/dev/null || true
fi
echo "  Done: $(ls "$ROOT_DIR/packages/code/fonts"/IBMPlexMono*.ttf 2>/dev/null | wc -l) files"

echo ""
echo "=== FULL PACKAGE ==="

# Check for missing fonts in full package
FULL_MISSING=""

# Check Nunito
if [ $(ls "$ROOT_DIR/packages/full/fonts"/Nunito*.ttf 2>/dev/null | wc -l) -eq 0 ]; then
    FULL_MISSING="$FULL_MISSING Nunito"
fi

# Noto Sans/Serif (these may not have been attempted)
echo "Downloading Noto Sans..."
curl -L -o "$TEMP_DIR/notosans.zip" \
    "https://github.com/notofonts/latin-greek-cyrillic/releases/download/NotoSans-v2.015/NotoSans-v2.015.zip" 2>/dev/null || true
mkdir -p "$TEMP_DIR/notosans"
unzip -q -o "$TEMP_DIR/notosans.zip" -d "$TEMP_DIR/notosans" 2>/dev/null || true
find "$TEMP_DIR/notosans" -name "NotoSans-*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
echo "  Done: $(ls "$ROOT_DIR/packages/full/fonts"/NotoSans*.ttf 2>/dev/null | wc -l) files"

echo "Downloading Noto Serif..."
curl -L -o "$TEMP_DIR/notoserif.zip" \
    "https://github.com/notofonts/latin-greek-cyrillic/releases/download/NotoSerif-v2.015/NotoSerif-v2.015.zip" 2>/dev/null || true
mkdir -p "$TEMP_DIR/notoserif"
unzip -q -o "$TEMP_DIR/notoserif.zip" -d "$TEMP_DIR/notoserif" 2>/dev/null || true
find "$TEMP_DIR/notoserif" -name "NotoSerif-*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
echo "  Done: $(ls "$ROOT_DIR/packages/full/fonts"/NotoSerif*.ttf 2>/dev/null | wc -l) files"

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "========================================="
echo "Fix complete! New font counts:"
echo "========================================="
echo "  standard: $(ls -1 "$ROOT_DIR/packages/standard/fonts"/*.ttf 2>/dev/null | wc -l) TTF files"
echo "  code: $(ls -1 "$ROOT_DIR/packages/code/fonts"/*.ttf 2>/dev/null | wc -l) TTF files"
echo "  full: $(ls -1 "$ROOT_DIR/packages/full/fonts"/*.ttf 2>/dev/null | wc -l) TTF files"
echo ""
echo "Font families in standard:"
ls "$ROOT_DIR/packages/standard/fonts"/*.ttf 2>/dev/null | xargs -n1 basename | sed 's/-.*//; s/\[.*//' | sort -u
echo ""
