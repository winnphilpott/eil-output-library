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

## Paper Intake Workflow

The general idea is to start small, with the most essential bits of information from a paper, and then work up from there. This helps maintain consistent messaging across outputs. 

1. **Reading and Understanding** Read through the paper, talk with PIs about any questions, note any technically dense and/or essential-to-know sections.
2. **Data Visualization** Identify one (two if absolutely necessary) figure from the paper that gets the central point across. Verify with PIs that this is the idea we want to frame our communication around.
3. **Social Media** Draft any posts/captions to be shared alongside key figure. Use this time to identify key messaging and take-aways for a short output. Use this to inform development for longer-form outputs.
4. **Press Release** Think about what a reporter needs to know to decide whether or not they want to explore or write about this paper. Think about taking it a step further than the social media output, but keeping it concise. This is where quotes/interpretations not in the paper would be helpful from a PI or qualified stakeholder. Talk to PIs about this early on so that we have that if necessary when press release time comes.
5. **Research Highlight** Here is where we can get more into the mechanics of the study (while maintaining a general interest audience).
6. **Blog Post/Newsletter** Still prioritizing findings-first language, but this can be the longest form and more conversational. Hopefully by this point, you'll be familiar enough with the key points of the paper that this will be easy and an opportunity to make connections that you wouldn't in other outputs. For this I think it's fair to assume a more econ/environment-interested audience, though it should still be accessible for general readers. 

## Contributing

To add a new output or template, open a pull request with your file in the appropriate folder and a short description in the PR body.
