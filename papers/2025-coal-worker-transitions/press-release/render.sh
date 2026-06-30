#!/usr/bin/env bash
# Render every .qmd in this folder to PDF, regardless of where it's called from.
# Usage:  ./render.sh   (or: bash render.sh)
set -euo pipefail

# Always work from this script's own directory so relative paths resolve.
cd "$(dirname "$0")"

# Make sure pdflatex (TinyTeX) is on PATH.
export PATH="$HOME/Library/TinyTeX/bin/universal-darwin:$PATH"

# Find quarto: prefer one on PATH, else fall back to the RStudio-bundled binary.
if command -v quarto >/dev/null 2>&1; then
  QUARTO=quarto
elif [ -x "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto" ]; then
  QUARTO="/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto"
else
  echo "error: quarto not found on PATH or in RStudio.app" >&2
  exit 1
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
