# EIL Output Library

A shared library of public-facing outputs developed at the Environmental Inequality Lab (EIL). Each paper gets a full communications bundle; shared templates and design assets live in `formats/`.

## Structure

```
eil-output-library/
├── papers/                    # One folder per paper, each containing a full output bundle
│   └── YYYY-[topic-slug]/
│       ├── code/              # Figure scripts
│       ├── data/              # Datasets (excluded from git)
│       ├── figures/           # Figure outputs (shared across outputs)
│       ├── research-highlight/  # One-page research highlight
│       ├── press-release/     # Press release
│       ├── blog/              # Blog post copy and assets
│       └── social/            # Social media copy and assets
├── newsletter/                # Newsletter posts (date-based, not tied to a single paper)
│   └── YYYY-MM-DD/
├── data-viz/                  # Standalone data visualizations
├── formats/                   # Shared design system and templates
│   ├── logos/                 # Shared logo assets
│   ├── research-highlight/    # Research highlight templates and LaTeX design system
│   ├── press-release/         # Press release templates
│   ├── blog/                  # Blog post templates
│   ├── social/                # Social media image templates
│   ├── newsletter/            # Newsletter templates
│   └── data-viz/              # Data viz themes and templates
└── style-guides/              # Writing and design conventions by output type
    ├── research-highlight/
    ├── press-release/
    ├── blog/
    ├── social/
    ├── newsletter/
    └── data-viz/
```

## How to Use

- **Starting a new output?** Pick a format from the relevant subfolder in `formats/` and copy it as your starting point.
- **Checking style?** The `style-guides/` folder has conventions for tone, citations, figures, and formatting.
- **Sharing a draft?** Add it to the appropriate output folder with a short descriptive name.

## Contributing

To add a new output or template, open a pull request with your file in the appropriate folder and a short description in the PR body.
