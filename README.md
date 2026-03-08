# bento_layout

A Flutter package for building bento-style grid layouts using the **skyline bin-packing algorithm**. Tiles of varying sizes are packed without overlap or unnecessary gaps. Width fills the available space exactly; height is stable across all screen sizes.

---

## Features

- **9 named tile sizes** — `quarterBar`, `halfCard`, `fullTower` etc. Names encode both dimensions so no docs needed
- **No column count** — tile widths are fractions of total width, adapting to any screen automatically
- **Stable heights** — a fixed `unitHeight` decouples height from width so tiles don't grow or shrink with screen size
- **Composable** — use `BentoGrid` for simple cases or `BentoGridDelegate` to embed the grid in your own `CustomScrollView`
- **Extensible** — implement `BentoSizingStrategy` to override tile dimensions without touching the algorithm

---

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  bento_layout: ^0.1.0
```

---

## Usage

### Basic — BentoGrid

```dart
import 'package:bento_layout/bento_layout.dart';

BentoGrid(
  unitHeight: 180,
  items: [
    BentoItem(
      size: BentoItemSize.fullTower,
      child: MyHeroTile(),
    ),
    BentoItem(
      size: BentoItemSize.halfCard,
      child: MyLinkTile(),
    ),
    BentoItem(
      size: BentoItemSize.halfCard,
      child: MyLinkTile(),
    ),
    BentoItem(
      size: BentoItemSize.fullBar,
      child: MySectionTitle('Projects'),
    ),
    BentoItem(
      size: BentoItemSize.halfTower,
      child: MyProjectTile(),
    ),
    BentoItem(
      size: BentoItemSize.halfTower,
      child: MyProjectTile(),
    ),
  ],
)
```

### Advanced — BentoGridDelegate

Use `BentoGridDelegate` directly when you need to compose the grid alongside other slivers in your own `CustomScrollView` — for example, a profile header that scrolls with the grid.

```dart
import 'package:bento_layout/bento_layout.dart';

final List<BentoItem> items = myTiles
    .map((t) => BentoItem(size: t.bentoSize, child: MyTile(config: t)))
    .toList();

CustomScrollView(
  slivers: [
    const SliverToBoxAdapter(child: MyProfileHeader()),
    const SliverToBoxAdapter(child: SizedBox(height: 20)),
    SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: BentoGridDelegate(
          items: items,
          unitHeight: 180,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => items[index].child,
          childCount: items.length,
        ),
      ),
    ),
  ],
)
```

> **Note:** Do not nest `BentoGrid` inside another `CustomScrollView` — it manages its own scroll view internally. Use `BentoGridDelegate` + `SliverGrid` instead.

### Custom sizing strategy

```dart
class TabletSizingStrategy implements BentoSizingStrategy {
  const TabletSizingStrategy();

  @override
  BentoDimension getDimensions(BentoItemSize size) {
    return switch (size) {
      BentoItemSize.halfTower => const BentoDimension(widthFraction: 0.5, heightSpan: 1.5),
      BentoItemSize.fullTower => const BentoDimension(widthFraction: 1.0, heightSpan: 1.5),
      _ => const DefaultBentoSizingStrategy().getDimensions(size),
    };
  }
}

BentoGrid(
  items: items,
  strategy: const TabletSizingStrategy(),
)
```

---

## Tile sizes

| BentoItemSize | Width | Height (unitHeight=180) |
|---|---|---|
| `quarterBar` | 25% | 90px |
| `quarterCard` | 25% | 180px |
| `quarterTower` | 25% | 360px |
| `halfBar` | 50% | 90px |
| `halfCard` | 50% | 180px |
| `halfTower` | 50% | 360px |
| `fullBar` | 100% | 90px |
| `fullCard` | 100% | 180px |
| `fullTower` | 100% | 360px |

Width is always a fraction of the total available grid width. Height is always a multiple of `unitHeight`.

---

## BentoGrid parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `items` | `List<BentoItem>` | required | Tiles to display |
| `unitHeight` | `double` | `180.0` | Height of one row unit in pixels |
| `strategy` | `BentoSizingStrategy?` | `null` | Custom sizing strategy |
| `padding` | `EdgeInsetsGeometry?` | `null` | Padding around the grid |
| `physics` | `ScrollPhysics?` | `null` | Scroll physics |
| `primary` | `bool?` | `null` | Whether this is the primary scroll view |
| `shrinkWrap` | `bool` | `false` | Whether to shrink-wrap content |

---

## Additional information

- See the `example/` directory for a runnable demo
- The algorithm is documented in detail in the package source — see `src/layout/skyline_packing.dart`
- To report issues or contribute, visit the project repository


Built with ❤️ by ([text](https://builtbysid.dev/))