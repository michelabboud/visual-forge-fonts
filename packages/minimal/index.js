/**
 * Visual Forge Fonts - Minimal Bundle
 *
 * DISCLAIMER: We do not own these fonts. This package is a convenience
 * wrapper for freely-licensed fonts. All credit goes to the original creators.
 * See the licenses/ directory for individual font licenses.
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
    'Liberation Serif',
    'Liberation Sans',
    'Liberation Mono',
    'Inter',
    'JetBrains Mono'
  ];
}

/**
 * Get font metadata
 * @returns {object} Font information
 */
function getFontInfo() {
  return {
    bundle: 'minimal',
    version: '1.0.0',
    path: getFontsPath(),
    families: getFontFamilies(),
    fonts: [
      {
        name: 'Liberation Serif',
        type: 'serif',
        license: 'OFL',
        creator: 'Red Hat, Inc.',
        files: ['LiberationSerif-Regular.ttf', 'LiberationSerif-Bold.ttf', 'LiberationSerif-Italic.ttf', 'LiberationSerif-BoldItalic.ttf']
      },
      {
        name: 'Liberation Sans',
        type: 'sans-serif',
        license: 'OFL',
        creator: 'Red Hat, Inc.',
        files: ['LiberationSans-Regular.ttf', 'LiberationSans-Bold.ttf', 'LiberationSans-Italic.ttf', 'LiberationSans-BoldItalic.ttf']
      },
      {
        name: 'Liberation Mono',
        type: 'monospace',
        license: 'OFL',
        creator: 'Red Hat, Inc.',
        files: ['LiberationMono-Regular.ttf', 'LiberationMono-Bold.ttf', 'LiberationMono-Italic.ttf', 'LiberationMono-BoldItalic.ttf']
      },
      {
        name: 'Inter',
        type: 'sans-serif',
        license: 'OFL',
        creator: 'Rasmus Andersson',
        files: ['Inter-Regular.ttf', 'Inter-Bold.ttf', 'Inter-Italic.ttf', 'Inter-BoldItalic.ttf']
      },
      {
        name: 'JetBrains Mono',
        type: 'monospace',
        license: 'OFL',
        creator: 'JetBrains s.r.o.',
        files: ['JetBrainsMono-Regular.ttf', 'JetBrainsMono-Bold.ttf', 'JetBrainsMono-Italic.ttf', 'JetBrainsMono-BoldItalic.ttf']
      }
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
