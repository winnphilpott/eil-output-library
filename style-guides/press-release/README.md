# Press Release Style Guide

Writing conventions for EIL **press releases** — short, on-the-record news
announcements that translate a research finding for journalists, partners, and the
public. The release *announces the finding as news, written to be quoted or reprinted*.

- **Canonical example:** `papers/2026-epa-compliance-workshops/press-release/epa-compliance-workshops_press-release.qmd`
- **Design system:** `formats/press-release/_style.tex` (colors, fonts, masthead/headline macros)
- **Starter template:** `formats/press-release/press-release-template.qmd` (matches this guide)
- **Companion guide:** `style-guides/research-highlight/README.md`

---

## 1. Purpose & shape

A press release is a **one-page** announcement. It follows the inverted
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
5. **Body** — 2–3 short paragraphs: the finding, the method in plain language, and the
   stakes, with any quotes interleaved.
6. **Quotes** *(optional)* — up to three attributable quotes (see §3).
7. **Media contact** — name, email, phone, in a sentence closing the body, just above the
   end marker.
8. **End marker** — `###` centered, signaling the release ends.
9. **Boilerplate** — "About EIL" paragraph -- consistent across press releases unless updated.
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
- **No hype, calibrated humility.** State the stakes soberly and keep the caveat
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
- **Paper link:** a resolvable DOI — `doi.org/...`. If a working paper or without a DOI, use a different appropriate link.
- **Companion highlight:** link the research highlight as the deeper read (should be on EIL website).

## 5. Formatting & mechanics

- **One page** unless the story genuinely needs more. Short paragraphs (2–4 sentences).
- **Body type is 11/15pt** — set in the press-release `_style.tex`, so a release reads
  larger than a research highlight without a per-document override. The masthead label,
  release line, contact, boilerplate, and footer set their own smaller sizes inline.
- **Never restyle in the `.qmd`.** Colours, fonts, and the `\briefheader` / `\brieftitle`
  macros live in `formats/press-release/_style.tex` — edit there to restyle every release.
- **Release line in caps** opens the body (not the header), with the dateline beside it:
  `FOR IMMEDIATE RELEASE   CITY, State · Month Day, Year`. Embargo line in caps when used.
- **`###`** centered to mark the end. The media contact sits just above it, closing the
  body; the boilerplate and paper link follow below, centered.
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
| Body             | 2–3 paragraphs (~150–220 words total)   |
| Quotes *(optional)* | 0–3, ~30–50 words each               |
| Boilerplate      | Standardized, reusable                  |
