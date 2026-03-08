import 'package:bento_layout/bento_layout.dart';
import 'package:bento_layout/src/layout/skyline_packing.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Builds a [BentoItem] with a placeholder child for testing.
BentoItem item(BentoItemSize size) =>
    BentoItem(size: size, child: const SizedBox.shrink());

/// Runs [SkylinePacking.pack] with a fixed [totalWidth] and [unitHeight].
///
/// Defaults: totalWidth = 400, unitHeight = 100.
Map<int, SliverGridGeometry> pack(
  List<BentoItem> items, {
  double totalWidth = 400,
  double unitHeight = 100,
  BentoSizingStrategy? strategy,
}) {
  return SkylinePacking.pack(
    items: items,
    totalWidth: totalWidth,
    unitHeight: unitHeight,
    strategy: strategy,
  ).geometryMap;
}

double totalHeight(
  List<BentoItem> items, {
  double totalWidth = 400,
  double unitHeight = 100,
}) {
  return SkylinePacking.pack(
    items: items,
    totalWidth: totalWidth,
    unitHeight: unitHeight,
  ).totalHeight;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // Empty list
  // -------------------------------------------------------------------------

  group('empty item list', () {
    test('returns empty geometry map', () {
      final result = SkylinePacking.pack(
        items: [],
        totalWidth: 400,
        unitHeight: 100,
      );
      expect(result.geometryMap, isEmpty);
    });

    test('returns totalHeight of 0', () {
      final result = SkylinePacking.pack(
        items: [],
        totalWidth: 400,
        unitHeight: 100,
      );
      expect(result.totalHeight, 0);
    });
  });

  // -------------------------------------------------------------------------
  // Single item
  // -------------------------------------------------------------------------

  group('single item', () {
    test('is placed at origin (0, 0)', () {
      final geo = pack([item(BentoItemSize.halfCard)]);
      expect(geo[0]!.scrollOffset, 0);
      expect(geo[0]!.crossAxisOffset, 0);
    });

    test('halfCard has correct pixel dimensions at totalWidth=400, unitHeight=100', () {
      final geo = pack([item(BentoItemSize.halfCard)]);
      // widthFraction=0.5 → 200px, heightSpan=1.0 → 100px
      expect(geo[0]!.crossAxisExtent, 200);
      expect(geo[0]!.mainAxisExtent, 100);
    });

    test('fullTower has correct pixel dimensions', () {
      final geo = pack([item(BentoItemSize.fullTower)]);
      // widthFraction=1.0 → 400px, heightSpan=2.0 → 200px
      expect(geo[0]!.crossAxisExtent, 400);
      expect(geo[0]!.mainAxisExtent, 200);
    });

    test('quarterBar has correct pixel dimensions', () {
      final geo = pack([item(BentoItemSize.quarterBar)]);
      // widthFraction=0.25 → 100px, heightSpan=0.5 → 50px
      expect(geo[0]!.crossAxisExtent, 100);
      expect(geo[0]!.mainAxisExtent, 50);
    });
  });

  // -------------------------------------------------------------------------
  // All fullTower — must stack vertically
  // -------------------------------------------------------------------------

  group('all fullTower tiles', () {
    test('stack vertically in a single column', () {
      // totalWidth=400, unitHeight=100 → each fullTower is 400×200px
      final geo = pack([
        item(BentoItemSize.fullTower),
        item(BentoItemSize.fullTower),
        item(BentoItemSize.fullTower),
      ]);

      // All at x=0
      expect(geo[0]!.crossAxisOffset, 0);
      expect(geo[1]!.crossAxisOffset, 0);
      expect(geo[2]!.crossAxisOffset, 0);

      // y positions: 0, 200, 400
      expect(geo[0]!.scrollOffset, 0);
      expect(geo[1]!.scrollOffset, 200);
      expect(geo[2]!.scrollOffset, 400);
    });

    test('total height equals sum of all tile heights', () {
      final h = totalHeight([
        item(BentoItemSize.fullTower),
        item(BentoItemSize.fullTower),
      ]);
      // 2 × 200px = 400px
      expect(h, 400);
    });
  });

  // -------------------------------------------------------------------------
  // All quarterBar — must fill rows of 4
  // -------------------------------------------------------------------------

  group('all quarterBar tiles', () {
    test('first four fill a single row side by side', () {
      // totalWidth=400, unitHeight=100
      // quarterBar: widthFraction=0.25 → 100px wide, heightSpan=0.5 → 50px tall
      final geo = pack(List.generate(4, (_) => item(BentoItemSize.quarterBar)));

      // All in the same row (y=0)
      for (int i = 0; i < 4; i++) {
        expect(geo[i]!.scrollOffset, 0, reason: 'tile $i should be at y=0');
        expect(geo[i]!.crossAxisOffset, i * 100.0,
            reason: 'tile $i should be at x=${i * 100}');
      }
    });

    test('fifth tile starts a new row', () {
      final geo = pack(List.generate(5, (_) => item(BentoItemSize.quarterBar)));
      expect(geo[4]!.scrollOffset, 50); // second row starts at y=50
      expect(geo[4]!.crossAxisOffset, 0);
    });

    test('8 tiles fill exactly 2 rows', () {
      final h = totalHeight(
        List.generate(8, (_) => item(BentoItemSize.quarterBar)),
      );
      expect(h, 100); // 2 rows × 50px
    });
  });

  // -------------------------------------------------------------------------
  // Mixed sizes — no overlap
  // -------------------------------------------------------------------------

  group('mixed sizes — overlap detection', () {
    test('no two tiles overlap', () {
      final items = [
        item(BentoItemSize.fullBar),
        item(BentoItemSize.halfTower),
        item(BentoItemSize.halfTower),
        item(BentoItemSize.fullCard),
        item(BentoItemSize.halfCard),
        item(BentoItemSize.halfBar),
        item(BentoItemSize.quarterCard),
        item(BentoItemSize.quarterCard),
        item(BentoItemSize.quarterCard),
        item(BentoItemSize.quarterCard),
      ];

      final geo = pack(items, totalWidth: 400, unitHeight: 100);

      // For every pair of tiles, verify they do not overlap.
      for (int a = 0; a < items.length; a++) {
        for (int b = a + 1; b < items.length; b++) {
          final ga = geo[a]!;
          final gb = geo[b]!;

          final aLeft   = ga.crossAxisOffset;
          final aRight  = ga.crossAxisOffset + ga.crossAxisExtent;
          final aTop    = ga.scrollOffset;
          final aBottom = ga.scrollOffset + ga.mainAxisExtent;

          final bLeft   = gb.crossAxisOffset;
          final bRight  = gb.crossAxisOffset + gb.crossAxisExtent;
          final bTop    = gb.scrollOffset;
          final bBottom = gb.scrollOffset + gb.mainAxisExtent;

          final xOverlap = aLeft < bRight && aRight > bLeft;
          final yOverlap = aTop < bBottom && aBottom > bTop;

          expect(
            xOverlap && yOverlap,
            isFalse,
            reason: 'tiles $a and $b overlap\n'
                '  tile $a: x=$aLeft–$aRight  y=$aTop–$aBottom\n'
                '  tile $b: x=$bLeft–$bRight  y=$bTop–$bBottom',
          );
        }
      }
    });

    test('fullBar followed by two halfCards fills one row neatly', () {
      // totalWidth=400, unitHeight=100
      // fullBar:  400×50px  (y=0)
      // halfCard: 200×100px (y=50, x=0 and x=200)
      final geo = pack([
        item(BentoItemSize.fullBar),
        item(BentoItemSize.halfCard),
        item(BentoItemSize.halfCard),
      ]);

      expect(geo[0]!.scrollOffset, 0);
      expect(geo[0]!.crossAxisOffset, 0);
      expect(geo[0]!.crossAxisExtent, 400);

      expect(geo[1]!.scrollOffset, 50);
      expect(geo[1]!.crossAxisOffset, 0);

      expect(geo[2]!.scrollOffset, 50);
      expect(geo[2]!.crossAxisOffset, 200);
    });
  });

  // -------------------------------------------------------------------------
  // Custom sizing strategy
  // -------------------------------------------------------------------------

  group('custom BentoSizingStrategy', () {
    test('custom strategy dimensions are respected', () {
      // Override halfCard to be full width
      final strategy = _FullWidthHalfCardStrategy();
      final geo = pack(
        [item(BentoItemSize.halfCard)],
        strategy: strategy,
      );
      // Custom strategy returns widthFraction=1.0 for halfCard → 400px wide
      expect(geo[0]!.crossAxisExtent, 400);
    });
  });

  // -------------------------------------------------------------------------
  // BentoGridDelegate.shouldRelayout
  // -------------------------------------------------------------------------

  group('BentoGridDelegate.shouldRelayout', () {
    test('returns true when items list changes', () {
      final itemsA = [item(BentoItemSize.halfCard)];
      final itemsB = [item(BentoItemSize.halfCard), item(BentoItemSize.halfCard)];

      final delegateA = BentoGridDelegate(items: itemsA, unitHeight: 100);
      final delegateB = BentoGridDelegate(items: itemsB, unitHeight: 100);

      expect(delegateA.shouldRelayout(delegateB), isTrue);
    });

    test('returns true when unitHeight changes', () {
      final items = [item(BentoItemSize.halfCard)];
      final delegateA = BentoGridDelegate(items: items, unitHeight: 100);
      final delegateB = BentoGridDelegate(items: items, unitHeight: 180);

      expect(delegateA.shouldRelayout(delegateB), isTrue);
    });

    test('returns false when items and unitHeight are identical', () {
      final items = [item(BentoItemSize.halfCard)];
      final delegateA = BentoGridDelegate(items: items, unitHeight: 100);
      final delegateB = BentoGridDelegate(items: items, unitHeight: 100);

      expect(delegateA.shouldRelayout(delegateB), isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // BentoDimension assertion
  // -------------------------------------------------------------------------

  group('BentoDimension', () {
    test('throws assertion for widthFraction = 0', () {
      expect(
        () => BentoDimension(widthFraction: 0, heightSpan: 1.0),
        throwsAssertionError,
      );
    });

    test('throws assertion for widthFraction > 1', () {
      expect(
        () => BentoDimension(widthFraction: 1.5, heightSpan: 1.0),
        throwsAssertionError,
      );
    });

    test('accepts widthFraction = 1.0', () {
      expect(
        () => const BentoDimension(widthFraction: 1.0, heightSpan: 1.0),
        returnsNormally,
      );
    });
  });
}

// ---------------------------------------------------------------------------
// Test doubles
// ---------------------------------------------------------------------------

class _FullWidthHalfCardStrategy implements BentoSizingStrategy {
  @override
  BentoDimension getDimensions(BentoItemSize size) {
    if (size == BentoItemSize.halfCard) {
      return const BentoDimension(widthFraction: 1.0, heightSpan: 1.0);
    }
    return const DefaultBentoSizingStrategy().getDimensions(size);
  }
}
