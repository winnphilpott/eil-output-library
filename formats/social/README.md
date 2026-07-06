# Social Card Templates

R scaffolding for EIL **social media cards** — the images that ride along with a
social post. A card is a figure *re-rendered for social*: larger type, a headline
baked in, the logo lock-up added, sized to a platform aspect ratio. It is never a
copied export of a print figure.

- **Style guide:** `style-guides/social/README.md` (voice, archetypes, on-image conventions)
- **Builds on:** `formats/data-viz/eil-theme.R` (palette, theme, `eil_save()`)

## Files

| File | What it is |
|---|---|
| `social-cards.R` | Shared scaffolding — dimensions, card themes, helpers. Sourced by the templates. |
| `stat-card-template.R` | Runnable starter for a **stat card** (one hero number + headline). |
| `chart-card-template.R` | Runnable starter for a **chart card** (a paper figure re-rendered for social). |

## Run

From the **repo root** (the templates source the data-viz theme by relative path):

```
Rscript formats/social/stat-card-template.R    # -> /tmp/eil-stat-card.png
Rscript formats/social/chart-card-template.R   # -> /tmp/eil-chart-card.png
```

Deps: `ggplot2` (+ `dplyr` for the chart demo) and `png` (for the logo overlay).

## Adjusting

Each template has two `EDIT HERE` blocks — **content** (stat, headline, source) and
**format** (`DIMS`, `BG`, `LOGO`). Common knobs:

- **Aspect ratio** — `DIMS <- SOCIAL_DIMS$square | $portrait | $landscape` (square is the
  workhorse, safe on X and LinkedIn).
- **Text wrapping** — `wrap_text("…", width)`; ggplot won't wrap for you, so lower the
  width for bigger type. Keep stat-card headlines short (detail goes in the sub-line).
- **Stat layout** — `eil_stat_card()` places its three text blocks at fixed anchors
  (`stat_y` / `head_y` / `sub_y`) with sizes `stat_size` / `head_size` / `sub_size`;
  nudge these if a longer headline crowds the sub-line.
- **Dark / accent card** — set `BG` to a dark hex and `LOGO <- "white"`.

## Output convention

Templates write to `/tmp` for a quick preview. For real work, save into the campaign
folder per `social/README.md`:

```
social/YYYY-[topic-slug]/
├── assets/   # exported cards (.png)
└── copy/     # captions, per platform
```
