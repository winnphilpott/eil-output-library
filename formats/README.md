# Formats

Reusable templates and design files for EIL outputs.

## Subfolders

| Folder | Purpose |
|---|---|
| `logos/` | Shared logo assets (e.g., `eil-logo-maroon.png`) used across all output types |
| `research-highlight/` | Research highlight templates and LaTeX design system (`_style.tex`) |
| `press-release/` | Press release templates |
| `blog/` | Blog post templates |
| `social/` | Social media image templates |
| `newsletter/` | Newsletter templates |
| `data-viz/` | Data visualization themes and templates |

## Using `_style.tex` (research highlights)

Each research highlight's `.qmd` file references the shared design system via `include-in-header` in its YAML:

```yaml
include-in-header: ../../../formats/research-highlight/_style.tex
```

If a specific paper needs a different visual style, create a local `_style.tex` in its `research-highlight/` folder and point to that instead. A paper-specific file can also import and override values from the shared file.
