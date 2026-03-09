# Changelog

All notable changes to this package are documented here.
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## 0.1.1

### Changed

- Updated README with example screenshots and demo GIFs

---

## 0.1.0

Initial release.

### Added

- `BentoGrid` — drop-in scrollable grid widget powered by the skyline algorithm
- `BentoItem` — tile wrapper accepting any `Widget` child and a `BentoItemSize`
- `BentoItemSize` — 9-value enum encoding both width and height in a self-documenting name (`quarterBar`, `halfCard`, `fullTower` etc.)
- `BentoDimension` — resolved tile dimensions as `widthFraction` + `heightSpan`
- `BentoSizingStrategy` — abstract interface for custom size mappings
- `DefaultBentoSizingStrategy` — built-in 3×3 size matrix (quarter/half/full × Bar/Card/Tower)
- `BentoGridDelegate` — exported `SliverGridDelegate` for composing the grid into custom `CustomScrollView` scroll views alongside other slivers

### Design decisions

- Tile widths expressed as fractions of total width — no column count required
- Tile heights use a fixed `unitHeight` (default `180px`) decoupled from width — heights are consistent across all screen sizes
- Skyline slot granularity derived automatically from the smallest `widthFraction` present in the item list
- Greedy bin-packing — items are placed at the lowest available position in order, preserving intentional tile sequence
