# Data Visualizations

Standalone data visualizations produced at the Environmental Inequality Lab.

## Folder Convention

Each project gets its own folder named `YYYY-[topic-slug]` (e.g., `2026-epa-violations-map`).

```
YYYY-[topic-slug]/
├── code/          # scripts that produce the visualization
├── data/          # datasets used (excluded from git)
└── figures/       # output files (e.g., .png, .svg, .html)
```

## Formats and Style

Style conventions live in [`style-guides/data-viz/README.md`](../style-guides/data-viz/README.md). The theme and starter live in `formats/data-viz/`:

- [`eil-theme.R`](../formats/data-viz/eil-theme.R) — house palette (`eil_pal`), `theme_eil()`, and `eil_save()`.
- [`data-viz-template.R`](../formats/data-viz/data-viz-template.R) — runnable starter (synthetic data) demonstrating the house style.

Canonical example: `papers/2026-epa-compliance-workshops/figures/fig2-did.png` (built by `code/make-fig2.R`).
