#!/usr/bin/env python3
"""
extract-fig3a.py  ·  Recover the Figure 3(a) estimates from the source PDF.

Figure 3(a) ("Any investigation") is a local-projection event study: the change
in P(investigation) in each month around a citizen complaint, month -1 = 0 by
construction. The paper ships no coefficient table, so we recover the numbers
directly from the vector PDF rather than eyeballing them.

The panel is drawn as two vector paths on page 48 (0-indexed 47):
  - the point-estimate line  : a dark-grey (0.19) stroked polyline, 25 vertices
  - the 95% CI band          : a light-grey (0.89) filled polygon, 25 up/25 down

We map device coordinates to data units using the printed axis ticks, then
assert the recovered values match the two figures quoted in the paper text
(+0.51 at month 0, +0.22 at month +1) so a silently-broken extraction fails loud.

Run (from the paper's data-viz/ folder):
    python3 code/extract-fig3a.py
    -> writes data/fig3a-estimates.csv   (gitignored; regenerate locally)

Deps: PyMuPDF (`pip install pymupdf`). Needs the source PDF, which is gitignored
and kept only locally.
"""
import csv
import os
from collections import defaultdict

import fitz  # PyMuPDF

HERE = os.path.dirname(os.path.abspath(__file__))
PAPER_DIR = os.path.normpath(os.path.join(HERE, "..", ".."))
PDF = os.path.join(PAPER_DIR, "Citizen_Complaint_Paper.pdf")
OUT = os.path.join(HERE, "..", "data", "fig3a-estimates.csv")

PAGE = 47  # page 48, the four-panel Figure 3

# --- axis calibration (device coords, panel a = top-left quadrant) ----
# x: month ticks are evenly spaced; month 0 sits at x = 201.63, 8.042 px/month.
# y: seven printed y-ticks give value = (Y0 - y) / PPU, 0 at y = 311.77.
X0, DX = 201.63, 8.042
Y0, PPU = 311.77, 115.23


def month(x):
    return (x - X0) / DX


def value(y):
    return (Y0 - y) / PPU


def path_points(drawing):
    pts = []
    for item in drawing["items"]:
        for p in item[1:]:
            if hasattr(p, "x"):
                pts.append((p.x, p.y))
    return pts


def main():
    doc = fitz.open(PDF)
    draws = doc[PAGE].get_drawings()

    est_path = band_path = None
    for d in draws:
        r = d["rect"]
        cx, cy = (r.x0 + r.x1) / 2, (r.y0 + r.y1) / 2
        if not (95 < cx < 305 and 232 < cy < 318):  # panel (a) quadrant
            continue
        if d["type"] == "s" and d["color"] and abs(d["color"][0] - 0.19) < 0.03 \
                and len(d["items"]) > 10:
            est_path = d
        if d["type"] == "fs" and d["fill"] and abs(d["fill"][0] - 0.89) < 0.03:
            band_path = d
    if est_path is None or band_path is None:
        raise SystemExit("could not locate the estimate line / CI band on page 48")

    # estimate line: one vertex per month
    est_by_m = {}
    for x, y in sorted(path_points(est_path)):
        est_by_m[round(month(x))] = value(y)

    # CI polygon: many y at each month -> min/max are the bounds
    band = defaultdict(list)
    for x, y in path_points(band_path):
        band[round(month(x))].append(value(y))

    rows = []
    for m in range(-12, 13):
        ys = band.get(m, [])
        rows.append({
            "month": m,
            "estimate": round(est_by_m[m], 4),
            "ci_low": round(min(ys), 4),
            "ci_high": round(max(ys), 4),
        })

    # fail loud if the recovery drifts from the paper's quoted values
    got0, got1 = est_by_m[0], est_by_m[1]
    assert abs(got0 - 0.51) < 0.01, f"month 0 = {got0:.3f}, expected ~0.51"
    assert abs(got1 - 0.22) < 0.01, f"month 1 = {got1:.3f}, expected ~0.22"

    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["month", "estimate", "ci_low", "ci_high"])
        w.writeheader()
        w.writerows(rows)
    print(f"wrote {os.path.relpath(OUT, PAPER_DIR)}  "
          f"(validated: month0={got0:.3f}, month1={got1:.3f})")


if __name__ == "__main__":
    main()
