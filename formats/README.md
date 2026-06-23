# Brief Formats

Reusable structural templates and design files for EIL policy briefs.

## Files

| File | Purpose |
|---|---|
| `_style.tex` | Shared LaTeX design system — colors, fonts, spacing macros, and box definitions for all policy briefs |

## Using `_style.tex`

Each brief's `.qmd` file references this file via `include-in-header` in its YAML:

```yaml
include-in-header: ../../../formats/_style.tex
```

If a specific brief needs a different visual style, create a local `_style.tex` in its `text/` folder and point to that instead. A brief-specific file can also import and override values from the shared file.
