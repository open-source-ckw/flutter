import 'package:flutter/material.dart';

class PortraitMahjongTableScreen extends StatelessWidget {
  const PortraitMahjongTableScreen({super.key});

  // === PIXEL PERFECT DESIGN SIZE (from your screenshot) ===
  static const double designW = 941;
  static const double designH = 2048;

  @override
  Widget build(BuildContext context) {
    // Demo data (use your png files)
    final topName = "COMPUTER 3";
    final leftName = "COMPUTER 1";
    final rightName = "COMPUTER 2";
    final bottomName = "KRUTIK123123 (10)";

    final topRack = ["char_2.png", "char_2.png", "char_2.png", "joker.png"];

    final topGrid = [
      "circle_1.png", "circle_9.png", "char_2.png", "dragon_red.png",
      "circle_3.png", "dragon_green.png", "flower_1.png", "circle_7.png",
      "char_7.png", "wind_noth.png", "dragon_white.png", "bamboo_1.png",
      "bamboo_2.png", "wind_west.png", "flower_3.png", "circle_9.png",
      "circle_3.png", "circle_4.png", "circle_6.png", "char_8.png",
    ];

    final leftRailTiles = ["circle_1.png", "circle_1.png", "circle_1.png", "circle_1.png", "joker.png"];
    final rightRailTiles = ["dragon_green.png", "dragon_green.png", "dragon_red.png", "dragon_red.png", "dragon_red.png"];

    final bottomMelds = <String>[];

    final bottomHand = [
      "wind_suth.png", "wind_east.png", "wind_east.png", "wind_west.png", "wind_noth.png",
      "char_7.png", "char_8.png", "char_6.png", "char_9.png",
      "circle_3.png", "circle_4.png", "circle_9.png", "circle_6.png"
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            return Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: designW,
                  height: designH,
                  child: _Board(
                    topName: topName,
                    leftName: leftName,
                    rightName: rightName,
                    bottomName: bottomName,
                    topRack: topRack,
                    topGrid: topGrid,
                    leftRailTiles: leftRailTiles,
                    rightRailTiles: rightRailTiles,
                    bottomMelds: bottomMelds,
                    bottomHand: bottomHand,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Board extends StatelessWidget {
  final String topName;
  final String leftName;
  final String rightName;
  final String bottomName;
  final List<String> topRack;
  final List<String> topGrid;
  final List<String> leftRailTiles;
  final List<String> rightRailTiles;
  final List<String> bottomMelds;
  final List<String> bottomHand;

  const _Board({
    required this.topName,
    required this.leftName,
    required this.rightName,
    required this.bottomName,
    required this.topRack,
    required this.topGrid,
    required this.leftRailTiles,
    required this.rightRailTiles,
    required this.bottomMelds,
    required this.bottomHand,
  });

  // === DESIGN CONSTANTS (tuned for 941x2048) ===
  static const double labelStripW = 92;     // black left/right name strips
  static const double frameX = labelStripW;
  static const double frameW = 941 - (labelStripW * 2);

  static const double railW = 170;          // turquoise rail columns where vertical tiles sit
  static const double centerX = frameX + railW;
  static const double centerW = frameW - (railW * 2);

  // vertical layout blocks (pixel)
  static const double topTitleY = 70;
  static const double topTitleH = 90;

  static const double rackY = 170;
  static const double rackH = 190;

  static const double feltY = 370;
  static const double feltH = 880;          // ends before controls

  static const double controlsY = 1265;
  static const double controlsH = 135;

  static const double statusY = 1410;
  static const double statusH = 155;

  static const double meldY = 1585;
  static const double meldH = 220;

  static const double handY = 1805;
  static const double handH = 165;

  static const double bottomNameY = 1970;
  static const double bottomNameH = 78;

  // tile sizes (pixel)
  static const double rackTileW = 92;
  static const double rackTileH = 110;

  static const double gridTileW = 78;
  static const double gridTileH = 94;

  static const double railTileW = 140;
  static const double railTileH = 160;

  static const double handTileW = 66;
  static const double handTileH = 76;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // whole background
        Positioned.fill(child: Container(color: Colors.black)),

        // LEFT black strip
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: labelStripW,
          child: _VerticalNameStrip(text: leftName, rotateOpposite: false),
        ),

        // RIGHT black strip
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: labelStripW,
          child: _VerticalNameStrip(text: rightName, rotateOpposite: true),
        ),

        // TURQUOISE FRAME (everything inside)
        Positioned(
          left: frameX,
          top: 0,
          width: frameW,
          height: 2048,
          child: Container(color: const Color(0xFF00E6E6)),
        ),

        // === TOP TITLE (FULL WIDTH IN FRAME) ===
        Positioned(
          left: frameX,
          top: topTitleY,
          width: frameW,
          height: topTitleH,
          child: Center(
            child: Text(
              topName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 54,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),

        // === TOP RACK (FULL WIDTH, tiles centered like reference) ===
        Positioned(
          left: frameX,
          top: rackY,
          width: frameW,
          height: rackH,
          child: Center(
            child: SizedBox(
              width: centerW,
              child: _TileRow(
                tiles: topRack,
                tileW: rackTileW,
                tileH: rackTileH,
                gap: 22,
                align: MainAxisAlignment.center,
              ),
            ),
          ),
        ),

        // === LEFT RAIL TILES (start below rack, end before meld/hand) ===
        Positioned(
          left: frameX,
          top: feltY,
          width: railW,
          height: (statusY + statusH) - feltY,
          child: _RailTiles(
            tiles: leftRailTiles,
            tileW: railTileW,
            tileH: railTileH,
          ),
        ),

        // === RIGHT RAIL TILES ===
        Positioned(
          left: frameX + frameW - railW,
          top: feltY,
          width: railW,
          height: (statusY + statusH) - feltY,
          child: _RailTiles(
            tiles: rightRailTiles,
            tileW: railTileW,
            tileH: railTileH,
          ),
        ),

        // === CENTER FELT ===
        Positioned(
          left: centerX,
          top: feltY,
          width: centerW,
          height: feltH,
          child: Container(
            color: const Color(0xFF3D5972),
            child: Padding(
              padding: const EdgeInsets.only(top: 26),
              child: Align(
                alignment: Alignment.topCenter,
                child: _TileWrapGrid(
                  tiles: topGrid,
                  tileW: gridTileW,
                  tileH: gridTileH,
                  gap: 18,
                ),
              ),
            ),
          ),
        ),

        // === CONTROLS (CENTER ONLY) ===
        Positioned(
          left: centerX,
          top: controlsY,
          width: centerW,
          height: controlsH,
          child: const _ControlsRow(),
        ),

        // === STATUS BAR (CENTER ONLY, cannot overflow) ===
        Positioned(
          left: centerX,
          top: statusY,
          width: centerW,
          height: statusH,
          child: const _StatusBar(
            leftText: "42 tiles left",
            centerText: "Pick a tile",
          ),
        ),

        // === MELDS (FULL WIDTH IN FRAME) ===
        Positioned(
          left: frameX,
          top: meldY,
          width: frameW,
          height: meldH,
          child: _PurpleStrip(
            child: bottomMelds.isEmpty
                ? const SizedBox()
                : _TileRow(
              tiles: bottomMelds,
              tileW: handTileW,
              tileH: handTileH,
              gap: 18,
              align: MainAxisAlignment.start,
            ),
          ),
        ),

        // === HAND (FULL WIDTH IN FRAME) ===
        Positioned(
          left: frameX,
          top: handY,
          width: frameW,
          height: handH,
          child: _PurpleStrip(
            child: _TileRow(
              tiles: bottomHand,
              tileW: handTileW,
              tileH: handTileH,
              gap: 18,
              align: MainAxisAlignment.start,
            ),
          ),
        ),

        // === BOTTOM NAME (FULL WIDTH IN FRAME) ===
        Positioned(
          left: frameX,
          top: bottomNameY,
          width: frameW,
          height: bottomNameH,
          child: Container(
            color: const Color(0xFF00E6E6),
            alignment: Alignment.center,
            child: Text(
              bottomName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VerticalNameStrip extends StatelessWidget {
  final String text;
  final bool rotateOpposite;

  const _VerticalNameStrip({
    required this.text,
    required this.rotateOpposite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: RotatedBox(
          quarterTurns: rotateOpposite ? 1 : 3,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 46,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _RailTiles extends StatelessWidget {
  final List<String> tiles;
  final double tileW;
  final double tileH;

  const _RailTiles({
    required this.tiles,
    required this.tileW,
    required this.tileH,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00E6E6),
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < tiles.length; i++) ...[
                _Tile(tiles[i], w: tileW, h: tileH),
                const SizedBox(height: 26),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlsRow extends StatelessWidget {
  const _ControlsRow();

  @override
  Widget build(BuildContext context) {
    Widget btn(Color bg, String text, bool enabled) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Container(
              color: enabled ? bg : const Color(0xFFD0D0D0),
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  color: enabled ? Colors.white : const Color(0xFFB0B0B0),
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        btn(const Color(0xFFE53935), "Pick", true),
        btn(const Color(0xFFBDBDBD), "Skip", false),
        btn(const Color(0xFFBDBDBD), "Call", false),
        btn(const Color(0xFF5B5E9C), "Mahj", true),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  final String leftText;
  final String centerText;

  const _StatusBar({
    required this.leftText,
    required this.centerText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F2E2A),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.check_box_outline_blank, color: Colors.white, size: 46),
          const SizedBox(width: 16),

          // Left text takes available space
          Expanded(
            child: Text(
              leftText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 44),
            ),
          ),

          // Center text
          Expanded(
            child: Center(
              child: Text(
                centerText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 48),
              ),
            ),
          ),

          // Right icons fixed size (won't overflow inside this design canvas)
          const SizedBox(width: 12),
          const _IconHit(icon: Icons.swap_horiz),
          const _IconHit(icon: Icons.chat_bubble_outline),
          const _IconHit(icon: Icons.settings),
        ],
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
      icon: Icon(icon, color: Colors.white, size: 44),
      constraints: const BoxConstraints.tightFor(width: 86, height: 86),
      padding: EdgeInsets.zero,
      splashRadius: 40,
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
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}

class _TileRow extends StatelessWidget {
  final List<String> tiles;
  final double tileW;
  final double tileH;
  final double gap;
  final MainAxisAlignment align;

  const _TileRow({
    required this.tiles,
    required this.tileW,
    required this.tileH,
    required this.gap,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: align,
        children: [
          for (int i = 0; i < tiles.length; i++) ...[
            _Tile(tiles[i], w: tileW, h: tileH),
            if (i != tiles.length - 1) SizedBox(width: gap),
          ]
        ],
      ),
    );
  }
}

class _TileWrapGrid extends StatelessWidget {
  final List<String> tiles;
  final double tileW;
  final double tileH;
  final double gap;

  const _TileWrapGrid({
    required this.tiles,
    required this.tileW,
    required this.tileH,
    required this.gap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (final t in tiles) _Tile(t, w: tileW, h: tileH),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final String assetName;
  final double w;
  final double h;

  const _Tile(this.assetName, {required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      height: h,
      child: Image.asset(
        'assets/images/$assetName',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
