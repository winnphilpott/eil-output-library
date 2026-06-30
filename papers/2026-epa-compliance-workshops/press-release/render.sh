#!/usr/bin/env bash
# Render every .qmd in this folder to PDF, regardless of where it's called from.
#
# Requirements:
#   - Quarto:  https://quarto.org/docs/get-started/
#   - LaTeX:   run once  →  quarto install tinytex
#
# Works on macOS, Linux, and Windows via Git Bash or WSL.
# Native Windows (PowerShell) users: run render.ps1 instead.
set -euo pipefail
cd "$(dirname "$0")"

# --- Locate quarto: PATH first, then common RStudio-bundled locations. --------
find_quarto() {
  if command -v quarto >/dev/null 2>&1; then
    command -v quarto
    return 0
  fi
  local candidates=(
    "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto"       # macOS
    "$HOME/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto"  # macOS (user install)
    "/usr/lib/rstudio/resources/app/bin/quarto/bin/quarto"                     # Linux desktop
    "/usr/lib/rstudio-server/bin/quarto/bin/quarto"                            # Linux server
  )
  local c
  for c in "${candidates[@]}"; do
    if [ -x "$c" ]; then echo "$c"; return 0; fi
  done
  return 1
}

if ! QUARTO="$(find_quarto)"; then
  echo "error: quarto not found. Install from https://quarto.org/docs/get-started/" >&2
  exit 1
fi

# --- Best effort: if pdflatex isn't found, add a standard TinyTeX bin to PATH.
# Quarto usually locates LaTeX itself; this helps when TinyTeX was installed
# outside Quarto (e.g. via R/RStudio) and isn't yet on PATH. The bin/* glob
# picks whatever architecture subdir exists (darwin / linux / windows).
if ! command -v pdflatex >/dev/null 2>&1; then
  for d in \
    "$HOME/Library/TinyTeX/bin"/* \
    "$HOME/.TinyTeX/bin"/* \
    "$HOME/AppData/Roaming/TinyTeX/bin"/* ; do
    if [ -d "$d" ]; then export PATH="$d:$PATH"; break; fi
  done
fi

shopt -s nullglob
qmds=(*.qmd)
if [ ${#qmds[@]} -eq 0 ]; then
  echo "No .qmd files to render in $(pwd)"
  exit 0
fi

for qmd in "${qmds[@]}"; do
  echo "Rendering $qmd ..."
  "$QUARTO" render "$qmd"
done
