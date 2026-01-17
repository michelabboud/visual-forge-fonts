/**
 * Visual Forge Fonts - Code Bundle
 *
 * DISCLAIMER: We do not own these fonts. This package is a convenience
 * wrapper for freely-licensed fonts. All credit goes to the original creators.
 *
 * This is a STANDALONE package with monospace/programming fonts only.
 * It does not depend on other font packages.
 */

const path = require('path');
const fs = require('fs');

/**
 * Get the absolute path to the fonts directory
 * @returns {string} Absolute path to fonts
 */
function getFontsPath() {
  return path.join(__dirname, 'fonts');
}

/**
 * Get list of available font families
 * @returns {string[]} Array of font family names
 */
function getFontFamilies() {
  return [
    'JetBrains Mono',
    'Fira Code',
    'Source Code Pro',
    'IBM Plex Mono',
    'Cascadia Code',
    'Hack',
    'Inconsolata',
    'Roboto Mono',
    'Ubuntu Mono',
    'Victor Mono',
    'Anonymous Pro',
    'Space Mono'
  ];
}

/**
 * Get font metadata
 * @returns {object} Font information
 */
function getFontInfo() {
  return {
    bundle: 'code',
    version: '1.0.0',
    path: getFontsPath(),
    families: getFontFamilies(),
    standalone: true,
    fonts: [
      { name: 'JetBrains Mono', license: 'OFL', creator: 'JetBrains s.r.o.', features: ['ligatures'] },
      { name: 'Fira Code', license: 'OFL', creator: 'Nikita Prokopov', features: ['ligatures'] },
      { name: 'Source Code Pro', license: 'OFL', creator: 'Adobe Inc.', features: [] },
      { name: 'IBM Plex Mono', license: 'OFL', creator: 'IBM Corp.', features: [] },
      { name: 'Cascadia Code', license: 'OFL', creator: 'Microsoft', features: ['ligatures'] },
      { name: 'Hack', license: 'MIT', creator: 'Source Foundry', features: [] },
      { name: 'Inconsolata', license: 'OFL', creator: 'Raph Levien', features: [] },
      { name: 'Roboto Mono', license: 'Apache 2.0', creator: 'Google', features: [] },
      { name: 'Ubuntu Mono', license: 'UFL', creator: 'Canonical Ltd.', features: [] },
      { name: 'Victor Mono', license: 'OFL', creator: 'Rune Bjørnerås', features: ['cursive-italics', 'ligatures'] },
      { name: 'Anonymous Pro', license: 'OFL', creator: 'Mark Simonson', features: [] },
      { name: 'Space Mono', license: 'OFL', creator: 'Colophon Foundry', features: [] }
    ]
  };
}

/**
 * Check if fonts are properly installed
 * @returns {boolean} True if fonts directory exists and has files
 */
function isInstalled() {
  const fontsPath = getFontsPath();
  try {
    const files = fs.readdirSync(fontsPath);
    return files.some(f => f.endsWith('.ttf') || f.endsWith('.otf'));
  } catch {
    return false;
  }
}

module.exports = {
  getFontsPath,
  getFontFamilies,
  getFontInfo,
  isInstalled,
  // Convenience exports
  fontsPath: getFontsPath(),
  families: getFontFamilies()
};
