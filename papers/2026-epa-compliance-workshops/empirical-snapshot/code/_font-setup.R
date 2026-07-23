# =====================================================================
#  _font-setup.R  ·  shared helper for the empirical-snapshot drafts
#  DRAFT — these are exploratory options, not a finalized output.
#
#  Registers the real house typefaces (Source Sans 3 + Source Serif 4,
#  both bundled as OTF inside a TinyTeX install, LaTeX-only otherwise)
#  so ragg's PNG device can use them like ordinary R font families, and
#  captures the exact masthead/title/dek specs transcribed from the
#  house LaTeX macros:
#    - \briefheader  (formats/press-release/_style.tex, and the per-doc
#      fancyhdr masthead in each research-highlight .qmd): logo LEFT +
#      label RIGHT, 8.25pt/10pt bold accentred, MakeUppercase,
#      textls[200], then a 2.2pt ink rule.
#    - \brieftitle (shared macro, identical in both _style.tex files):
#      18pt/19.5pt bold ink, textls[-12].
#    - the press release's dek line: Source Serif 4 italic, cite color,
#      11pt/14pt.
#    - \sectionhead (research-highlight/_style.tex): 9.75pt/12pt bold
#      accentred, MakeUppercase, textls[20].
#    - footer/source lines: faint color, ~7.4pt (research-highlight's
#      "For full paper:" line).
#
#  Usage in a draft script (run from REPO ROOT):
#    source("papers/2026-epa-compliance-workshops/empirical-snapshot/code/_font-setup.R")
#    png(...)                  ->  ragg::agg_png(...)
#    gpar(...)                 ->  gpar(fontfamily = EIL_FONT, ...)
#    theme_eil(base_size = 13) ->  theme_eil(base_size = 13, base_family = EIL_FONT)
#    tracked-caps label        ->  grid.text(track_caps("label", 200), ...)
#    rule weight in pt         ->  gpar(lwd = pt_lwd(2.2), ...)
#
#  NOTE: the TinyTeX path below is machine-specific (same caveat as
#  papers/README.md's RStudio-bundled Quarto path) -- adjust
#  .tinytex_dir if TinyTeX is installed elsewhere.
# =====================================================================

suppressMessages({ library(systemfonts); library(ragg) })

EIL_FONT       <- "Source Sans 3"
EIL_FONT_SERIF <- "Source Serif 4"

.tinytex_dir     <- "/Users/winnphilpott/Library/TinyTeX/texmf-dist/fonts/opentype/adobe"
.sourcesans_dir  <- file.path(.tinytex_dir, "sourcesans")
.sourceserif_dir <- file.path(.tinytex_dir, "sourceserif")

if (!(EIL_FONT %in% systemfonts::registry_fonts()$family)) {
  systemfonts::register_font(
    name       = EIL_FONT,
    plain      = file.path(.sourcesans_dir, "SourceSans3-Regular.otf"),
    bold       = file.path(.sourcesans_dir, "SourceSans3-Bold.otf"),
    italic     = file.path(.sourcesans_dir, "SourceSans3-RegularIt.otf"),
    bolditalic = file.path(.sourcesans_dir, "SourceSans3-BoldIt.otf")
  )
}
if (!(EIL_FONT_SERIF %in% systemfonts::registry_fonts()$family)) {
  systemfonts::register_font(
    name   = EIL_FONT_SERIF,
    plain  = file.path(.sourceserif_dir, "SourceSerif4-Regular.otf"),
    italic = file.path(.sourceserif_dir, "SourceSerif4-RegularIt.otf")
  )
}

# ---- House type specs (verbatim from the LaTeX macros) -----------------
EIL_MASTHEAD_LABEL_PT <- 8.25   # \briefheader label
EIL_TITLE_PT          <- 18     # \brieftitle
EIL_DEK_PT            <- 11     # press-release dek (Source Serif 4 italic)
EIL_SECTIONHEAD_PT    <- 9.75   # \sectionhead
EIL_FOOTER_PT         <- 7.4    # "For full paper:" footer line

# ---- Rule weights: pt (LaTeX \rule) -> grid lwd -------------------------
# R grid's lwd is ~1/96in per unit; LaTeX rule thickness is in points
# (1/72.27in). This is the one conversion that lets "2.2pt" and "0.7pt"
# mean the same physical thickness in both the PDF and the PNG.
pt_lwd <- function(pt) pt * 96 / 72.27

# ---- Emulate OpenType tracking (\textls[n]) ------------------------------
# grid::gpar has no letter-spacing control, so -- same trick as
# formats/social/assets/social-cards.R's letter_space() -- insert real
# space characters between glyphs. n is roughly in \textls units (1/1000
# em); this is a visual approximation, not a unit-exact conversion.
track_caps <- function(x, n = 200) {
  sep <- if (n >= 150) "  " else if (n >= 40) " " else ""
  if (sep == "") return(toupper(x))
  vapply(toupper(x), function(s) paste(strsplit(s, "")[[1]], collapse = sep),
         character(1), USE.NAMES = FALSE)
}
