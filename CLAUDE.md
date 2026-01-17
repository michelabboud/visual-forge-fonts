# CLAUDE.md - Visual Forge Fonts

This file provides guidance to Claude Code when working with this repository.

## Project Overview

Visual Forge Fonts is a collection of npm packages that bundle open-source fonts for Visual Forge MCP PDF generation. The fonts are NOT owned by us - we only package them for convenience.

## Package Structure

```
packages/
├── minimal/     # Base fonts (Liberation, Inter, JetBrains Mono)
├── standard/    # Depends on minimal, adds document fonts
├── full/        # Depends on standard, adds display/specialty fonts
└── code/        # Standalone monospace/programming fonts
```

## Font Download Methods

### Primary Method: Fontsource CDN (Recommended)

The most reliable way to download fonts is via the Fontsource CDN (jsdelivr):

```bash
# Pattern:
curl -sf "https://cdn.jsdelivr.net/fontsource/fonts/{font-slug}@latest/latin-{weight}-{style}.ttf" -o "{FontName}-{weight}-{style}.ttf"

# Example - Download Inter Regular:
curl -sf "https://cdn.jsdelivr.net/fontsource/fonts/inter@latest/latin-400-normal.ttf" -o "Inter-Regular.ttf"

# Example - Download with multiple weights:
for weight in 400 500 600 700; do
    for style in normal italic; do
        curl -sf "https://cdn.jsdelivr.net/fontsource/fonts/roboto@latest/latin-${weight}-${style}.ttf" \
            -o "Roboto-${weight}-${style}.ttf"
    done
done
```

**Font slug format:** lowercase, hyphenated (e.g., `ibm-plex-mono`, `source-code-pro`, `eb-garamond`)

**Weight/Style mappings:**
- 400-normal → Regular
- 400-italic → Italic
- 500-normal → Medium
- 500-italic → MediumItalic
- 600-normal → SemiBold
- 600-italic → SemiBoldItalic
- 700-normal → Bold
- 700-italic → BoldItalic

### Secondary Method: GitHub Releases

For fonts with GitHub releases (JetBrains Mono, Fira Code, Cascadia Code, etc.):

```bash
# Get latest release URL
curl -s "https://api.github.com/repos/{owner}/{repo}/releases/latest" | grep "browser_download_url.*zip"

# Example - JetBrains Mono:
curl -L -o jetbrains.zip "https://github.com/JetBrains/JetBrainsMono/releases/latest/download/JetBrainsMono-2.304.zip"
unzip -q jetbrains.zip -d jetbrains
find jetbrains -name "*.ttf" -exec cp {} ./fonts/ \;
```

### Tertiary Method: GitHub Repository

For fonts without releases, download from the repository directly:

```bash
# Download repo as zip
curl -L -o font.zip "https://github.com/{owner}/{repo}/archive/refs/heads/main.zip"
unzip -q font.zip -d font
find font -path "*/fonts/ttf/*.ttf" -exec cp {} ./fonts/ \;
```

## Adding New Fonts

1. **Find the font slug** on [Fontsource](https://fontsource.org/)
2. **Determine available weights** (most have 400, 500, 600, 700)
3. **Check for italics** (display fonts often don't have italics)
4. **Download using the CDN pattern**
5. **Rename files** to standard naming (Regular, Bold, etc.)
6. **Create license file** in `licenses/{FontName}/LICENSE`
7. **Update `index.js`** to include the new font family

### Example: Adding a New Font

```bash
# 1. Download Quicksand (no italics)
FONT_DIR="packages/full/fonts"
for weight in 400 500 600 700; do
    curl -sf "https://cdn.jsdelivr.net/fontsource/fonts/quicksand@latest/latin-${weight}-normal.ttf" \
        -o "$FONT_DIR/Quicksand-${weight}-normal.ttf"
done

# 2. Rename to standard names
cd $FONT_DIR
mv Quicksand-400-normal.ttf Quicksand-Regular.ttf
mv Quicksand-500-normal.ttf Quicksand-Medium.ttf
mv Quicksand-600-normal.ttf Quicksand-SemiBold.ttf
mv Quicksand-700-normal.ttf Quicksand-Bold.ttf

# 3. Add license
mkdir -p packages/full/licenses/Quicksand
echo "SIL Open Font License 1.1" > packages/full/licenses/Quicksand/LICENSE

# 4. Update index.js - add to getOwnFontFamilies() and getFontInfo().fonts
```

## Scripts

```bash
# Download all fonts (initial setup)
./scripts/download-fonts.sh

# Fix missing fonts
./scripts/fix-missing-fonts.sh
```

## Common Issues

### Font Not Found on Fontsource

Some fonts have different slugs:
- "Source Sans Pro" → `source-sans-3` (version 3)
- "Source Serif Pro" → `source-serif-4` (version 4)
- "EB Garamond" → `eb-garamond`

### GitHub Release Not Found

Check if the repo uses:
- `main` vs `master` branch
- Releases without download assets (source only)
- Different asset naming patterns

### No Italic Variants

Many fonts don't have italic variants:
- Display fonts (Bebas Neue, Anton, Oswald)
- Variable fonts (use the variable axis instead)
- Some sans-serif fonts (Manrope, Lexend)

## Package Dependencies

```
minimal (base)
    ↑
standard (depends on minimal)
    ↑
full (depends on standard)

code (standalone - no dependencies)
```

## Publishing

```bash
# Bump version in package.json for each package
cd packages/standard
npm version patch

# Publish
npm publish --access public
```

## Font Format

All fonts are distributed as **TTF (TrueType)** for maximum compatibility with:
- Typst PDF engine
- XeLaTeX PDF engine
- System font rendering

WOFF2 conversion for HTML output is handled by Visual Forge MCP's font-manager (not this package).
