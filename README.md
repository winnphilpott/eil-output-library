# EIL Output Library

A shared library of policy outputs — briefs, data visualizations, and social media content — developed at the Environmental Inequality Lab (EIL). Designed to make production faster, more consistent, and easier to hand off across projects.

## Structure

```
eil-output-library/
├── briefs/                    # Draft and completed policy briefs
│   └── YYYY-[topic-slug]/     # One folder per brief
│       ├── code/              # Analysis and figure scripts
│       ├── data/              # Datasets (excluded from git)
│       ├── figures/           # Figure outputs
│       └── text/              # Source .qmd (style pulled from formats/briefs/)
├── data-viz/                  # Standalone data visualizations
├── social-media/              # Social media content
├── formats/                   # Shared design system and templates
│   ├── logos/                 # Shared logo assets
│   ├── briefs/                # Brief templates and LaTeX design system
│   ├── data-viz/              # Data viz themes and templates
│   └── social-media/          # Social media image templates
└── style-guides/              # Writing and design conventions by output type
    ├── briefs/
    ├── data-viz/
    └── social-media/
```

## How to Use

- **Starting a new output?** Pick a format from the relevant subfolder in `formats/` and copy it as your starting point.
- **Checking style?** The `style-guides/` folder has conventions for tone, citations, figures, and formatting.
- **Sharing a draft?** Add it to the appropriate output folder with a short descriptive name.

## Contributing

To add a new output or template, open a pull request with your file in the appropriate folder and a short description in the PR body.
