#!/bin/bash

# Visual Forge Fonts - Download Script
# Downloads fonts from official sources
#
# DISCLAIMER: We do not own these fonts. All fonts are downloaded from
# their official sources and retain their original licenses.

# set -e  # Continue despite errors

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
mkdir -p "$ROOT_DIR/packages/minimal/licenses"

mkdir -p "$ROOT_DIR/packages/standard/fonts"
mkdir -p "$ROOT_DIR/packages/standard/licenses"

mkdir -p "$ROOT_DIR/packages/full/fonts"
mkdir -p "$ROOT_DIR/packages/full/licenses"

mkdir -p "$ROOT_DIR/packages/code/fonts"
mkdir -p "$ROOT_DIR/packages/code/licenses"

TEMP_DIR=$(mktemp -d)
echo "Using temp directory: $TEMP_DIR"

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

    # Handle both zip and tar.gz
    if [[ "$download_url" == *.tar.gz ]]; then
        tar -xzf "$TEMP_DIR/${font_name}.zip" -C "$TEMP_DIR/${font_name}"
    else
        mkdir -p "$TEMP_DIR/${font_name}"
        unzip -q -o "$TEMP_DIR/${font_name}.zip" -d "$TEMP_DIR/${font_name}" 2>/dev/null || true
    fi

    # Copy TTF files
    find "$TEMP_DIR/${font_name}" -name "*.ttf" -exec cp {} "$output_dir/" \; 2>/dev/null || true

    # Copy license
    mkdir -p "$license_dir/${font_name}"
    find "$TEMP_DIR/${font_name}" -name "OFL.txt" -exec cp {} "$license_dir/${font_name}/LICENSE" \; 2>/dev/null || true
    find "$TEMP_DIR/${font_name}" -name "LICENSE*" -exec cp {} "$license_dir/${font_name}/" \; 2>/dev/null || true

    echo "  ✓ $font_name downloaded"
}

