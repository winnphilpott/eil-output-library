# Social Media Style Guide

Conventions for EIL **social posts** — straightforward messaging meant for the most general audience. A social post *catches one's attention and sends the reader to the finding*. Scope: **X/Twitter and LinkedIn**.

- **Design system:** `formats/social/` (R card templates, built on the data-viz theme)
- **Figure theme & palette:** `formats/data-viz/eil-theme.R` (`eil_pal`, `theme_eil()`, `eil_save()`)
- **Logos:** `formats/logos/eil-logo-maroon.png`, `formats/logos/eil-logo-white.png`
- **Companion guides:** `style-guides/press-release/README.md`, `style-guides/data-viz/README.md`

---

## 1. Purpose & shape

A social post is the shortest EIL output and the first one most people see. It carries
**one finding, one link, one image**. It never has to stand alone
as the argument; the linked highlight or release does that. Two platforms, one voice, two
length budgets:

- **X/Twitter** — a tight hook, finding-first, link trailing. High scroll velocity; the
  image does the stopping.
- **LinkedIn** — the same finding-first opening, but room for a short "why it matters"
  paragraph and an inline link. A policy/professional audience that tolerates more text.

**Cadence: event-driven, not a content calendar.** EIL is a small lab and posts
accordingly — a social post accompanies a real output (a highlight, a release, a
published paper), not a daily posting quota. Every post is
deliberate: if it doesn't carry a genuine finding to a genuine link or other important lab news, 
it doesn't go out.

## 2. Visual-first

**Every X post ships with an image unless there's a deliberate reason not to.** A tweet
with a chart, stat card, or figure catches someone's eye where plain text slides past. The
image carries the finding on its own or compliments it — assume many readers see the picture 
and then maybe read the caption.

- **Default to a visual.** Text-only posts are the exception (a quick reaction, a repost
  with comment), not the rule.
- **The image is self-sufficient.** Similar to figure conventions, source line and a legible headline 
  live *on* the image, not only in the caption (see §6).
- **Reuse the recipe, re-render the card.** A social card is built from the paper's
  existing figure *recipe* — same data, same plot, same theme — but it can't be a straight
  copy of the embedded PNG. Re-render it with the logo lock-up added
  (`eil_save(..., logo = TRUE)`) and at social dimensions, so it stands alone. Reuse the
  plot, not the exported file (see data-viz README §5).
- **LinkedIn too.** A visual still outperforms text, though LinkedIn's longer caption does
  more of the work.

## 3. The three archetypes

EIL runs three social formats. Pick one per post and let that guide the output.

**a. Finding announcement** — the workhorse. Announces a new paper/result as news.
- *Anatomy:* finding-first hook → author credit → link, over a chart or stat card.
- *Use when:* a highlight or release is going live.

**b. Chart / stat card** — a single number or figure as the whole post.
- *Anatomy:* one stat or one chart, headline + source baked into the image; caption adds
  one line of context.
- *Use when:* the result is legible at a glance and doesn't need the full story to land. 
  Additionally, a  good option for when there's an interesting development in a project, 
  but the paper isn't ready for sharing yet. 

**c. Thread** — a finding unrolled across a few posts.
- *Anatomy:* **the first post carries the entire hook** (finding + image) and must stand
  alone; 3–5 follow-ups add method-in-plain-language, the caveat, and the link; last post
  credits authors and links the paper.
- *Use when:* the story needs a step of reasoning the single card can't hold.

Quote cards (a scholar's sentence over a branded background) are **optional**, not a core
archetype — see §7.

## 4. Voice

Inherits the press-release register, compressed:

- **Lead with the finding.** The first line states the result; the reader who sees only
  that has the story. Don't open with vague or generic phrases like "New paper out" 
  or "Excited to share."
- **Plain, declarative, active.** "Free help to follow the rules," not "voluntary
  compliance interventions." Spell out agencies on first use — Environmental Protection
  Agency (EPA).
- **Explain the method, don't name it.** Narrate why a comparison is credible; never write
  "difference-in-differences" in a caption.
- **Academic tone and grounding.** State stakes soberly; keep the caveat. 
- **Lab voice.** The post speaks as the Environmental Inequality Lab, not as an
  individual.

## 5. Author attribution

Posts speak in the **lab's voice but always surface the authors**.

- **Credit by name, tag when handles exist:** *"New EIL research by [Full Name] and [Full
  Name] finds…"* Use handles (`@…`) when the author has one; fall back to plain names when
  they don't.
- **Three-plus authors:** name the lead and use "and colleagues" (spell all names into the
  linked highlight, not the caption).
- **On a thread,** the credit lives in the final post alongside the paper link, so the
  hook post stays uncluttered.

## 6. On-image conventions

The image must survive being seen with no caption:

- **Headline on the image** — the finding in plain words, sized to read at thumbnail.
- **Source line always present** — `muted` grey, bottom of the card, e.g. *"Environmental
  Inequality Lab · [Paper short title], 2026."*
- **Logo lock-up** — `eil-logo-maroon.png` on a light card, `eil-logo-white.png` on a
  dark/accent card, one corner, consistent placement.
- **Palette + type from the house theme** — colors from `eil_pal`, one emphasis color
  (`accentred`), Source Sans 3. Never hand-pick hex (see data-viz §2).

## 7. Quote cards (optional)

A quote card puts a single sentence over a branded background. Leave
the format unused until a real, confirmed, attributable quote exists. 
When used: attribute fully on the card (name, title,
affiliation) and confirm the quote with the speaker before posting.

## 8. Caption budgets

| Element        | X/Twitter                                        | LinkedIn                       |
|----------------|--------------------------------------------------|--------------------------------|
| Hook (first line) | ≤ ~200 chars, finding-first                    | ≤ ~200 chars, finding-first    |
| Body           | none — the hook *is* the post                    | 2–4 short lines, "why it matters" |
| Link           | trailing, last line                              | inline or trailing             |
| Hashtags       | 1–2, topical, never decorative                   | 0–3, topical                   |
| Image          | required (§2)                                    | strongly preferred             |
| Thread         | first post ≤ hook budget, 3–5 follow-ups         | N/A — use the body instead     |

## 9. File & folder conventions

Social lives in one of two places, by whether it belongs to a paper:

- **Paper-tied social** → `papers/<paper-slug>/social/`, next to that paper's
  `press-release/`, `data-viz/`, and `blog/` (see `papers/README.md`). Most social is
  this. No dated sub-folder — the paper folder already names the topic.
- **Non-paper social** (lab news, events, cross-paper campaigns) → the top-level
  `social/YYYY-[topic-slug]/` (see `social/README.md`).

Both use the same inside shape:

```
social/
├── assets/   # source images, exported cards, design files
└── copy/     # caption drafts, per platform
```

- **Card scripts** that generate images live in the `social/` folder or extend
  `formats/social/` templates; they pull `formats/data-viz/eil-theme.R` so social cards
  match paper figures.
- **Name copy by platform** — e.g. `copy/x.md`, `copy/linkedin.md` — so a draft is
  self-describing out of context.

## 10. Checklist

- [ ] Does the post carry **one** finding, one link, one image?
- [ ] Does the **first line state the finding** (no "excited to share")?
- [ ] Is there a **visual**, and does it read with no caption?
- [ ] Are **authors named/tagged** in the lab's voice?
- [ ] Source line + logo lock-up on the image?
- [ ] Colors from `eil_pal`, one emphasis color, house type?
- [ ] Caption within the platform's budget; hashtags topical and few?
- [ ] Any quote **real, attributed, and confirmed** — never a placeholder?
