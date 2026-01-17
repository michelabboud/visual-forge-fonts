#!/usr/bin/env node

/**
 * Visual Forge Fonts - Postinstall Script
 *
 * This script runs after npm install and provides helpful information
 * about using the fonts.
 */

const path = require('path');

const fontsPath = path.join(__dirname, 'fonts');

console.log('');
console.log('╔══════════════════════════════════════════════════════════════════╗');
console.log('║           Visual Forge Fonts (Minimal) Installed                 ║');
console.log('╚══════════════════════════════════════════════════════════════════╝');
console.log('');
console.log('Fonts included:');
console.log('  • Liberation Serif, Sans, Mono (MS Office compatible)');
console.log('  • Inter (Modern UI font)');
console.log('  • JetBrains Mono (Code font with ligatures)');
console.log('');
console.log('Font path:', fontsPath);
console.log('');
console.log('Usage with Visual Forge MCP:');
console.log('  The fonts are automatically detected by Visual Forge MCP.');
console.log('');
console.log('Usage with Typst directly:');
console.log('  export TYPST_FONT_PATHS="' + fontsPath + '"');
console.log('');
console.log('DISCLAIMER: We do not own these fonts. See DISCLAIMER.md and');
console.log('licenses/ directory for font licenses and attribution.');
console.log('');
