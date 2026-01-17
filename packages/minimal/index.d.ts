/**
 * Visual Forge Fonts - Minimal Bundle
 *
 * DISCLAIMER: We do not own these fonts. This package is a convenience
 * wrapper for freely-licensed fonts. All credit goes to the original creators.
 */

export interface FontInfo {
  name: string;
  type: 'serif' | 'sans-serif' | 'monospace' | 'display';
  license: string;
  creator: string;
  files: string[];
}

export interface BundleInfo {
  bundle: string;
  version: string;
  path: string;
  families: string[];
  fonts: FontInfo[];
}

/**
 * Get the absolute path to the fonts directory
 */
export function getFontsPath(): string;

/**
 * Get list of available font families
 */
export function getFontFamilies(): string[];

/**
 * Get font metadata
 */
export function getFontInfo(): BundleInfo;

/**
 * Check if fonts are properly installed
 */
export function isInstalled(): boolean;

/**
 * Absolute path to fonts directory
 */
export const fontsPath: string;

/**
 * Array of font family names
 */
export const families: string[];
