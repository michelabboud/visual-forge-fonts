# Visual Forge Fonts - Complete Font List

All fonts are distributed under open-source licenses (OFL, Apache 2.0, or similar).
See individual `licenses/` directories for full license text.

## Package Summary

| Package | Families | Files | Size | Use Case |
|---------|----------|-------|------|----------|
| **minimal** | 5 | 84 | ~5 MB | Basic PDF generation |
| **standard** | 10 | 216 | ~63 MB | Document production |
| **full** | 24 | 440 | ~151 MB | Design & marketing |
| **code** | 12 | 247 | ~63 MB | Programming & terminals |

---

## Minimal Package

Essential fonts for basic PDF generation. Microsoft Office compatible.

| Font | Type | License | Creator |
|------|------|---------|---------|
| Liberation Serif | Serif | OFL | Red Hat |
| Liberation Sans | Sans-serif | OFL | Red Hat |
| Liberation Mono | Monospace | OFL | Red Hat |
| Inter | Sans-serif | OFL | Rasmus Andersson |
| JetBrains Mono | Monospace | OFL | JetBrains |

---

## Standard Package

Extends minimal with professional document fonts.

| Font | Type | License | Creator |
|------|------|---------|---------|
| EB Garamond | Serif | OFL | Georg Mayr-Duffner |
| Merriweather | Serif | OFL | Sorkin Type |
| Lato | Sans-serif | OFL | Lukasz Dziedzic |
| Montserrat | Sans-serif | OFL | Julieta Ulanovsky |
| Open Sans | Sans-serif | OFL | Steve Matteson |
| Oswald | Sans-serif | OFL | Vernon Adams |
| Roboto | Sans-serif | Apache 2.0 | Google |
| Roboto Condensed | Sans-serif | Apache 2.0 | Google |
| Source Sans 3 | Sans-serif | OFL | Adobe |
| Source Serif 4 | Serif | OFL | Adobe |
| Source Code Pro | Monospace | OFL | Adobe |

---

## Full Package

Extends standard with display and specialty fonts.

### Serif Fonts
| Font | License | Creator |
|------|---------|---------|
| Libre Baskerville | OFL | Impallari Type |
| Crimson Pro | OFL | Jacques Le Bailly |
| Lora | OFL | Cyreal |
| Playfair Display | OFL | Claus Eggers Sorensen |
| Cormorant | OFL | Christian Thalmann |
| Spectral | OFL | Production Type |
| Noto Serif | OFL | Google |

### Sans-serif Fonts
| Font | License | Creator |
|------|---------|---------|
| Nunito | OFL | Vernon Adams |
| Work Sans | OFL | Wei Huang |
| Poppins | OFL | Indian Type Foundry |
| IBM Plex Sans | OFL | IBM |
| Fira Sans | OFL | Mozilla |
| Barlow | OFL | Jeremy Tribby |
| Outfit | OFL | Rodrigo Fuenzalida |
| Manrope | OFL | Mikhail Sharanda |
| Noto Sans | OFL | Google |

### Display Fonts
| Font | License | Creator |
|------|---------|---------|
| Raleway | OFL | Matt McInerney |
| Bebas Neue | OFL | Ryoichi Tsunekawa |
| Anton | OFL | Vernon Adams |
| Archivo | OFL | Omnibus-Type |
| DM Sans | OFL | Colophon Foundry |
| Space Grotesk | OFL | Florian Karsten |
| Sora | OFL | Jonathan Barnbrook |
| Lexend | OFL | Bonnie Shaver-Troup |

---

## Code Package

Standalone package with programming and terminal fonts.

| Font | License | Creator | Notable Features |
|------|---------|---------|------------------|
| JetBrains Mono | OFL | JetBrains | Ligatures, tall x-height |
| Fira Code | OFL | Nikita Prokopov | Programming ligatures |
| Source Code Pro | OFL | Adobe | Clarity at small sizes |
| Cascadia Code | OFL | Microsoft | Windows Terminal default |
| Cascadia Mono | OFL | Microsoft | No ligatures variant |
| IBM Plex Mono | OFL | IBM | Corporate, readable |
| Hack | MIT | Chris Simpkins | Optimized for screens |
| Inconsolata | OFL | Raph Levien | Classic monospace |
| Anonymous Pro | OFL | Mark Simonson | Highly legible |
| Roboto Mono | Apache 2.0 | Google | Android default |
| Space Mono | OFL | Colophon Foundry | Geometric, retro |
| Ubuntu Mono | Ubuntu Font License | Dalton Maag | Ubuntu default |
| Victor Mono | OFL | Rune Bjornerås | Cursive italics |

---

## Font Format

All fonts are distributed as **TTF (TrueType)** for maximum compatibility with:
- Typst PDF engine
- XeLaTeX PDF engine
- System font rendering

For web use, convert to WOFF2 using Visual Forge MCP's built-in converter:
```typescript
import { fontManager } from '@michelabboud/visual-forge-mcp';
await fontManager.convertFontsToWoff2('./web-fonts/');
```

---

## Package Dependencies

```
minimal (standalone base)
    ↑
standard (includes minimal)
    ↑
full (includes standard)

code (standalone - no dependencies)
```

---

## License Information

All fonts in this collection are under open-source licenses:

- **OFL (SIL Open Font License)**: Freely usable, modifiable, redistributable
- **Apache 2.0**: Similar to OFL, requires license notice
- **MIT**: Permissive, minimal restrictions
- **Ubuntu Font License**: Freely usable with attribution

See `packages/*/licenses/` for individual font licenses.

**Disclaimer**: We do not own these fonts. This package is a convenience wrapper
for freely-licensed fonts. All credit goes to the original creators.
