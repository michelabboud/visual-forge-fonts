/**
 * Visual Forge Fonts - Full Bundle
 *
 * DISCLAIMER: We do not own these fonts. This package is a convenience
 * wrapper for freely-licensed fonts. All credit goes to the original creators.
 *
 * This package depends on @michelabboud/visual-forge-fonts-standard
 * (which depends on minimal) and adds additional fonts. No fonts are duplicated.
 */

const path = require('path');
const fs = require('fs');

// Import standard bundle (which includes minimal)
let standardFonts;
try {
  standardFonts = require('@michelabboud/visual-forge-fonts-standard');
} catch (e) {
  standardFonts = null;
}

/**
 * Get the absolute path to this package's fonts directory
 * @returns {string} Absolute path to fonts
 */
function getOwnFontsPath() {
  return path.join(__dirname, 'fonts');
}

/**
 * Get all font paths (this package + all dependencies)
 * @returns {string[]} Array of font directory paths
 */
function getAllFontPaths() {
  const paths = [getOwnFontsPath()];
  if (standardFonts) {
    paths.push(...standardFonts.getAllFontPaths());
  }
  return paths;
}

/**
 * Get list of font families in THIS package only (not dependencies)
 * @returns {string[]} Array of font family names
 */
function getOwnFontFamilies() {
  return [
    // Additional serif fonts
    'Libre Baskerville',
    'Crimson Pro',
    'Lora',
    'Playfair Display',
    'Cormorant',
    'Spectral',
    'Noto Serif',
    // Additional sans-serif fonts
    'Nunito',
    'Work Sans',
    'Poppins',
    'IBM Plex Sans',
    'Fira Sans',
    'Barlow',
    'Outfit',
    'Manrope',
    'Noto Sans',
    // Display fonts
    'Raleway',
    'Bebas Neue',
    'Anton',
    'Archivo',
    'DM Sans',
    'Space Grotesk',
    'Sora',
    'Lexend'
  ];
}

/**
 * Get ALL font families (this package + all dependencies)
 * @returns {string[]} Array of all font family names
 */
function getAllFontFamilies() {
  const families = [...getOwnFontFamilies()];
  if (standardFonts) {
    families.push(...standardFonts.getAllFontFamilies());
  }
  return families;
}

/**
 * Get font metadata
 * @returns {object} Font information
 */
function getFontInfo() {
  return {
    bundle: 'full',
    version: '1.0.0',
    ownPath: getOwnFontsPath(),
    allPaths: getAllFontPaths(),
    ownFamilies: getOwnFontFamilies(),
    allFamilies: getAllFontFamilies(),
    dependsOn: ['@michelabboud/visual-forge-fonts-standard'],
    fonts: [
      // Serif
      { name: 'Libre Baskerville', type: 'serif', license: 'OFL', creator: 'Impallari Type' },
      { name: 'Crimson Pro', type: 'serif', license: 'OFL', creator: 'Jacques Le Bailly' },
      { name: 'Lora', type: 'serif', license: 'OFL', creator: 'Cyreal' },
      { name: 'Playfair Display', type: 'serif', license: 'OFL', creator: 'Claus Eggers Sørensen' },
      { name: 'Cormorant', type: 'serif', license: 'OFL', creator: 'Christian Thalmann' },
      { name: 'Spectral', type: 'serif', license: 'OFL', creator: 'Production Type' },
      { name: 'Noto Serif', type: 'serif', license: 'OFL', creator: 'Google' },
      // Sans-serif
      { name: 'Nunito', type: 'sans-serif', license: 'OFL', creator: 'Vernon Adams' },
      { name: 'Work Sans', type: 'sans-serif', license: 'OFL', creator: 'Wei Huang' },
      { name: 'Poppins', type: 'sans-serif', license: 'OFL', creator: 'Indian Type Foundry' },
      { name: 'IBM Plex Sans', type: 'sans-serif', license: 'OFL', creator: 'IBM Corp.' },
      { name: 'Fira Sans', type: 'sans-serif', license: 'OFL', creator: 'Mozilla' },
      { name: 'Barlow', type: 'sans-serif', license: 'OFL', creator: 'Jeremy Tribby' },
      { name: 'Outfit', type: 'sans-serif', license: 'OFL', creator: 'Rodrigo Fuenzalida' },
      { name: 'Manrope', type: 'sans-serif', license: 'OFL', creator: 'Mikhail Sharanda' },
      { name: 'Noto Sans', type: 'sans-serif', license: 'OFL', creator: 'Google' },
      // Display
      { name: 'Raleway', type: 'display', license: 'OFL', creator: 'Matt McInerney' },
      { name: 'Bebas Neue', type: 'display', license: 'OFL', creator: 'Ryoichi Tsunekawa' },
      { name: 'Anton', type: 'display', license: 'OFL', creator: 'Vernon Adams' },
      { name: 'Archivo', type: 'display', license: 'OFL', creator: 'Omnibus-Type' },
      { name: 'DM Sans', type: 'display', license: 'OFL', creator: 'Colophon Foundry' },
      { name: 'Space Grotesk', type: 'display', license: 'OFL', creator: 'Florian Karsten' },
      { name: 'Sora', type: 'display', license: 'OFL', creator: 'Jonathan Barnbrook' },
      { name: 'Lexend', type: 'display', license: 'OFL', creator: 'Bonnie Shaver-Troup' }
    ]
  };
}

/**
 * Check if fonts are properly installed
 * @returns {boolean} True if fonts directory exists and has files
 */
function isInstalled() {
  const fontsPath = getOwnFontsPath();
  try {
    const files = fs.readdirSync(fontsPath);
    return files.some(f => f.endsWith('.ttf') || f.endsWith('.otf'));
  } catch {
    return false;
  }
}

module.exports = {
  getOwnFontsPath,
  getAllFontPaths,
  getOwnFontFamilies,
  getAllFontFamilies,
  getFontInfo,
  isInstalled,
  // Convenience exports
  fontsPath: getOwnFontsPath(),
  allPaths: getAllFontPaths(),
  families: getAllFontFamilies()
};
