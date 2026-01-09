import 'dart:math' as math;
import 'package:flutter/material.dart';

class PortraitMahjongTableScreen extends StatelessWidget {
  const PortraitMahjongTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data (your filenames)
    final topName = "COMPUTER 3";
    final leftName = "COMPUTER 1";
    final rightName = "COMPUTER 2";
    final bottomName = "KRUTIK123123 (10)";

    final topRack = ["char_2.png", "char_2.png", "char_2.png", "joker.png"];

    final topGrid = [
      "circle_1.png","circle_9.png","char_2.png","dragon_red.png",
      "circle_3.png","dragon_green.png","flower_1.png","circle_7.png",
      "char_7.png","wind_noth.png","dragon_white.png","bamboo_1.png",
      "bamboo_2.png","wind_west.png","flower_3.png","circle_9.png",
      "circle_3.png","circle_4.png","circle_6.png","char_8.png",
      "char_9.png","wind_east.png","wind_suth.png",
    ];

    final leftRailTiles  = ["circle_1.png","circle_1.png","circle_1.png","circle_1.png","joker.png"];
    final rightRailTiles = ["dragon_green.png","dragon_green.png","dragon_red.png","dragon_red.png","dragon_red.png"];

    final bottomHand = [
      "wind_suth.png","wind_east.png","wind_east.png","wind_west.png","wind_noth.png",
      "char_7.png","char_8.png","char_6.png","char_9.png",
      "circle_3.png","circle_4.png","circle_9.png","circle_6.png"
    ];

    final bottomMelds = <String>[];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;

            const outerPad = 10.0;

            // Black vertical label strips (outside turquoise frame)
            final labelStripW = (w * 0.07).clamp(22.0, 34.0);

            // Turquoise rails (inside frame) width
            final railW = (w * 0.12).clamp(58.0, 90.0);

            // Inner playable width (inside turquoise frame, excluding outer black strips)
            final innerW = w - outerPad * 2 - labelStripW * 2;

            // Center region width between rails (felt/controls/status live here)
            final centerW = innerW - railW * 2;

            // Tile sizing based on center width
            final tileW = (centerW / 13).clamp(30.0, 50.0);
            final tileH = tileW * 1.28;

            final rackTileW = tileW * 1.05;
            final rackTileH = rackTileW * 1.28;

            final gridTileW = tileW * 0.95;
            final gridTileH = gridTileW * 1.28;

            // Fixed-ish UI heights, but small and safe. Big space uses Expanded.
            final topNameH = 28.0;
            final rackH = rackTileH + 14;

            final controlsH = (h * 0.075).clamp(54.0, 72.0);
            final statusH   = (h * 0.07).clamp(52.0, 68.0);

            final meldsH = (h * 0.075).clamp(54.0, 80.0);
            final handH  = (h * 0.11).clamp(90.0, 135.0);
            final bottomNameH = 26.0;

