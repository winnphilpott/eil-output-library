# Infographic spec — "Three Paths Out of Coal" (EIL house style)

Build target: a `.tikz` recreation of `concept2_three_paths.pdf` / `.svg`, compiled inside the EIL
research-highlight LaTeX system (`formats/research-highlight/_style.tex` is already loaded, so its
colors, fonts, and macros are available — **use them; do not redefine**). Placement: top-right of
page 1 of *"Coal's Decline Cost Workers Nearly Two Years of Pay,"* the footprint the
"Two Approaches to Compliance" schematic holds in the sibling highlight. Conceptual figure; it sits
open on the page (no bounding box) and does not invert for dark mode.

The `.svg` is the authoritative geometry; the `.pdf` is the visual reference.

## Design system hooks (from _style.tex — reuse, don't redefine)

- **Colors:** `accentred` #641111 (title, path-box headers), `boxred` #8C2826 (the two filled anchor
  boxes), `boxtext` #EEF1EA (text on those boxes), `body` #33352C (path-box body text),
  `cite` #6E6D61 (italic result captions), `muted` #50534A (subtitle, arrows), `warmrule` #D8D2C2
  (divider + neutral box outlines), `paper` #FAF8F1 (neutral box fill).
- **Font:** Source Sans 3 (`sourcesanspro`, already the default family). Italics via `\itshape`.
  No serif anywhere.
- **Title** follows the `\figtitle` treatment: `\bfseries\color{accentred}` + `\textls[40]{\MakeUppercase{…}}`
  at figure-title size (~7.1pt in-doc), with the subtitle as a `muted` line beneath (italic optional).
- **Path-box headers** follow `\subhead`: `\bfseries\color{accentred}` + `\textls[50]{\MakeUppercase{…}}`.
- **Anchor boxes** are the `bottomline` box: `arc=4pt, boxrule=0pt, colback=boxred, coltext=boxtext`.
  In TikZ: `rounded corners=4pt, fill=boxred, text=boxtext, draw=none`.
- **Neutral path boxes:** `rounded corners=4pt, fill=paper, draw=warmrule, line width=0.7pt, text=body`.
- **Dividers/rules:** `warmrule`, 0.7pt.

## Canvas & coordinates

Artboard **560 × 372** units (SVG px; origin top-left, y down — negate y for TikZ). Positions are
node centers unless noted. Rounded corners 4–6 px. Arrows 1.3 px, `muted`, small stealth heads
(`-{Stealth[length=5pt,width=4pt]}`). Final print width ~2.4–2.6 in; scale uniformly.

| Element | Center (x, y) | Size (w × h) | Style |
|---|---|---|---|
| Title (left-aligned, baseline) | 24, 30 | — | figtitle, accentred |
| Subtitle (left-aligned) | 24, 48 | — | muted italic |
| Divider rule | — | 24→536 @ y=60 | warmrule 0.7pt |
| Top anchor box | 280, 99 | 512 × 46 | boxred / boxtext |
| Path box A "STAYED" | 104, 210 | 160 × 92 | paper / warmrule |
| Path box B "RELOCATED" | 280, 210 | 160 × 92 | paper / warmrule |
| Path box C "LEFT WORK" | 456, 210 | 160 × 92 | paper / warmrule |
| Bottom anchor box | 280, 328 | 512 × 52 | boxred / boxtext |

Inside path boxes: header baseline y=187, body lines y=209 / y=225, result caption y=245.
Top box lines y=98 / y=114. Bottom box lines y=327 (18px) / y=345 (11px).

## Arrows

- **Fan:** single origin (280, 124) → path-box tops (104, 158), (280, 158), (456, 158).
- **Converge:** path-box bottoms (104, 257), (280, 257), (456, 257) → bottom-box top (280, 300).

All `muted`. The fan-out-then-funnel-in is the point: three exits, one outcome. Preserve it.

## Verbatim text (LaTeX-escape `&`→`\&`, `$`→`\$`, `%`→`\%`; `--` en dash; ≈ via `\approx` or a text glyph)

- Title: `Three paths out of coal` (rendered uppercase by the macro)
- Subtitle: `Displaced coal workers adjusted in three ways.`
- Top box: `The most coal-dependent workers` / `lose their jobs as coal declines after 2011`
- A: header `Stayed` · body `Took work in other industries nearby` · caption `≈30\% lower pay`
- B: header `Relocated` · body `Moved to a different labor market` · caption `losses just as large`
- C: header `Left work` · body `Drew on SSDI and savings` · caption `most common path`
- Bottom box: `≈ 1.8 years of pay lost` / `≈ \$165,600 vs. similar workers, 2012--2019`

Path-box bodies wrap to two centered lines (`align=center`, `text width`).

## Notes

- **No outer panel or border** — the figure sits open on the page; the page background shows through.
- **No logo** (embedded figure — the masthead already brands the page). A `muted` source line at the
  foot is optional and usually omitted for a conceptual schematic (the compliance schematic carries none).
- **Editorial restraint (house data-viz principle):** the figure states the single finding
  (≈1.8 years) and frames the mechanism; the "why it never recovered" argument lives in the body prose,
  not the plot. Keep captions factual.
- Sanity check: small letter-spaced accentred title, twin boxred anchors top and bottom, muted
  fan-then-funnel, paper path boxes with accentred headers, ≈/\$/en-dash rendering, nothing overflowing.
