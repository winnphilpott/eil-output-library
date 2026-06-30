# Press Release Style Guide

Writing conventions for EIL **press releases** — short, on-the-record news
announcements that translate a research finding for journalists, partners, and the
public. A press release is the companion to a research highlight: where the highlight
*explains a paper to a policy reader*, the release *announces the finding as news,
written to be quoted or reprinted*.

- **Canonical example:** _(none yet — first release sets the pattern; update this line)_
- **Starter template:** `formats/press-release/press-release-template.qmd` (matches this guide)
- **Companion guide:** `style-guides/research-highlight/README.md`

---

## 1. Purpose & shape

A press release is a **one-page** announcement (rarely two). It follows the inverted
pyramid: the most newsworthy information comes first, so an editor can cut from the
bottom without losing the story. It is written in **third person** and built to be
quoted directly or reprinted in part.

**Section order (fixed):**

1. **Release line** — `FOR IMMEDIATE RELEASE` at the top, or
   `EMBARGOED UNTIL [Month Day, Year, Time TZ]` when coordinating with a journal's
   publication date.
2. **Media contact** — name, email, phone, directly under the release line.
3. **Headline** — the finding as news, not as a standing claim.
4. **Subhead** *(optional)* — one line of context or stakes.
5. **Dateline + lead** — `CITY, State — Month Day, Year —` opening the first sentence,
   which carries the whole story (who/what/where/why) in 2–3 sentences.
6. **Body** — 2–4 short paragraphs: the finding, the method in plain language, and the
   stakes, with quotes interleaved.
7. **Quotes** — one to three attributable quotes (see §3).
8. **End marker** — `###` centered, signaling the release ends.
9. **Boilerplate** — a short, reusable "About EIL" paragraph.
10. **Paper link** — DOI, and a link to the companion research highlight.

## 2. Tone

- **Lead with the news.** The headline and lead state the finding first; an editor
  reading only the first sentence should have the story.
- **Third person, on the record.** The release speaks *about* EIL and the researchers,
  not *as* a policy explainer. Anything interpretive or evaluative belongs in a quote,
  not in EIL's own voice.
- **Plain, declarative, active voice.** Same plain-language bar as the highlight —
  "free help to follow the rules," not "voluntary compliance interventions." Spell out
  agencies on first use: "Environmental Protection Agency (EPA)."
- **Explain the method, don't name it.** Narrate *why* a comparison is credible rather
  than writing "difference-in-differences."
- **No hype, calibrated humility.** State the stakes soberly and keep the honest caveat
  — but put strong claims and significance into a researcher's quote, where they read as
  attributed judgment rather than EIL editorializing.
- **Newsworthy, not promotional.** A release reports a finding; it does not sell a
  program. Avoid adjectives a journalist would cut ("groundbreaking," "first-ever").

## 3. Quotes

- **One to three quotes**, each clearly attributed: *"…," said [Full Name], [Title],
  [Affiliation].*
- **Divide the labor:** the PI/lead author speaks to *what the finding means*; a
  policymaker, agency official, or affected stakeholder speaks to *why it matters*.
- **Quotes do the interpretive work** the surrounding prose avoids — significance,
  judgment, calls to action all live here.
- **Full title and affiliation on first quote** from each person; first name only on any
  later quote.
- **Approve quotes before publishing.** Real attributed quotes must be confirmed with the
  speaker; never invent or paraphrase a quote as if direct.

## 4. Citations & links

- **Name the paper in the body:** the exact title in quotes, authors, and journal —
  *"[Exact Paper Title]," published in [Journal] by [Authors].*
- **In-text reference:** Author & Author (Year); *et al.* for 3+ authors.
- **Paper link:** a resolvable DOI — `doi.org/...`.
- **Companion highlight:** link the research highlight as the deeper read.

## 5. Formatting & mechanics

- **One page** unless the story genuinely needs more. Short paragraphs (2–4 sentences).
- **Release line in caps**, top-left. Embargo line in caps when used.
- **Dateline** in AP form: `CITY, State —` (city in caps, state spelled or AP-abbreviated).
- **`###`** centered to mark the end, before boilerplate.
- **Boilerplate is reusable** — keep one approved "About EIL" paragraph and use it
  verbatim across releases. Edit it in one place.
- **File layout:** `papers/<paper-slug>/press-release/` holds the release, alongside the
  paper's other outputs.

## 6. Length budget (target)

| Block            | Target                                  |
|------------------|-----------------------------------------|
| Headline         | ≤ 15 words                              |
| Subhead          | ≤ 20 words                              |
| Lead             | 2–3 sentences (~50 words)               |
| Body             | 2–4 paragraphs (~250–350 words total)   |
| Quotes           | 1–3, ~30–50 words each                  |
| Boilerplate      | ~50–75 words, reusable                  |
