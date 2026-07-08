# Social Card Templates

R scaffolding for EIL **social media cards** — the images that ride along with a
social post. Any card with a figure should be *re-rendered for social*: larger type, a headline
baked in, the logo lock-up added, sized to a platform aspect ratio. The figure that exists in
other outputs won't integrate well with the social card.

- **Style guide:** `style-guides/social/README.md` (voice, archetypes, on-image conventions)
- **Builds on:** `formats/data-viz/eil-theme.R` (palette, theme, `eil_save()`)

## Files

The card builders live in `assets/`, alongside the exported `.png`s:

| File | What it is |
|---|---|
| `assets/social-cards.R` | Shared scaffolding — dimensions, card themes, `eil_stat_card()`, `eil_quote_card()`, helpers. Sourced by the templates. |
| `assets/stat-card-template.R` | Runnable starter for a **stat card** (eyebrow + one hero number + headline). |
| `assets/chart-card-template.R` | Runnable starter for a **chart card** (a paper figure re-rendered for social). |
| `assets/quote-card-template.R` | Runnable starter for a **quote / finding card** (one pulled sentence over the house maroon). Real, confirmed quotes only — see style guide §7. |
| `copy/linkedin.md`, `copy/x.md` | Skeleton **post copy**, per platform — finding-first hook, credit, link, hashtags, image. Fill in and approve before posting. |

The three cards mirror the design mockup: **landscape 1200×675** with a shared chrome —
an eyebrow kicker top-left, the logo lock-up top-right, and a source line above a thin
rule at the foot.

## Run

From the **repo root** (the templates source the data-viz theme by relative path):

```
Rscript formats/social/assets/stat-card-template.R    # -> /tmp/eil-stat-card.png
Rscript formats/social/assets/chart-card-template.R   # -> /tmp/eil-chart-card.png
Rscript formats/social/assets/quote-card-template.R   # -> /tmp/eil-quote-card.png
```

Deps: `ggplot2` (+ `dplyr` for the chart demo) and `png` (for the logo overlay).

## Adjusting

Each template has two `EDIT HERE` blocks — **content** (stat, headline, source) and
**format** (`DIMS`, `BG`, `LOGO`). Common knobs:

- **Aspect ratio** — `DIMS <- SOCIAL_DIMS$landscape | $square | $portrait`. The templates
  default to **landscape** (1200×675), matching the mockup; the builders' text sizes are
  tuned for it. Square still works — bump the `*_size` args and spread the `*_y` anchors.
- **Text wrapping** — `wrap_text("…", width)`; ggplot won't wrap for you, so lower the
  width for bigger type. Keep stat-card headlines short (detail goes in the sub-line).
- **Stat layout** — `eil_stat_card()` places its blocks (`eyebrow` / stat / headline /
  `sub`) at fixed anchors (`eyebrow_y` / `stat_y` / `head_y` / `sub_y`) with matching
  `*_size` args; nudge these if a longer headline crowds the sub-line.
- **Quote layout** — `eil_quote_card()` places the mark / quote / attribution at
  `mark_y` / `quote_y` / `attribution_y`; it defaults to light-on-maroon colours.
- **Dark / accent card** — set `BG` to a dark hex, `LOGO <- "white"`, and pass a light
  `caption_color` to `theme_eil_card()` (e.g. `adjustcolor(eil_pal$paper, 0.7)`).

## Output convention

Templates write to `/tmp` for a quick preview. For new outputs, save into the paper's
`social/` folder (or, for non-paper campaigns, a top-level `social/YYYY-[topic-slug]/`) —
see `style-guides/social/README.md` §9:

```
papers/<paper-slug>/social/      # paper-tied (most social)
├── assets/   # exported cards (.png)
├── copy/     # captions, per platform
└── script/   # the .R card builders
```

The EPA cards are a worked example — `stat-card.R`, `chart-card.R`, and `quote-card.R` in
`papers/2026-epa-compliance-workshops/social/code/`, writing to `social/assets/`.
