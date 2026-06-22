# Assignment 3 Practical

Use this folder for the Part 2 practical section.

## Person 1

The Octave ABM engine is a single file: `code/main.m`.

Run it with GNU Octave:

```bash
cd code
octave main.m
```

This generates CSV files in `results/`:

- Four scenario opinion histories.
- Four average opinion histories.
- Four final opinion files.
- Network adjacency files for optional visualization.
- `scenario_summary.csv` for report comparison.

It also opens one Octave figure per scenario. Each figure contains:

- 2D average opinion over time.
- 2D individual citizen opinions over time.
- 3D temporal opinion plot.
- Final opinion histogram.

The script is fully inline with no custom helper function files required.

## Person 2

Work only in `gui/index.html` for the single-file HTML GUI. Put the HTML, CSS, and JavaScript in that one file so it can be published easily using GitHub Pages.

## Person 3

Work in `report/Assignment03_Report.md` and `report/analysis_summary.md` for the report and analysis.
