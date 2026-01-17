# Visual Forge Fonts

> **Helper packages providing free, open-source fonts for Visual Forge MCP PDF generation**

## Important Disclaimer

**WE DO NOT OWN, CREATE, OR CLAIM ANY RIGHTS TO THESE FONTS.**

This is a convenience package that bundles freely-licensed fonts from their original creators for easy installation with Visual Forge MCP. All fonts are distributed under their original open-source licenses (OFL, Apache 2.0, MIT, UFL).

**All credit goes to the original font creators and foundries.**

## Available Packages

| Package | Size | Fonts | Use Case |
|---------|------|-------|----------|
| `@michelabboud/visual-forge-fonts-minimal` | ~10 MB | 5 families | Essential document fonts |
| `@michelabboud/visual-forge-fonts-standard` | ~25 MB | 20 families | Most common use cases |
| `@michelabboud/visual-forge-fonts-full` | ~60 MB | 50+ families | Complete collection |
| `@michelabboud/visual-forge-fonts-code` | ~12 MB | 12 families | Programming/monospace only |

## Installation

```bash
# Install the bundle you need
npm install @michelabboud/visual-forge-fonts-minimal

# Or for more fonts
npm install @michelabboud/visual-forge-fonts-standard

# Or everything
npm install @michelabboud/visual-forge-fonts-full

# Or just code fonts
npm install @michelabboud/visual-forge-fonts-code
```

## Usage with Visual Forge MCP

After installation, Visual Forge MCP will automatically detect the fonts:

```javascript
import { typstEngine } from '@michelabboud/visual-forge-mcp';

// Fonts are automatically available
await typstEngine.generatePDF({
  inputPath: 'document.md',
  outputPath: 'document.pdf',
  fonts: {
    mainFont: 'Inter',        // From fonts-standard
    monoFont: 'JetBrains Mono' // From fonts-minimal
  }
});
```

## Font Licenses

Each font package includes the original license files from the font creators. All fonts use one of these open-source licenses:

| License | Permits |
|---------|---------|
| **OFL (SIL Open Font License)** | Free use, modification, redistribution, embedding |
| **Apache 2.0** | Free use, modification, redistribution |
| **MIT** | Free use, modification, redistribution |
| **UFL (Ubuntu Font License)** | Free use, redistribution |

## Package Contents

### Minimal (~10 MB)

Essential fonts for professional documents:

| Font | Type | License | Creator |
|------|------|---------|---------|
| Liberation Serif | Serif | OFL | Red Hat |
| Liberation Sans | Sans | OFL | Red Hat |
| Liberation Mono | Mono | OFL | Red Hat |
| Inter | Sans | OFL | Rasmus Andersson |
| JetBrains Mono | Mono | OFL | JetBrains |

### Standard (~25 MB)

Everything in Minimal plus:

| Font | Type | License | Creator |
|------|------|---------|---------|
| EB Garamond | Serif | OFL | Georg Duffner |
| Merriweather | Serif | OFL | Sorkin Type |
| Source Sans Pro | Sans | OFL | Adobe |
| Source Serif Pro | Serif | OFL | Adobe |
| Source Code Pro | Mono | OFL | Adobe |
| Roboto | Sans | Apache 2.0 | Google |
| Open Sans | Sans | OFL | Steve Matteson |
| Lato | Sans | OFL | Łukasz Dziedzic |
| Fira Code | Mono | OFL | Mozilla/Nikita |
| Oswald | Display | OFL | Vernon Adams |
| Montserrat | Sans | OFL | Julieta Ulanovsky |

### Full (~60 MB)

Complete collection - see [FONTS.md](FONTS.md) for full list.

### Code (~12 MB)

All monospace/programming fonts:

| Font | License | Creator | Features |
|------|---------|---------|----------|
| JetBrains Mono | OFL | JetBrains | Ligatures |
| Fira Code | OFL | Mozilla/Nikita | Ligatures |
| Source Code Pro | OFL | Adobe | Clean |
| IBM Plex Mono | OFL | IBM | Technical |
| Cascadia Code | OFL | Microsoft | Ligatures |
| Hack | MIT | Source Foundry | Coding |
| Inconsolata | OFL | Raph Levien | Classic |
| Roboto Mono | Apache 2.0 | Google | Neutral |
| Ubuntu Mono | UFL | Canonical | Distinctive |
| Victor Mono | OFL | Rune Bjørnerås | Cursive italics |
| Anonymous Pro | OFL | Mark Simonson | Privacy |
| Space Mono | OFL | Google | Display |

## Font Sources

All fonts are downloaded from their official sources:

- [Google Fonts](https://fonts.google.com)
- [JetBrains](https://www.jetbrains.com/lp/mono/)
- [Adobe Fonts (GitHub)](https://github.com/adobe-fonts)
- [The League of Moveable Type](https://www.theleagueofmoveabletype.com/)
- [Mozilla (Fira)](https://github.com/mozilla/Fira)
- [IBM Plex](https://github.com/IBM/plex)
- [Cascadia Code](https://github.com/microsoft/cascadia-code)

## Credits & Attribution

This package is a **convenience wrapper only**. All fonts are created by their respective authors:

- **Liberation Fonts** - Red Hat, Inc.
- **Inter** - Rasmus Andersson
- **JetBrains Mono** - JetBrains s.r.o.
- **Roboto** - Google
- **Source Family** - Adobe Inc.
- **Fira Code** - Nikita Prokopov (based on Mozilla's Fira)
- **EB Garamond** - Georg Duffner
- **Merriweather** - Sorkin Type Co.
- **Open Sans** - Steve Matteson
- **Lato** - Łukasz Dziedzic
- **Oswald** - Vernon Adams
- **Montserrat** - Julieta Ulanovsky
- **IBM Plex** - IBM Corp.
- **Cascadia Code** - Microsoft Corporation
- **Hack** - Source Foundry
- ...and many more talented type designers

**Thank you to all font creators for making their work freely available!**

## License

The packaging code (scripts, configuration) is MIT licensed.

**The fonts themselves retain their original licenses** (OFL, Apache 2.0, MIT, UFL). See the `licenses/` directory in each package for individual font licenses.

## Issues

For issues with:
- **This packaging**: [visual-forge-fonts issues](https://github.com/michelabboud/visual-forge-fonts/issues)
- **Individual fonts**: Contact the original font creators

## Related

- [Visual Forge MCP](https://github.com/michelabboud/visual-forge-mcp) - AI image generation for documentation
- [Google Fonts](https://fonts.google.com) - Primary font source
- [SIL Open Font License](https://openfontlicense.org/) - Most common font license
