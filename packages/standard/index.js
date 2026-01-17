/**
 * Visual Forge Fonts - Standard Bundle
 *
 * DISCLAIMER: We do not own these fonts. This package is a convenience
 * wrapper for freely-licensed fonts. All credit goes to the original creators.
 *
 * This package depends on @michelabboud/visual-forge-fonts-minimal
 * and adds additional fonts. No fonts are duplicated.
 */

const path = require('path');
const fs = require('fs');

// Import minimal bundle
let minimalFonts;
try {
  minimalFonts = require('@michelabboud/visual-forge-fonts-minimal');
} catch (e) {
  minimalFonts = null;
}

/**
 * Get the absolute path to this package's fonts directory
 * @returns {string} Absolute path to fonts
 */
function getOwnFontsPath() {
  return path.join(__dirname, 'fonts');
}

/**
 * Get all font paths (this package + dependencies)
 * @returns {string[]} Array of font directory paths
 */
function getAllFontPaths() {
  const paths = [getOwnFontsPath()];
  if (minimalFonts) {
    paths.push(minimalFonts.getFontsPath());
  }
  return paths;
}

/**
 * Get list of font families in THIS package only (not dependencies)
 * @returns {string[]} Array of font family names
 */
function getOwnFontFamilies() {
  return [
    'EB Garamond',
    'Merriweather',
    'Source Sans Pro',
    'Source Serif Pro',
    'Source Code Pro',
    'Roboto',
    'Open Sans',
    'Lato',
    'Fira Code',
    'Oswald',
    'Montserrat'
  ];
}

/**
 * Get ALL font families (this package + dependencies)
 * @returns {string[]} Array of all font family names
 */
function getAllFontFamilies() {
  const families = [...getOwnFontFamilies()];
  if (minimalFonts) {
    families.push(...minimalFonts.getFontFamilies());
  }
  return families;
}

/**
 * Get font metadata
 * @returns {object} Font information
 */
function getFontInfo() {
  return {
    bundle: 'standard',
    version: '1.0.0',
    ownPath: getOwnFontsPath(),
    allPaths: getAllFontPaths(),
    ownFamilies: getOwnFontFamilies(),
    allFamilies: getAllFontFamilies(),
    dependsOn: ['@michelabboud/visual-forge-fonts-minimal'],
    fonts: [
      { name: 'EB Garamond', type: 'serif', license: 'OFL', creator: 'Georg Duffner' },
      { name: 'Merriweather', type: 'serif', license: 'OFL', creator: 'Sorkin Type Co.' },
      { name: 'Source Sans Pro', type: 'sans-serif', license: 'OFL', creator: 'Adobe Inc.' },
      { name: 'Source Serif Pro', type: 'serif', license: 'OFL', creator: 'Adobe Inc.' },
      { name: 'Source Code Pro', type: 'monospace', license: 'OFL', creator: 'Adobe Inc.' },
      { name: 'Roboto', type: 'sans-serif', license: 'Apache 2.0', creator: 'Google' },
      { name: 'Open Sans', type: 'sans-serif', license: 'OFL', creator: 'Steve Matteson' },
      { name: 'Lato', type: 'sans-serif', license: 'OFL', creator: 'Łukasz Dziedzic' },
      { name: 'Fira Code', type: 'monospace', license: 'OFL', creator: 'Nikita Prokopov' },
      { name: 'Oswald', type: 'display', license: 'OFL', creator: 'Vernon Adams' },
      { name: 'Montserrat', type: 'sans-serif', license: 'OFL', creator: 'Julieta Ulanovsky' }
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
