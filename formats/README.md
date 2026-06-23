# Formats

Reusable templates and design files for EIL outputs.

## Subfolders

| Folder | Purpose |
|---|---|
| `logos/` | Shared logo assets (e.g., `eil-logo-maroon.png`) used across all output types |
| `briefs/` | Policy brief templates and LaTeX design system (`_style.tex`) |
| `data-viz/` | Data visualization themes and templates |
| `social-media/` | Social media image templates |

## Using `_style.tex` (briefs)

Each brief's `.qmd` file references the shared design system via `include-in-header` in its YAML:

```yaml
include-in-header: ../../../formats/briefs/_style.tex
```

If a specific brief needs a different visual style, create a local `_style.tex` in its `text/` folder and point to that instead. A brief-specific file can also import and override values from the shared file.
