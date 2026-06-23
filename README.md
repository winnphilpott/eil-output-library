# EIL Brief Library

A shared library of policy brief drafts, style guides, and reusable brief formats developed at the Environmental Inequality Lab (EIL). Designed to make brief-writing faster, more consistent, and easier to hand off across projects.

## Structure

```
eil-brief-library/
├── briefs/                    # Draft and completed briefs
│   └── YYYY-[topic-slug]/     # One folder per brief
│       ├── code/              # Analysis and figure scripts
│       ├── data/              # Datasets (excluded from git)
│       ├── figures/           # Figure outputs
│       └── text/              # Source .qmd (style pulled from formats/)
├── formats/                   # Shared design system and templates
│   ├── _style.tex             # LaTeX design system for all briefs
│   ├── policy-brief-template.qmd  # Starting template for a new brief
│   └── logos/                 # Shared logo assets
└── style-guides/              # Writing conventions, tone, citations, formatting
```

## How to Use

- **Starting a new brief?** Pick a format from `formats/` and copy it as your starting point.
- **Checking style?** The `style-guides/` folder has conventions for tone, citations, figures, and structure.
- **Sharing a draft?** Add it to `briefs/` with a short descriptive name.

## Contributing

To add a new brief or template, open a pull request with your file in the appropriate folder and a short description in the PR body.