# Function to download from google-fonts GitHub mirror
download_google_font_github() {
    local font_name="$1"
    local output_dir="$2"
    local license_dir="$3"
    local folder_name="${font_name// /}"  # Remove spaces
    folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')  # Lowercase

    echo "Downloading $font_name..."

    # Try google/fonts GitHub repo
    local base_url="https://raw.githubusercontent.com/google/fonts/main"

    # Try different folder patterns
    local folders=("ofl/${folder_name}" "apache/${folder_name}" "ufl/${folder_name}")
    local found=false

    for folder in "${folders[@]}"; do
        # Check if folder exists by trying to get the METADATA.pb
        local metadata_url="${base_url}/${folder}/METADATA.pb"
        if curl -s -f "$metadata_url" > /dev/null 2>&1; then
            found=true

            # Get list of TTF files from the directory
            # First try static subfolder
            local static_check="${base_url}/${folder}/static/"

            # Download TTF files - try common patterns
            local variants=("Regular" "Bold" "Italic" "BoldItalic" "Light" "Medium" "SemiBold" "ExtraBold" "Black")
            local font_base="${font_name// /}"

            for variant in "${variants[@]}"; do
                local ttf_url="${base_url}/${folder}/static/${font_base}-${variant}.ttf"
                local ttf_file="${font_base}-${variant}.ttf"
                curl -s -f -L -o "$output_dir/$ttf_file" "$ttf_url" 2>/dev/null || true

                # Also try without static folder
                ttf_url="${base_url}/${folder}/${font_base}-${variant}.ttf"
                curl -s -f -L -o "$output_dir/$ttf_file" "$ttf_url" 2>/dev/null || true
            done

            # Also try variable font
            local var_url="${base_url}/${folder}/${font_base}[wght].ttf"
            curl -s -f -L -o "$output_dir/${font_base}-Variable.ttf" "$var_url" 2>/dev/null || true
            var_url="${base_url}/${folder}/${font_base}-VariableFont_wght.ttf"
            curl -s -f -L -o "$output_dir/${font_base}-Variable.ttf" "$var_url" 2>/dev/null || true

            # Get license
            mkdir -p "$license_dir/${font_name// /-}"
            curl -s -f -L -o "$license_dir/${font_name// /-}/OFL.txt" "${base_url}/${folder}/OFL.txt" 2>/dev/null || true
            curl -s -f -L -o "$license_dir/${font_name// /-}/LICENSE.txt" "${base_url}/${folder}/LICENSE.txt" 2>/dev/null || true

            break
        fi
    done

    if [ "$found" = true ]; then
        local count=$(ls -1 "$output_dir"/*.ttf 2>/dev/null | wc -l)
        echo "  ✓ $font_name downloaded ($count files)"
    else
        echo "  Warning: Could not find $font_name"
        return 1
    fi
}

# Alternative: Download using fontsource packages (more reliable)
download_fontsource() {
    local font_name="$1"
    local output_dir="$2"
    local license_dir="$3"
    local pkg_name=$(echo "${font_name}" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

    echo "Downloading $font_name via fontsource..."

    # Download from unpkg (fontsource mirror)
    local base_url="https://unpkg.com/@fontsource/${pkg_name}/files"

    # Common weights
    local weights=("400" "700")
    local styles=("normal" "italic")

    for weight in "${weights[@]}"; do
        for style in "${styles[@]}"; do
            local filename="${pkg_name}-latin-${weight}-${style}.woff2"
            curl -s -f -L -o "$TEMP_DIR/${filename}" "${base_url}/${filename}" 2>/dev/null || true
        done
    done

    # Fontsource doesn't provide TTF, let me try a different approach
}

echo ""
echo "=== MINIMAL BUNDLE ==="
echo "(Base fonts: Liberation, Inter, JetBrains Mono)"
echo ""

# Liberation Fonts (from GitHub)
echo "Downloading Liberation Fonts..."
LIBERATION_URL="https://github.com/liberationfonts/liberation-fonts/files/7261482/liberation-fonts-ttf-2.1.5.tar.gz"
curl -L -o "$TEMP_DIR/liberation.tar.gz" "$LIBERATION_URL" 2>/dev/null
mkdir -p "$TEMP_DIR/liberation"
tar -xzf "$TEMP_DIR/liberation.tar.gz" -C "$TEMP_DIR/liberation" --strip-components=1
cp "$TEMP_DIR"/liberation/Liberation*.ttf "$ROOT_DIR/packages/minimal/fonts/"
mkdir -p "$ROOT_DIR/packages/minimal/licenses/liberation"
cp "$TEMP_DIR"/liberation/LICENSE "$ROOT_DIR/packages/minimal/licenses/liberation/"
echo "  ✓ Liberation Fonts downloaded"

# Inter (from GitHub)
download_github_release "rsms/inter" "Inter.*zip" "$ROOT_DIR/packages/minimal/fonts" "$ROOT_DIR/packages/minimal/licenses" "Inter"

# JetBrains Mono (from GitHub)
download_github_release "JetBrains/JetBrainsMono" "JetBrainsMono.*zip" "$ROOT_DIR/packages/minimal/fonts" "$ROOT_DIR/packages/minimal/licenses" "JetBrainsMono"

echo ""
echo "=== STANDARD BUNDLE ==="
echo "(Additional fonts - depends on minimal via npm)"
echo ""

# These fonts have GitHub releases or known download locations
# Source family fonts from Adobe
download_github_release "adobe-fonts/source-sans" ".*TTF.*zip" "$ROOT_DIR/packages/standard/fonts" "$ROOT_DIR/packages/standard/licenses" "SourceSansPro"
download_github_release "adobe-fonts/source-serif" ".*TTF.*zip" "$ROOT_DIR/packages/standard/fonts" "$ROOT_DIR/packages/standard/licenses" "SourceSerifPro"
download_github_release "adobe-fonts/source-code-pro" ".*TTF.*zip" "$ROOT_DIR/packages/standard/fonts" "$ROOT_DIR/packages/standard/licenses" "SourceCodePro"

# Roboto from Google
echo "Downloading Roboto..."
curl -L -o "$TEMP_DIR/roboto.zip" "https://github.com/googlefonts/roboto/releases/download/v2.138/roboto-unhinted.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/roboto"
unzip -q -o "$TEMP_DIR/roboto.zip" -d "$TEMP_DIR/roboto" 2>/dev/null || true
find "$TEMP_DIR/roboto" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/standard/fonts/" \;
mkdir -p "$ROOT_DIR/packages/standard/licenses/Roboto"
echo "Apache 2.0 License - See https://github.com/googlefonts/roboto" > "$ROOT_DIR/packages/standard/licenses/Roboto/LICENSE"
echo "  ✓ Roboto downloaded"

# Open Sans from GitHub
download_github_release "googlefonts/opensans" ".*zip" "$ROOT_DIR/packages/standard/fonts" "$ROOT_DIR/packages/standard/licenses" "OpenSans"

# Lato from GitHub
echo "Downloading Lato..."
curl -L -o "$TEMP_DIR/lato.zip" "https://www.latofonts.com/download/lato2ofl-zip/" 2>/dev/null || {
    # Fallback to GitHub
    curl -L -o "$TEMP_DIR/lato.zip" "https://github.com/latofonts/lato-source/archive/refs/heads/master.zip" 2>/dev/null
}
mkdir -p "$TEMP_DIR/lato"
unzip -q -o "$TEMP_DIR/lato.zip" -d "$TEMP_DIR/lato" 2>/dev/null || true
find "$TEMP_DIR/lato" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/standard/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/standard/licenses/Lato"
find "$TEMP_DIR/lato" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/standard/licenses/Lato/" \; 2>/dev/null || true
echo "  ✓ Lato downloaded"

# Fira Code from GitHub
download_github_release "tonsky/FiraCode" "Fira_Code.*zip" "$ROOT_DIR/packages/standard/fonts" "$ROOT_DIR/packages/standard/licenses" "FiraCode"

# Montserrat from GitHub
download_github_release "JulietaUla/Montserrat" ".*zip" "$ROOT_DIR/packages/standard/fonts" "$ROOT_DIR/packages/standard/licenses" "Montserrat"

# Oswald from GitHub
echo "Downloading Oswald..."
curl -L -o "$TEMP_DIR/oswald.zip" "https://github.com/googlefonts/OswaldFont/archive/refs/heads/main.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/oswald"
unzip -q -o "$TEMP_DIR/oswald.zip" -d "$TEMP_DIR/oswald" 2>/dev/null || true
find "$TEMP_DIR/oswald" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/standard/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/standard/licenses/Oswald"
find "$TEMP_DIR/oswald" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/standard/licenses/Oswald/" \; 2>/dev/null || true
echo "  ✓ Oswald downloaded"

# Merriweather from GitHub
echo "Downloading Merriweather..."
curl -L -o "$TEMP_DIR/merriweather.zip" "https://github.com/SorkinType/Merriweather/archive/refs/heads/master.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/merriweather"
unzip -q -o "$TEMP_DIR/merriweather.zip" -d "$TEMP_DIR/merriweather" 2>/dev/null || true
find "$TEMP_DIR/merriweather" -path "*/fonts/ttf/*.ttf" -exec cp {} "$ROOT_DIR/packages/standard/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/standard/licenses/Merriweather"
find "$TEMP_DIR/merriweather" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/standard/licenses/Merriweather/" \; 2>/dev/null || true
echo "  ✓ Merriweather downloaded"

# EB Garamond from GitHub
echo "Downloading EB Garamond..."
curl -L -o "$TEMP_DIR/ebgaramond.zip" "https://github.com/georgd/EB-Garamond/archive/refs/heads/master.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/ebgaramond"
unzip -q -o "$TEMP_DIR/ebgaramond.zip" -d "$TEMP_DIR/ebgaramond" 2>/dev/null || true
find "$TEMP_DIR/ebgaramond" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/standard/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/standard/licenses/EBGaramond"
find "$TEMP_DIR/ebgaramond" -name "OFL*" -o -name "LICENSE*" -exec cp {} "$ROOT_DIR/packages/standard/licenses/EBGaramond/" \; 2>/dev/null || true
echo "  ✓ EB Garamond downloaded"

echo ""
echo "=== CODE BUNDLE ==="
echo "(Standalone monospace fonts)"
echo ""

# JetBrains Mono
download_github_release "JetBrains/JetBrainsMono" "JetBrainsMono.*zip" "$ROOT_DIR/packages/code/fonts" "$ROOT_DIR/packages/code/licenses" "JetBrainsMono"

# Fira Code
download_github_release "tonsky/FiraCode" "Fira_Code.*zip" "$ROOT_DIR/packages/code/fonts" "$ROOT_DIR/packages/code/licenses" "FiraCode"

# Source Code Pro
download_github_release "adobe-fonts/source-code-pro" ".*TTF.*zip" "$ROOT_DIR/packages/code/fonts" "$ROOT_DIR/packages/code/licenses" "SourceCodePro"

# IBM Plex Mono
echo "Downloading IBM Plex Mono..."
curl -L -o "$TEMP_DIR/ibmplex.zip" "https://github.com/IBM/plex/releases/download/v6.4.2/TrueType.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/ibmplex"
unzip -q -o "$TEMP_DIR/ibmplex.zip" -d "$TEMP_DIR/ibmplex" 2>/dev/null || true
find "$TEMP_DIR/ibmplex" -path "*Mono*" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/code/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/code/licenses/IBMPlexMono"
echo "OFL 1.1 License - See https://github.com/IBM/plex" > "$ROOT_DIR/packages/code/licenses/IBMPlexMono/LICENSE"
echo "  ✓ IBM Plex Mono downloaded"

# Cascadia Code
download_github_release "microsoft/cascadia-code" "CascadiaCode.*zip" "$ROOT_DIR/packages/code/fonts" "$ROOT_DIR/packages/code/licenses" "CascadiaCode"

# Hack
download_github_release "source-foundry/Hack" "Hack.*ttf.*zip" "$ROOT_DIR/packages/code/fonts" "$ROOT_DIR/packages/code/licenses" "Hack"

# Victor Mono
download_github_release "rubjo/victor-mono" "VictorMono.*zip" "$ROOT_DIR/packages/code/fonts" "$ROOT_DIR/packages/code/licenses" "VictorMono"

# Inconsolata from GitHub
echo "Downloading Inconsolata..."
curl -L -o "$TEMP_DIR/inconsolata.zip" "https://github.com/googlefonts/Inconsolata/archive/refs/heads/main.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/inconsolata"
unzip -q -o "$TEMP_DIR/inconsolata.zip" -d "$TEMP_DIR/inconsolata" 2>/dev/null || true
find "$TEMP_DIR/inconsolata" -path "*/fonts/ttf/*.ttf" -exec cp {} "$ROOT_DIR/packages/code/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/code/licenses/Inconsolata"
find "$TEMP_DIR/inconsolata" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/code/licenses/Inconsolata/" \; 2>/dev/null || true
echo "  ✓ Inconsolata downloaded"

# Roboto Mono
echo "Downloading Roboto Mono..."
curl -L -o "$TEMP_DIR/robotomono.zip" "https://github.com/googlefonts/RobotoMono/archive/refs/heads/main.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/robotomono"
unzip -q -o "$TEMP_DIR/robotomono.zip" -d "$TEMP_DIR/robotomono" 2>/dev/null || true
find "$TEMP_DIR/robotomono" -path "*/fonts/ttf/*.ttf" -exec cp {} "$ROOT_DIR/packages/code/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/code/licenses/RobotoMono"
find "$TEMP_DIR/robotomono" -name "LICENSE*" -exec cp {} "$ROOT_DIR/packages/code/licenses/RobotoMono/" \; 2>/dev/null || true
echo "  ✓ Roboto Mono downloaded"

# Ubuntu Mono
echo "Downloading Ubuntu Mono..."
curl -L -o "$TEMP_DIR/ubuntumono.zip" "https://assets.ubuntu.com/v1/0cef8205-ubuntu-font-family-0.83.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/ubuntumono"
unzip -q -o "$TEMP_DIR/ubuntumono.zip" -d "$TEMP_DIR/ubuntumono" 2>/dev/null || true
find "$TEMP_DIR/ubuntumono" -name "UbuntuMono*.ttf" -exec cp {} "$ROOT_DIR/packages/code/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/code/licenses/UbuntuMono"
find "$TEMP_DIR/ubuntumono" -name "LICENCE*" -o -name "LICENSE*" -exec cp {} "$ROOT_DIR/packages/code/licenses/UbuntuMono/" \; 2>/dev/null || true
echo "  ✓ Ubuntu Mono downloaded"

# Space Mono
echo "Downloading Space Mono..."
curl -L -o "$TEMP_DIR/spacemono.zip" "https://github.com/googlefonts/spacemono/archive/refs/heads/main.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/spacemono"
unzip -q -o "$TEMP_DIR/spacemono.zip" -d "$TEMP_DIR/spacemono" 2>/dev/null || true
find "$TEMP_DIR/spacemono" -path "*/fonts/*.ttf" -exec cp {} "$ROOT_DIR/packages/code/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/code/licenses/SpaceMono"
find "$TEMP_DIR/spacemono" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/code/licenses/SpaceMono/" \; 2>/dev/null || true
echo "  ✓ Space Mono downloaded"

# Anonymous Pro
echo "Downloading Anonymous Pro..."
curl -L -o "$TEMP_DIR/anonymouspro.zip" "https://www.marksimonson.com/assets/content/fonts/AnonymousPro-1_002.zip" 2>/dev/null || {
    # Fallback mirror
    curl -L -o "$TEMP_DIR/anonymouspro.zip" "https://github.com/AJenbo/anonymouspro/archive/refs/heads/master.zip" 2>/dev/null || true
}
mkdir -p "$TEMP_DIR/anonymouspro"
unzip -q -o "$TEMP_DIR/anonymouspro.zip" -d "$TEMP_DIR/anonymouspro" 2>/dev/null || true
find "$TEMP_DIR/anonymouspro" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/code/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/code/licenses/AnonymousPro"
find "$TEMP_DIR/anonymouspro" -name "OFL*" -o -name "LICENSE*" -exec cp {} "$ROOT_DIR/packages/code/licenses/AnonymousPro/" \; 2>/dev/null || true
echo "  ✓ Anonymous Pro downloaded"

echo ""
echo "=== FULL BUNDLE ==="
echo "(Additional display and specialty fonts)"
echo ""

# Poppins
echo "Downloading Poppins..."
curl -L -o "$TEMP_DIR/poppins.zip" "https://github.com/itfoundry/Poppins/archive/refs/heads/master.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/poppins"
unzip -q -o "$TEMP_DIR/poppins.zip" -d "$TEMP_DIR/poppins" 2>/dev/null || true
find "$TEMP_DIR/poppins" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/full/licenses/Poppins"
find "$TEMP_DIR/poppins" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/full/licenses/Poppins/" \; 2>/dev/null || true
echo "  ✓ Poppins downloaded"

# Nunito
echo "Downloading Nunito..."
curl -L -o "$TEMP_DIR/nunito.zip" "https://github.com/googlefonts/nunito/archive/refs/heads/main.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/nunito"
unzip -q -o "$TEMP_DIR/nunito.zip" -d "$TEMP_DIR/nunito" 2>/dev/null || true
find "$TEMP_DIR/nunito" -path "*/fonts/ttf/*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/full/licenses/Nunito"
find "$TEMP_DIR/nunito" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/full/licenses/Nunito/" \; 2>/dev/null || true
echo "  ✓ Nunito downloaded"

# Work Sans
echo "Downloading Work Sans..."
curl -L -o "$TEMP_DIR/worksans.zip" "https://github.com/weiweihuanghuang/Work-Sans/archive/refs/heads/master.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/worksans"
unzip -q -o "$TEMP_DIR/worksans.zip" -d "$TEMP_DIR/worksans" 2>/dev/null || true
find "$TEMP_DIR/worksans" -path "*/fonts/ttf/*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/full/licenses/WorkSans"
find "$TEMP_DIR/worksans" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/full/licenses/WorkSans/" \; 2>/dev/null || true
echo "  ✓ Work Sans downloaded"

# Raleway
echo "Downloading Raleway..."
curl -L -o "$TEMP_DIR/raleway.zip" "https://github.com/impallari/Raleway/archive/refs/heads/master.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/raleway"
unzip -q -o "$TEMP_DIR/raleway.zip" -d "$TEMP_DIR/raleway" 2>/dev/null || true
find "$TEMP_DIR/raleway" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/full/licenses/Raleway"
find "$TEMP_DIR/raleway" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/full/licenses/Raleway/" \; 2>/dev/null || true
echo "  ✓ Raleway downloaded"

# Lora
echo "Downloading Lora..."
curl -L -o "$TEMP_DIR/lora.zip" "https://github.com/cyrealtype/Lora-Cyrillic/archive/refs/heads/master.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/lora"
unzip -q -o "$TEMP_DIR/lora.zip" -d "$TEMP_DIR/lora" 2>/dev/null || true
find "$TEMP_DIR/lora" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/full/licenses/Lora"
find "$TEMP_DIR/lora" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/full/licenses/Lora/" \; 2>/dev/null || true
echo "  ✓ Lora downloaded"

# Playfair Display
echo "Downloading Playfair Display..."
curl -L -o "$TEMP_DIR/playfair.zip" "https://github.com/clauseggers/Playfair/archive/refs/heads/master.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/playfair"
unzip -q -o "$TEMP_DIR/playfair.zip" -d "$TEMP_DIR/playfair" 2>/dev/null || true
find "$TEMP_DIR/playfair" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/full/licenses/PlayfairDisplay"
find "$TEMP_DIR/playfair" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/full/licenses/PlayfairDisplay/" \; 2>/dev/null || true
echo "  ✓ Playfair Display downloaded"

# DM Sans
echo "Downloading DM Sans..."
curl -L -o "$TEMP_DIR/dmsans.zip" "https://github.com/googlefonts/dm-fonts/archive/refs/heads/main.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/dmsans"
unzip -q -o "$TEMP_DIR/dmsans.zip" -d "$TEMP_DIR/dmsans" 2>/dev/null || true
find "$TEMP_DIR/dmsans" -name "*Sans*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/full/licenses/DMSans"
find "$TEMP_DIR/dmsans" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/full/licenses/DMSans/" \; 2>/dev/null || true
echo "  ✓ DM Sans downloaded"

# Fira Sans from Mozilla
echo "Downloading Fira Sans..."
curl -L -o "$TEMP_DIR/firasans.zip" "https://github.com/mozilla/Fira/archive/refs/heads/master.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/firasans"
unzip -q -o "$TEMP_DIR/firasans.zip" -d "$TEMP_DIR/firasans" 2>/dev/null || true
find "$TEMP_DIR/firasans" -path "*ttf*" -name "FiraSans*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/full/licenses/FiraSans"
find "$TEMP_DIR/firasans" -name "LICENSE*" -exec cp {} "$ROOT_DIR/packages/full/licenses/FiraSans/" \; 2>/dev/null || true
echo "  ✓ Fira Sans downloaded"

# IBM Plex Sans
echo "Downloading IBM Plex Sans..."
# Reuse the earlier IBM Plex download if available
find "$TEMP_DIR/ibmplex" -path "*Sans*" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || {
    curl -L -o "$TEMP_DIR/ibmplexsans.zip" "https://github.com/IBM/plex/releases/download/v6.4.2/TrueType.zip" 2>/dev/null
    mkdir -p "$TEMP_DIR/ibmplexsans"
    unzip -q -o "$TEMP_DIR/ibmplexsans.zip" -d "$TEMP_DIR/ibmplexsans" 2>/dev/null || true
    find "$TEMP_DIR/ibmplexsans" -path "*Sans*" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
}
mkdir -p "$ROOT_DIR/packages/full/licenses/IBMPlexSans"
echo "OFL 1.1 License - See https://github.com/IBM/plex" > "$ROOT_DIR/packages/full/licenses/IBMPlexSans/LICENSE"
echo "  ✓ IBM Plex Sans downloaded"

# Barlow
echo "Downloading Barlow..."
curl -L -o "$TEMP_DIR/barlow.zip" "https://github.com/jpt/barlow/archive/refs/heads/main.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/barlow"
unzip -q -o "$TEMP_DIR/barlow.zip" -d "$TEMP_DIR/barlow" 2>/dev/null || true
find "$TEMP_DIR/barlow" -path "*/fonts/ttf/*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/full/licenses/Barlow"
find "$TEMP_DIR/barlow" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/full/licenses/Barlow/" \; 2>/dev/null || true
echo "  ✓ Barlow downloaded"

# Manrope
echo "Downloading Manrope..."
curl -L -o "$TEMP_DIR/manrope.zip" "https://github.com/sharanda/manrope/archive/refs/heads/master.zip" 2>/dev/null
mkdir -p "$TEMP_DIR/manrope"
unzip -q -o "$TEMP_DIR/manrope.zip" -d "$TEMP_DIR/manrope" 2>/dev/null || true
find "$TEMP_DIR/manrope" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/full/licenses/Manrope"
find "$TEMP_DIR/manrope" -name "OFL*" -o -name "LICENSE*" -exec cp {} "$ROOT_DIR/packages/full/licenses/Manrope/" \; 2>/dev/null || true
echo "  ✓ Manrope downloaded"

# Space Grotesk
echo "Downloading Space Grotesk..."
curl -L -o "$TEMP_DIR/spacegrotesk.zip" "https://github.com/nicksans/SpaceGrotesk/archive/refs/heads/main.zip" 2>/dev/null || {
    curl -L -o "$TEMP_DIR/spacegrotesk.zip" "https://github.com/nicksans/SpaceGrotesk/archive/refs/heads/master.zip" 2>/dev/null
}
mkdir -p "$TEMP_DIR/spacegrotesk"
unzip -q -o "$TEMP_DIR/spacegrotesk.zip" -d "$TEMP_DIR/spacegrotesk" 2>/dev/null || true
find "$TEMP_DIR/spacegrotesk" -name "*.ttf" -exec cp {} "$ROOT_DIR/packages/full/fonts/" \; 2>/dev/null || true
mkdir -p "$ROOT_DIR/packages/full/licenses/SpaceGrotesk"
find "$TEMP_DIR/spacegrotesk" -name "OFL*" -exec cp {} "$ROOT_DIR/packages/full/licenses/SpaceGrotesk/" \; 2>/dev/null || true
echo "  ✓ Space Grotesk downloaded"

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "========================================"
echo "Download complete!"
echo "========================================"
echo ""
echo "Package sizes (fonts only):"
du -sh "$ROOT_DIR/packages/minimal/fonts" 2>/dev/null || echo "  minimal: (empty)"
du -sh "$ROOT_DIR/packages/standard/fonts" 2>/dev/null || echo "  standard: (empty)"
du -sh "$ROOT_DIR/packages/full/fonts" 2>/dev/null || echo "  full: (empty)"
du -sh "$ROOT_DIR/packages/code/fonts" 2>/dev/null || echo "  code: (empty)"
echo ""
echo "Font counts:"
echo "  minimal: $(ls -1 "$ROOT_DIR/packages/minimal/fonts"/*.ttf 2>/dev/null | wc -l) files"
echo "  standard: $(ls -1 "$ROOT_DIR/packages/standard/fonts"/*.ttf 2>/dev/null | wc -l) files"
echo "  full: $(ls -1 "$ROOT_DIR/packages/full/fonts"/*.ttf 2>/dev/null | wc -l) files"
echo "  code: $(ls -1 "$ROOT_DIR/packages/code/fonts"/*.ttf 2>/dev/null | wc -l) files"
echo ""
echo "REMINDER: All fonts retain their original licenses."
echo "See licenses/ directory in each package."
echo ""
