# Press Release Style Guide

Writing conventions for EIL **press releases** — short, on-the-record news
announcements that translate a research finding for journalists, partners, and the
public. A press release is the companion to a research highlight: where the highlight
*explains a paper to a policy reader*, the release *announces the finding as news,
written to be quoted or reprinted*.

- **Canonical example:** `papers/2026-epa-compliance-workshops/press-release/epa-compliance-workshops_press-release.qmd`
- **Starter template:** `formats/press-release/press-release-template.qmd` (matches this guide)
- **Companion guide:** `style-guides/research-highlight/README.md`

---

## 1. Purpose & shape

A press release is a **one-page** announcement (rarely two). It follows the inverted
pyramid: the most newsworthy information comes first, so an editor can cut from the
bottom without losing the story. It is written in **third person** and built to be
quoted directly or reprinted in part.

**Section order (fixed):**

1. **Headline** — the finding as news, not as a standing claim. Sits directly under the
   masthead.
2. **Subhead** *(optional)* — one line of context or stakes.
3. **Release line + dateline** — opens the body: `FOR IMMEDIATE RELEASE` followed by
   `CITY, State · Month Day, Year` (or `EMBARGOED UNTIL [Month Day, Year, Time TZ]` when
   coordinating with a journal's publication date).
4. **Lead** — the first paragraph, carrying the whole story (who/what/where/why) in 2–3
   sentences.
5. **Body** — 2–4 short paragraphs: the finding, the method in plain language, and the
   stakes, with any quotes interleaved.
6. **Quotes** *(optional)* — up to three attributable quotes (see §3).
7. **End marker** — `###` centered, signaling the release ends.
8. **Media contact** — name, email, phone, in a sentence at the bottom, just above the
   boilerplate.
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

## 3. Quotes (optional)

Quotes are encouraged but **not required** — a release stands on its own without them.
**Never use an invented or placeholder quote.** Leave the section out entirely until a
real, confirmed quote exists; a fabricated "stand-in" is worse than no quote.

- **Up to three quotes**, each clearly attributed: *"…," said [Full Name], [Title],
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
- **Body type is 11/15pt** — set once after the masthead, overriding the shared
  `_style.tex` 9.4pt default. A release is sparse, so it reads larger than a research
  highlight. The release line, contact, boilerplate, and footer keep their own smaller sizes.
- **Release line in caps** opens the body (not the header), with the dateline beside it:
  `FOR IMMEDIATE RELEASE   CITY, State · Month Day, Year`. Embargo line in caps when used.
- **`###`** centered to mark the end. The media contact sits just below it, before the
  boilerplate.
- **Boilerplate is reusable** — keep one approved "About EIL" paragraph and use it
  verbatim across releases. Edit it in one place.
- **File layout:** `papers/<paper-slug>/press-release/` holds the release, named
  `<paper-slug>_press-release.qmd` so the source and its rendered PDF stay self-describing
  even out of folder context (see `papers/README.md`).

## 6. Length budget (target)

| Block            | Target                                  |
|------------------|-----------------------------------------|
| Headline         | ≤ 15 words                              |
| Subhead          | ≤ 20 words                              |
| Lead             | 2–3 sentences (~50 words)               |
| Body             | 2–4 paragraphs (~250–350 words total)   |
| Quotes *(optional)* | 0–3, ~30–50 words each               |
| Boilerplate      | ~25–40 words (one sentence), reusable    |
