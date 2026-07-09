# Research Highlight Style Guide

Writing and design conventions for EIL **research highlights** — one- to two-page PDFs that
translate a single academic paper for a policy audience.

- **Canonical example:** `papers/2026-epa-compliance-workshops/research-highlight/v4/epa-compliance-workshops_research-highlight_v4.qmd`
- **Design system:** `formats/research-highlight/_style.tex` (colors, fonts, boxes, macros)
- **Starter template:** `formats/research-highlight/research-highlights-template.qmd` (matches this guide)

---

## 1. Purpose & shape

A research highlight is a roughly **two-page PDF** built from a single paper. Body type is
10.5/13.5pt. **Use the space the paper warrants:** don't try to cram too much into one page. **Don't shrink the layout to force a fit,** and don't pad to fill a second page. The running masthead and footer repeat across pages,
so two-page highlights stay branded throughout.

**Section order (fixed):**

1. **Masthead** — EIL logo (left) + `RESEARCH HIGHLIGHT` label (right), 2.2pt ink rule
   beneath. Repeats as a running header on every page via `fancyhdr`.
2. **Title** — the finding stated as a claim, not a topic.
3. **Citation line** — directly under the title.
4. **Bottom Line** — maroon box; the finding in one breath.
5. **Background** — why the question matters.
6. **What the study found** — the result and how we know it, anchored by a figure.
7. **Takeaways** — a few (two to four) subheaded points, as many as the paper earns.
8. **Footer** — "For full paper:" + DOI link, and page number.

## 2. Tone

- **Lead with the conclusion.** The title, the Bottom Line, and each section's bolded
  sentence all state the answer first. *("EPA Compliance Workshops Don't Reduce Violations.")*
- **Plain, declarative, active voice.** Prefer short words to technical ones —
  "free help to follow the rules," not "voluntary compliance interventions."
- **Bold one claim per block.** Picture a reader skimming only the bold sentences — do they
  still get the story? Bold that one, then stop. More than one or two per section and the
  emphasis stops meaning anything.
- **Define jargon on first use** and bold the term (**compliance assistance**), then
  explain it in plain language. Spell out agencies on first mention —
  "Environmental Protection Agency (EPA)."
- **Explain the method, don't name it.** Your reader doesn't need the textbook term — they
  need to see *why* the comparison is fair. Narrate it ("similar facilities that signed up but
  hadn't yet been trained") instead of labeling it ("difference-in-differences"). This is the
  heart of the *What the study found* section — see §3, Explaining the research design.
- **Earn trust with calibrated humility.** Name the limit plainly — "this is one program, and
  small benefits can't be ruled out" — then restate the real point. A reader trusts a caveat
  more than a hard sell.
- **No hype.** State the stakes soberly and let them land — "commits more public funding
  without delivering the reduction in pollution it was meant to achieve." Don't make adjectives
  do the work the facts should do.

## 3. Explaining the research design

The hardest section to write is usually **"What the study found,"** where you explain the research design to a general audience. The goal is not just to explain the method, but to walk the reader through the reasoning behind it — the challenges researchers faced and how they solved them. Rather than "here were the problems, here were the fixes," lay it out as a story: *"You might first think to compare X. But that raises [a problem]. So you might try [Y] — except that introduces [a complication]. The researchers got around this by [doing Z]."* Take the reader along the journey of figuring out how to answer the question, instead of handing them the answer at face value. (The *finding* itself still leads — title, Bottom Line, and bold sentence — this storytelling applies to how the design is explained.)

## 4. Citations

- **Citation line** (`\briefcitation`, under the title):
  *Lessons from "[Exact Paper Title]" by [Authors] in* [Journal]*, [Year].*
  Paper title in straight quotes; journal italicized.
- **In-text reference:** Author & Author (Year) — "Ferraro & Shimshack (2026)."
- **Figure source:** `Source: Ferraro & Shimshack (2026).` Use *et al.* for 3+ authors.
- **Footer link:** `For full paper: doi.org/...` — always a resolvable DOI, underlined,
  in the faint footer color. If source paper is a working paper without a DOI, use an appropriate alternative link. 

## 5. Figures

- **One to two figures in a highlight.** Each is
  centered in a `0.82\linewidth` minipage. Add a second figure only when it carries a
  distinct result — not to decorate the extra space.
- **Three stacked parts:**
  1. `\figtitle` — a sentence-style title in uppercase maroon describing what the chart
     shows ("The workshops' effect on violations, month by month") plus the source line.
  2. The image at `width=\linewidth`.
  3. An italic, faint **Note** in plain language telling the reader *how to read it* and
     what to conclude ("The band always includes 'no change,' so the workshops had no
     detectable effect").
- **Reproducible:** every figure is generated by a script in `code/` (e.g. `make-fig2.R`)
  and saved to `figures/`. No hand-edited images.
- **Chart styling** inherits the brand palette from `_style.tex` — `accentred` maroon for
  the data series, faint grey for uncertainty bands.

## 6. Formatting & mechanics

- **Never restyle in the `.qmd`.** All colors, fonts (Source Sans 3 / Source Serif 4),
  boxes, and macros live in `_style.tex`. Edit there to restyle every highlight at once.
- **Macros:** `\brieftitle`, `\briefcitation`, `\sectionhead`, `\subhead`, `\figtitle`,
  `\begin{bottomline}`. The `v4` header block overrides `\subhead` to maroon and sets body
  type to 10.5/13.5pt — keep these per-document overrides.
- **Color tokens:** `ink` (headings), `body` (text), `accentred` maroon (label, links,
  figure title, subheads), `boxred` (Bottom Line fill). Hex values are fixed in `_style.tex`.
- **Paragraphs** begin with `\noindent`; separate blocks with explicit `\vspace`
  (6–8pt between sections, 5pt between Takeaway subheads).
- **File layout:** `papers/<paper-slug>/research-highlight/` holds the `.qmd`, with sibling
  `figures/` and `code/` folders. Keep `keep-tex: true`.
- **Rendering:** there's no standalone `quarto` on PATH here — render with RStudio's bundled
  binary plus TinyTeX (`…/RStudio.app/…/quarto/bin/quarto render <file>.qmd`), which supplies
  the pdflatex the build needs.

## 7. Length budget (target)

This is the least strict element of the style guide, as long as the text is clear, direct,
and based on all other conventions in this style guide. 

| Block                 |Budget                              |
|-----------------------|------------------------------------|
| Title                 | ≤ 10                               |
| Bottom Line           | ~40–50                             |
| Background            | ~180 (2–3 paragraphs)              |
| What the study found  | ~300 (3–4 paragraphs + 1–2 figs)   |
| Takeaways             | 2–4 × ~60, each with a subhead     |
