# Data Visualization Style Guide

Conventions for EIL **public-facing figures** — charts built for a policy or
general audience, whether embedded in a research highlight, press release, or
newsletter, or published as a standalone graphic. The goal is a figure a
non-specialist understands at a glance and a journalist can reprint without a
caption deck.

- **Canonical example:** `papers/2026-epa-compliance-workshops/figures/fig2-did.png`
  (built by `papers/2026-epa-compliance-workshops/code/make-fig2.R`)
- **Theme & palette:** `formats/data-viz/eil-theme.R` (`eil_pal`, `theme_eil()`, `eil_save()`)
- **Starter template:** `formats/data-viz/data-viz-template.R` (runnable, synthetic data)
- **Companion guides:** `style-guides/research-highlight/README.md`, `style-guides/press-release/README.md`

---

## 1. Principles

A house figure favors **comprehension over completeness**. Six moves, all visible
in the canonical example:

1. **Plain-language encodings.** Label axes with words, not coefficients or jargon
   — *"Fewer violations / No change / More violations"* on the y-axis, *"Workshop",
   "6 after"* on the x-axis. The reader should never have to decode a unit.
2. **Frame one idea.** Each figure makes a single point. Orient the reader with a
   shaded region for the period that matters, a dashed reference line at the
   intervention, and short caps labels (neutral in `muted`, the emphasized side in
   `accentred`).
3. **Show uncertainty softly.** One light ribbon, not a thicket of confidence
   whiskers. We don't want to lie by omission, but the range of uncertainty is typically
   not essential for general understandability. 
5. **Minimal chrome.** No gridlines, no y-axis ticks, no box. A single thin
   warm-grey x-axis line carries the scale.
6. **Clear Visibility.** Small dark points and a thin, semi-transparent
   connecting line. Data marks are the darkest thing on the canvas; we
   want stark contrast for easy reading.
8. **Interpretation lives in the document.** The figure shows; the surrounding
   prose (figure title, note, body) tells the reader what to conclude. Keep
   editorial claims out of the plot itself.

## 2. Palette

Locked to the print design system (`formats/research-highlight/_style.tex`) so a
figure blends into the page. Use `eil_pal` from `formats/data-viz/eil-theme.R`;
never hand-pick new hex values.

| Token       | Hex       | Use in a figure                                  |
|-------------|-----------|--------------------------------------------------|
| `ink`       | `#1D2620` | Data marks — points, lines; y-axis value labels  |
| `accentred` | `#641111` | The one emphasis color: reference line, the "after"/treated side |
| `muted`     | `#50534A` | Annotations, axis text, source line              |
| `cite`      | `#6E6D61` | Secondary annotation                             |
| `faint`     | `#9A978A` | Least-prominent text                             |
| `warmrule`  | `#D8D2C2` | Warm-grey dividers (matches print rules)         |
| `axis`      | `#C4BDAD` | Axis lines/ticks **and** soft uncertainty ribbons|
| `band`      | `#F3E4E2` | Fill for a highlighted region (pale red tint)    |
| `paper`     | `#FAF8F1` | Use as background only to blend into a warm page |
| `canvas`    | `#FFFFFF` | Default figure background                        |

**One emphasis color.** `accentred` marks the single thing the reader should look
at. Keep categorical encodings to grayscale (`ink` / `muted` / `faint`) plus that one red.

## 3. Typography & sizing

- **Sans family** (Source Sans 3) to match house print. In R, `theme_eil()` uses
  the system sans by default; pass `base_family = "Source Sans 3"` after
  registering the font (e.g. via `systemfonts`/`showtext`) to match exactly.
- **Caps + restraint for structural labels** — axis titles and orientation labels
  in uppercase (`"MONTHS RELATIVE TO TRAINING"`); sentence case for value labels.
- **`theme_eil(base_size = 7)`** is calibrated for a figure exported at ~5.4×3.1 in
  and placed at ~0.8 of a print column. This is subject to change depending on the needs
  of the document. Prioritize cohesiveness of the   whole document over getting the
  exact sizing replicated every time. Increase `base_size` for standalone or web
  figures.

## 4. Uncertainty

- Prefer **one shaded ribbon** (`axis`, ~0.35 alpha) over per-point error bars.
- **Name it once, in plain words** — a single *"range of uncertainty"* annotation,
  not a legend entry like "95% CI."
- Never imply more precision than the estimates support; if the band crosses the
  "no change" line across the board, let the flat series say so rather than
  annotating significance on the chart.

## 5. Attribution & branding

Every figure carries its source; only figures that travel alone carry the logo.

- **Source line — always.** A single `muted`-grey line at the foot of the figure names
  the lab and the work: *"Environmental Inequality Lab · [Short Title], [Year]"* (e.g.
  *"Environmental Inequality Lab · EPA Compliance Workshops, 2026"*). It appears on every
  figure, embedded or standalone, so a figure lifted out of its document is never
  unattributed. Pass it via `eil_save(..., source = "…")`, which renders it as the plot
  caption; scripts that don't use `eil_save()` add it as `labs(caption = …)` with a
  `muted` `plot.caption` element (see the paper figure scripts for the pattern).
- **Logo lock-up — standalone only.** Figures that travel alone (social cards, standalone
  web graphics, a figure sent on its own) carry the EIL logo in the **top-right** corner:
  `eil-logo-maroon.png` on a light canvas, `eil-logo-white.png` on a dark/accent card.
  Add it with `eil_save(..., logo = TRUE)` (or `logo = "white"`). **Omit it on figures
  embedded in a highlight, release, or newsletter** — the document's masthead already
  brands the page, and a second mark double-brands it.
- **Consistent placement.** Logo in the same corner at the same scale across cards; source
  line flush-left at the foot. Never hand-place either per-figure — the `eil_save()`
  mechanism sets both.

This mirrors the social guide's on-image conventions (`style-guides/social/README.md` §6):
a social card is a figure **re-rendered** with `logo = TRUE`, never a copied export of the
embedded figure.

## 6. Export & file conventions

- **Export with `eil_save()`** — defaults to 5.4×3.1 in, 220 dpi, white canvas.
  Keep dpi ≥ 200 for anything that may print.
- **White canvas** (`canvas`) by default; switch the background to `paper` only
  when the figure sits directly on the warm page background and a white rectangle
  would show.
- **`.png` for embedding** in highlights/releases; `.svg` or `.html` for standalone
  or interactive web pieces.
- **File layout** (per `data-viz/README.md`):

  ```
  YYYY-[topic-slug]/
  ├── code/      # script(s) that build the figure
  ├── data/      # inputs (git-excluded)
  └── figures/   # outputs (.png, .svg, .html)
  ```

  For figures that belong to a paper, the script lives in the paper's `code/`
  and writes to its `figures/` (see the canonical example).

## 7. Checklist

- [ ] Does the figure make **one** clear point?
- [ ] Could a non-specialist read the axes **without a key**?
- [ ] Is there exactly **one** emphasis color (`accented`)?
- [ ] Gridlines, y-ticks, and chart junk removed?
- [ ] Uncertainty shown as a soft band, explained once in words?
- [ ] Do the data marks read as the darkest element?
- [ ] Is the interpretation in the document, not baked into the plot?
- [ ] **Source line present** (via `source =`), on embedded and standalone alike?
- [ ] **Logo** only if the figure travels alone (`logo = TRUE`), never on an embedded one?
- [ ] Colors pulled from `eil_pal`, exported via `eil_save()` at ≥ 200 dpi?
