import 'dart:math' as math;
import 'package:flutter/material.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  static const double designW = 1920;
  static const double designH = 1200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: designW,
              height: designH,
              child: Stack(
                children: [
                  // Turquoise frame + felt
                  Positioned.fill(child: _BoardBackground()),

                  // Top title bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 90,
                    child: _TopTitleBar(title: 'Computer 1'),
                  ),

                  // Left rail (name + vertical tiles)
                  Positioned(
                    top: 90,
                    left: 0,
                    bottom: 0,
                    width: 140,
                    child: _SideRail(
                      label: 'linda (2025)',
                      tiles: const ['tile_back', 'tile_back', 'tile_back'],
                      rotateTiles: true,
                      labelOnLeft: true,
                    ),
                  ),

                  // Right rail
                  Positioned(
                    top: 90,
                    right: 0,
                    bottom: 0,
                    width: 140,
                    child: _SideRail(
                      label: 'carol (100)',
                      tiles: const ['tile_back', 'tile_back', 'tile_back', 'joker'],
                      rotateTiles: true,
                      labelOnLeft: false,
                    ),
                  ),

                  // Top tiles area (two rows like screenshot)
                  Positioned(
                    top: 110,
                    left: 160,
                    right: 160,
                    height: 220,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 110,
                          child: _TileRow(
                            tiles: const ['1c', '1c', '1c', 'joker'],
                            tileWidth: 90,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: _TileRow(
                            tiles: List.generate(24, (i) => 'random_$i'),
                            tileWidth: 70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center felt area (blue rectangle)
                  Positioned(
                    top: 340,
                    left: 160,
                    right: 160,
                    height: 380,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF3D5972),
                        border: Border.all(color: Colors.black, width: 6),
                      ),
                    ),
                  ),

                  // Action buttons
                  Positioned(
                    top: 470,
                    left: 160,
                    right: 160,
                    height: 140,
                    child: _ActionButtonsRow(),
                  ),

                  // Status bar + icons
                  Positioned(
                    left: 160,
                    right: 160,
                    bottom: 240,
                    height: 70,
                    child: _StatusBar(),
                  ),

                  // Bottom exposed row (purple strip)
                  Positioned(
                    left: 160,
                    right: 160,
                    bottom: 170,
                    height: 70,
                    child: Container(
                      color: const Color(0xFF9A63FF),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _TileRow(
                          tiles: const ['8d', '8d', '8d', 'joker'],
                          tileWidth: 80,
                        ),
                      ),
                    ),
                  ),

                  // Bottom hand (big purple)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 60,
                    height: 110,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 140),
                      color: const Color(0xFF9A63FF),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _TileRow(
                          tiles: const ['flower', '2c', '2c', '4c', '4c', '6d', '6d', '6d', 'joker'],
                          tileWidth: 90,
                        ),
                      ),
                    ),
                  ),

                  // Bottom player label
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 10,
                    height: 40,
                    child: const Center(
                      child: Text(
                        'marilyn (4370)',
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BoardBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00E6E6),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(
          color: const Color(0xFF3D5972),
        ),
      ),
    );
  }
}

class _TopTitleBar extends StatelessWidget {
  final String title;
  const _TopTitleBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 34),
      ),
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget btn(String text, {required bool enabled, Color? color}) {
      return SizedBox(
        width: 260,
        height: 110,
        child: ElevatedButton(
          onPressed: enabled ? () {} : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            disabledBackgroundColor: const Color(0xFFBFBFBF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: enabled ? 8 : 0,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 44,
              color: enabled ? Colors.white : const Color(0xFFE0E0E0),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        btn('Pick', enabled: true, color: Colors.red),
        btn('Skip', enabled: false),
        btn('Call', enabled: false),
        btn('Mahj', enabled: true, color: const Color(0xFF5B5E9C)),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F2E2A),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.check_box_outline_blank, color: Colors.white),
          const SizedBox(width: 10),
          const Text('48 tiles left', style: TextStyle(color: Colors.white, fontSize: 32)),
          const Spacer(),
          const Text('Pick a tile', style: TextStyle(color: Colors.white, fontSize: 32)),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.swap_horiz, color: Colors.white)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline, color: Colors.white)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.white)),
        ],
      ),
    );
  }
}

class _SideRail extends StatelessWidget {
  final String label;
  final List<String> tiles;
  final bool rotateTiles;
  final bool labelOnLeft;

  const _SideRail({
    required this.label,
    required this.tiles,
    required this.rotateTiles,
    required this.labelOnLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00E6E6),
      child: Stack(
        children: [
          // Vertical label bar
          Positioned.fill(
            child: Align(
              alignment: labelOnLeft ? Alignment.centerLeft : Alignment.centerRight,
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 34),
                ),
              ),
            ),
          ),
          // Tiles stack near top like screenshot
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Column(
              children: tiles
                  .map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TileCard(
                  assetKey: t,
                  width: 90,
                  rotated: rotateTiles,
                ),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TileRow extends StatelessWidget {
  final List<String> tiles;
  final double tileWidth;
  const _TileRow({required this.tiles, required this.tileWidth});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: tiles.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, i) => TileCard(assetKey: tiles[i], width: tileWidth),
    );
  }
}

class TileCard extends StatelessWidget {
  final String assetKey;
  final double width;
  final bool rotated;

  const TileCard({
    super.key,
    required this.assetKey,
    required this.width,
    this.rotated = false,
  });

  @override
  Widget build(BuildContext context) {
    // Replace this placeholder with Image.asset('assets/tiles/$assetKey.png')
    final tile = Container(
      width: width,
      height: width * 1.25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(assetKey, style: const TextStyle(fontSize: 18)),
    );

    if (!rotated) return tile;

    return Transform.rotate(
      angle: math.pi / 2,
      child: tile,
    );
  }
}