            return Padding(
              padding: const EdgeInsets.all(outerPad),
              child: Row(
                children: [
                  _VerticalNameStrip(width: labelStripW, text: leftName),

                  // TURQUOISE FRAME AREA (everything inside)
                  SizedBox(
                    width: innerW,
                    child: Container(
                      color: const Color(0xFF00E6E6),
                      child: Column(
                        children: [
                          // 1) Top name (full width)
                          SizedBox(
                            height: topNameH,
                            child: Center(
                              child: Text(
                                topName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          // 2) Top rack (full width)
                          SizedBox(
                            height: rackH,
                            child: Container(
                              color: const Color(0xFF00E6E6),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: _TileRow(
                                tiles: topRack,
                                tileW: rackTileW,
                                tileH: rackTileH,
                                spacing: 6,
                              ),
                            ),
                          ),

                          // 3) RAILS REGION (starts AFTER topRack, ends BEFORE bottom meld/hand)
                          Expanded(
                            child: Column(
                              children: [
                                // 3a) Tiles + felt area (rails visible here)
                                Expanded(
                                  child: Row(
                                    children: [
                                      // Left rail tiles area
                                      SizedBox(
                                        width: railW,
                                        child: _RailTiles(
                                          tiles: leftRailTiles,
                                          maxTileW: railW * 0.78,
                                          aspect: 1.22,
                                          topPadding: 8,
                                          spacing: 10,
                                        ),
                                      ),

                                      // Center felt with grid at top
                                      Expanded(
                                        child: Container(
                                          color: const Color(0xFF3D5972),
                                          child: Column(
                                            children: [
                                              // Grid at the top (bounded height so it never overflows)
                                              SizedBox(
                                                height: (h * 0.28).clamp(170.0, 260.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(6),
                                                  child: _TileGrid(
                                                    tiles: topGrid,
                                                    tileW: gridTileW,
                                                    tileH: gridTileH,
                                                    spacing: 6,
                                                  ),
                                                ),
                                              ),
                                              // Rest is empty felt
                                              const Expanded(child: SizedBox()),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Right rail tiles area
                                      SizedBox(
                                        width: railW,
                                        child: _RailTiles(
                                          tiles: rightRailTiles,
                                          maxTileW: railW * 0.78,
                                          aspect: 1.22,
                                          topPadding: 8,
                                          spacing: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 3b) Controls row (rails background visible left/right, center holds buttons)
                                SizedBox(
                                  height: controlsH,
                                  child: Row(
                                    children: [
                                      SizedBox(width: railW),
                                      const Expanded(child: _ControlsRow()),
                                      SizedBox(width: railW),
                                    ],
                                  ),
                                ),

                                // 3c) Status bar (same: turquoise margins + center bar)
                                SizedBox(
                                  height: statusH,
                                  child: Row(
                                    children: [
                                      SizedBox(width: railW),
                                      const Expanded(
                                        child: _StatusBar(
                                          leftText: "42 tiles left",
                                          centerText: "Pick a tile",
                                        ),
                                      ),
                                      SizedBox(width: railW),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 4) Bottom melds (FULL WIDTH, rails are finished above)
                          SizedBox(
                            height: meldsH,
                            child: _PurpleStrip(
                              child: bottomMelds.isEmpty
                                  ? const SizedBox()
                                  : _TileRow(
                                tiles: bottomMelds,
                                tileW: tileW,
                                tileH: tileH,
                                spacing: 6,
                              ),
                            ),
                          ),

                          // 5) Bottom hand (FULL WIDTH)
                          SizedBox(
                            height: handH,
                            child: _PurpleStrip(
                              child: _TileRow(
                                tiles: bottomHand,
                                tileW: tileW,
                                tileH: tileH,
                                spacing: 6,
                              ),
                            ),
                          ),

                          // 6) Bottom name (FULL WIDTH)
                          SizedBox(
                            height: bottomNameH,
                            child: Center(
                              child: Text(
                                bottomName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  _VerticalNameStrip(width: labelStripW, text: rightName, rotateOpposite: true),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Black vertical strip with rotated player name
class _VerticalNameStrip extends StatelessWidget {
  final double width;
  final String text;
  final bool rotateOpposite;

  const _VerticalNameStrip({
    required this.width,
    required this.text,
    this.rotateOpposite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: Colors.black,
      child: Center(
        child: RotatedBox(
          quarterTurns: rotateOpposite ? 1 : 3,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1.0),
          ),
        ),
      ),
    );
  }
}

/// Rail tile column that auto-scales to avoid vertical overflow.
class _RailTiles extends StatelessWidget {
  final List<String> tiles;
  final double maxTileW;
  final double aspect; // tileH = tileW * aspect
  final double topPadding;
  final double spacing;

  const _RailTiles({
    required this.tiles,
    required this.maxTileW,
    required this.aspect,
    required this.topPadding,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00E6E6),
      child: LayoutBuilder(
        builder: (context, c) {
          final n = tiles.length;
          final availH = (c.maxHeight - topPadding).clamp(0.0, double.infinity);

          // Compute tile size that fits the available height.
          final desiredW = maxTileW;
          final desiredH = desiredW * aspect;
          final neededH = (desiredH * n) + (spacing * math.max(0, n - 1));

          double tileW = desiredW;
          double tileH = desiredH;

          if (neededH > availH && availH > 0) {
            final fitH = (availH - spacing * math.max(0, n - 1)) / n;
            tileH = fitH.clamp(10.0, desiredH);
            tileW = (tileH / aspect).clamp(10.0, desiredW);
          }

          return Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < tiles.length; i++) ...[
                  _Tile(tiles[i], w: tileW, h: tileH, rotateVertical: true),
                  if (i != tiles.length - 1) SizedBox(height: spacing),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ControlsRow extends StatelessWidget {
  const _ControlsRow();

  @override
  Widget build(BuildContext context) {
    Widget btn(String text, {required bool enabled, required Color color}) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: ElevatedButton(
            onPressed: enabled ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              disabledBackgroundColor: const Color(0xFFBFBFBF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: enabled ? 6 : 0,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: TextStyle(
                  color: enabled ? Colors.white : const Color(0xFFE0E0E0),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        btn("Pick", enabled: true,  color: Colors.red),
        btn("Skip", enabled: false, color: const Color(0xFFBFBFBF)),
        btn("Call", enabled: false, color: const Color(0xFFBFBFBF)),
        btn("Mahj", enabled: true,  color: const Color(0xFF5B5E9C)),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  final String leftText;
  final String centerText;

  const _StatusBar({required this.leftText, required this.centerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F2E2A),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(
        builder: (context, c) {
          // On narrow widths, drop center text (like many real games do).
          final compact = c.maxWidth < 320;

          return Row(
            children: [
              const Icon(Icons.check_box_outline_blank, color: Colors.white, size: 22),
              const SizedBox(width: 8),

              // Left text takes what's available
              Expanded(
                child: Text(
                  leftText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              if (!compact) ...[
                const SizedBox(width: 10),
                Flexible(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        centerText,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(width: 6),

              // Icons in a tight min-size row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _IconHit(icon: Icons.swap_horiz),
                  _IconHit(icon: Icons.chat_bubble_outline),
                  _IconHit(icon: Icons.settings),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

}

class _IconHit extends StatelessWidget {
  final IconData icon;
  const _IconHit({required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white, size: 20),
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      padding: EdgeInsets.zero,
      splashRadius: 20,
      tooltip: '',
    );
  }
}


class _PurpleStrip extends StatelessWidget {
  final Widget child;
  const _PurpleStrip({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF9A63FF),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Align(alignment: Alignment.centerLeft, child: child),
    );
  }
}

class _TileRow extends StatelessWidget {
  final List<String> tiles;
  final double tileW;
  final double tileH;
  final double spacing;

  const _TileRow({
    required this.tiles,
    required this.tileW,
    required this.tileH,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView + Row avoids unbounded viewport problems.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (int i = 0; i < tiles.length; i++) ...[
            _Tile(tiles[i], w: tileW, h: tileH),
            if (i != tiles.length - 1) SizedBox(width: spacing),
          ],
        ],
      ),
    );
  }
}

class _TileGrid extends StatelessWidget {
  final List<String> tiles;
  final double tileW;
  final double tileH;
  final double spacing;

  const _TileGrid({
    required this.tiles,
    required this.tileW,
    required this.tileH,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final t in tiles) _Tile(t, w: tileW, h: tileH),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String assetFile;
  final double w;
  final double h;
  final bool rotateVertical;

  const _Tile(
      this.assetFile, {
        required this.w,
        required this.h,
        this.rotateVertical = false,
      });

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(
      'assets/images/$assetFile',
      fit: BoxFit.contain,
      filterQuality: FilterQuality.low,
    );

    return RepaintBoundary(
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(blurRadius: 6, offset: Offset(1, 2), color: Colors.black26),
          ],
        ),
        padding: const EdgeInsets.all(2),
        child: rotateVertical ? RotatedBox(quarterTurns: 1, child: img) : img,
      ),
    );
  }
}
