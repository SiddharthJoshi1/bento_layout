import 'package:bento_layout/bento_layout.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BentoLayoutExampleApp());
}

class BentoLayoutExampleApp extends StatelessWidget {
  const BentoLayoutExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bento_layout example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const BentoExamplePage(),
    );
  }
}

class BentoExamplePage extends StatelessWidget {
  const BentoExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: BentoGrid(
          padding: const EdgeInsets.all(12),
          unitHeight: 180,
          items: [
            // Full-width hero
            BentoItem(
              size: BentoItemSize.fullTower,
              child: _Tile(
                label: 'fullTower\n1.0 × 2.0',
                color: const Color(0xFF0D0D0D),
              ),
            ),
        
            // Two half-towers side by side
            BentoItem(
              size: BentoItemSize.halfTower,
              child: _Tile(
                label: 'halfTower\n0.5 × 2.0',
                color: const Color(0xFF1A1A2E),
              ),
            ),
            BentoItem(
              size: BentoItemSize.halfTower,
              child: _Tile(
                label: 'halfTower\n0.5 × 2.0',
                color: const Color(0xFF16213E),
              ),
            ),
        
            // Full-width section bar
            BentoItem(
              size: BentoItemSize.fullBar,
              child: _Tile(
                label: 'fullBar  1.0 × 0.5',
                color: const Color(0xFFE94560),
              ),
            ),
        
            // Two half-cards
            BentoItem(
              size: BentoItemSize.halfCard,
              child: _Tile(
                label: 'halfCard\n0.5 × 1.0',
                color: const Color(0xFF533483),
              ),
            ),
            BentoItem(
              size: BentoItemSize.halfCard,
              child: _Tile(
                label: 'halfCard\n0.5 × 1.0',
                color: const Color(0xFF6B2D8B),
              ),
            ),
        
            // Full-width card
            BentoItem(
              size: BentoItemSize.fullCard,
              child: _Tile(
                label: 'fullCard  1.0 × 1.0',
                color: const Color(0xFF0F3460),
              ),
            ),
        
            // Two half-bars
            BentoItem(
              size: BentoItemSize.halfBar,
              child: _Tile(
                label: 'halfBar  0.5 × 0.5',
                color: const Color(0xFFC84B31),
              ),
            ),
            BentoItem(
              size: BentoItemSize.halfBar,
              child: _Tile(
                label: 'halfBar  0.5 × 0.5',
                color: const Color(0xFFD4622A),
              ),
            ),
        
            // Four quarter-cards
            BentoItem(
              size: BentoItemSize.quarterCard,
              child: _Tile(
                label: 'qCard\n0.25×1',
                color: const Color(0xFF1B4F72),
              ),
            ),
            BentoItem(
              size: BentoItemSize.quarterCard,
              child: _Tile(
                label: 'qCard\n0.25×1',
                color: const Color(0xFF2874A6),
              ),
            ),
            BentoItem(
              size: BentoItemSize.quarterCard,
              child: _Tile(
                label: 'qCard\n0.25×1',
                color: const Color(0xFF3498DB),
              ),
            ),
            BentoItem(
              size: BentoItemSize.quarterCard,
              child: _Tile(
                label: 'qCard\n0.25×1',
                color: const Color(0xFF7FB3D3),
              ),
            ),
        
            // Four quarter-bars
            BentoItem(
              size: BentoItemSize.quarterBar,
              child: _Tile(label: 'qBar', color: const Color(0xFF7D6608)),
            ),
            BentoItem(
              size: BentoItemSize.quarterBar,
              child: _Tile(label: 'qBar', color: const Color(0xFFB7950B)),
            ),
            BentoItem(
              size: BentoItemSize.quarterBar,
              child: _Tile(label: 'qBar', color: const Color(0xFFD4AC0D)),
            ),
            BentoItem(
              size: BentoItemSize.quarterBar,
              child: _Tile(label: 'qBar', color: const Color(0xFFF1C40F)),
            ),
        
            // Four quarter-towers
            BentoItem(
              size: BentoItemSize.quarterTower,
              child: _Tile(
                label: 'qTower\n0.25×2',
                color: const Color(0xFF2B580C),
              ),
            ),
            BentoItem(
              size: BentoItemSize.quarterTower,
              child: _Tile(
                label: 'qTower\n0.25×2',
                color: const Color(0xFF379237),
              ),
            ),
            BentoItem(
              size: BentoItemSize.quarterTower,
              child: _Tile(
                label: 'qTower\n0.25×2',
                color: const Color(0xFF54C254),
              ),
            ),
            BentoItem(
              size: BentoItemSize.quarterTower,
              child: _Tile(
                label: 'qTower\n0.25×2',
                color: const Color(0xFF82CD47),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple labelled tile used throughout the example.
class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Pick white or black text based on background luminance.
    final textColor = color.computeLuminance() > 0.35
        ? Colors.black87
        : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
