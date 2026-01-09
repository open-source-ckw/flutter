import 'package:flutter/material.dart';

class PortraitMahjongTableScreen extends StatelessWidget {
  const PortraitMahjongTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data (replace with real state later)
    final topName = "COMPUTER 3";
    final leftName = "COMPUTER 1";
    final rightName = "COMPUTER 2";
    final bottomName = "KRUTIK123123 (10)";

    final topRack = ["char_2.png", "char_2.png", "char_2.png", "joker.png"];

    final topGrid = [
      "circle_1.png",
      "circle_9.png",
      "char_2.png",
      "dragon_red.png",
      "circle_3.png",
      "dragon_green.png",
      "flower_1.png",
      "circle_7.png",
      "char_7.png",
      "wind_noth.png",
      "dragon_white.png",
      "bamboo_1.png",
      "bamboo_2.png",
      "wind_west.png",
      "flower_3.png",
      "circle_9.png",
      "circle_3.png",
      "circle_4.png",
      "circle_6.png",
      "char_8.png",
      "char_9.png",
      "bamboo_3.png",
      "bamboo_4.png",
      "wind_suth.png",
    ];

    final leftRailTiles = [
      "circle_1.png",
      "circle_1.png",
      "circle_1.png",
      "circle_1.png",
      "joker.png",
    ];

    final rightRailTiles = [
      "dragon_green.png",
      "dragon_green.png",
      "dragon_red.png",
      "dragon_red.png",
      "dragon_red.png",
    ];

    final bottomMelds = <String>[]; // empty ok

    final bottomHand = [
      "wind_suth.png",
      "wind_east.png",
      "wind_east.png",
      "wind_west.png",
      "wind_noth.png",
      "char_7.png",
      "char_8.png",
      "char_6.png",
      "char_9.png",
      "circle_3.png",
      "circle_4.png",
      "circle_9.png",
      "circle_6.png",
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;

            // === LEFT/RIGHT BLACK STRIPS (player names) ===
            //final labelStripW = (w * 0.10).clamp(44.0, 72.0);
            final labelStripW = (w * 0.05).clamp(24.0, 52.0);

            // The turquoise "board" area between black strips
            final boardW = w - (labelStripW * 2);

            // === COLORS from your screenshots ===
            const turquoise = Color(0xFF00E6E6);
            const felt = Color(0xFF3D5972);
            const status = Color(0xFF0F2E2A);
            const purple = Color(0xFF9A63FF);

            // === Heights: scale by screen, clamp to keep usable ===
            //final topTitleH = (h * 0.055).clamp(38.0, 70.0);
            final topTitleH = (h * 0.05).clamp(0.0, 20.0);
            final rackH = (h * 0.125).clamp(90.0, 160.0);

            final controlsH = (h * 0.085).clamp(64.0, 110.0);
            final statusH = (h * 0.100).clamp(70.0, 130.0);

            final meldsH = (h * 0.085).clamp(70.0, 120.0);
            //final handH = (h * 0.105).clamp(90.0, 150.0);
            final handH = (h * 0.20).clamp(10.0, 20.0);

            //final bottomNameH = (h * 0.055).clamp(38.0, 80.0);
            final bottomNameH = (h * 0.00).clamp(18.0, 30.0);

            // Middle section height (where rails + felt live)
            final middleH = h -
                topTitleH -
                rackH -
                controlsH -
                statusH -
                meldsH -
                handH -
                bottomNameH;

            // Rails width (turquoise columns) inside board
            //final railW = (boardW * 0.15).clamp(72.0, 130.0);
            //final centerW = boardW - (railW * 2);

            final railW = (boardW * 0.10).clamp(22.0, 60.0);
            final centerW = boardW - (railW * 2);

            // Tiles sizing (based on center area)
            /*final rackTileH = (rackH * 0.55).clamp(44.0, 86.0);
            final rackTileW = rackTileH * 0.88;

            final gridTileW = (centerW / 9.8).clamp(44.0, 68.0);
            final gridTileH = gridTileW * 1.12;

            final railTileW = (railW * 0.82).clamp(46.0, 110.0);
            final railTileH = railTileW * 1.15;

            final handTileH = (handH * 0.62).clamp(46.0, 82.0);
            final handTileW = handTileH * 0.90;*/
            // NEW (smaller tiles)
            /*final rackTileH = (rackH * 0.48).clamp(38.0, 74.0);
            final rackTileW = rackTileH * 0.86;

            final gridTileW = (centerW / 10.8).clamp(38.0, 60.0);
            final gridTileH = gridTileW * 1.10;

            final railTileW = (railW * 0.74).clamp(40.0, 96.0);
            final railTileH = railTileW * 1.12;

            final handTileH = (handH * 0.54).clamp(40.0, 72.0);
            final handTileW = handTileH * 0.88;*/
            final rackTileH = (rackH * 0.18).clamp(28.0, 64.0);
            final rackTileW = rackTileH * 0.76;

            final gridTileW = (centerW / 20.8).clamp(20.0, 60.0);
            final gridTileH = gridTileW * 1.10;

            final railTileW = (railW * 0.0).clamp(20.0, 26.0);
            final railTileH = railTileW * 0.85;

            final handTileH = (handH * 0.54).clamp(20.0, 72.0);
            final handTileW = handTileH * 0.88;


            return Row(
              children: [
                // LEFT BLACK STRIP
                SizedBox(
                  width: labelStripW,
                  child: _VerticalNameStrip(text: leftName, rotateOpposite: false),
                ),

                // BOARD (turquoise frame)
                SizedBox(
                  width: boardW,
                  child: Container(
                    color: turquoise,
                    child: Column(
                      children: [
                        // TOP TITLE (full width)
                        SizedBox(
                          height: topTitleH,
                          child: Container(
                            color: Colors.black,
                            child: Center(
                              child: Text(
                                topName,
                                style: TextStyle(
                                  color: Colors.white,
                                  //fontSize: (topTitleH * 0.55).clamp(16.0, 26.0),
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // TOP RACK (full width)
                        SizedBox(
                          height: rackH,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: _TileStrip(
                                tiles: topRack,
                                tileW: rackTileW,
                                tileH: rackTileH,
                                gap: 1,
                                // Rack tiles in your screenshot are upright
                                rotateQuarterTurns: 0,
                              ),
                            ),
                          ),
                        ),

                        // MIDDLE: rails + felt (rails background only here)
                        SizedBox(
                          //height: middleH.clamp(220.0, double.infinity),
                          height: middleH.clamp(200.0, double.infinity),
                          child: Row(
                            children: [
                              // LEFT RAIL (tiles scroll if too many, no overflow)
                              SizedBox(
                                width: railW,
                                child: _RailColumn(
                                  tiles: leftRailTiles,
                                  tileW: railTileW,
                                  tileH: railTileH,
                                  // left rail tiles typically face inward (rotate 270)
                                  rotateQuarterTurns: 3,
                                ),
                              ),

                              // CENTER FELT
                              SizedBox(
                                width: centerW,
                                child: Container(
                                  color: felt,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: SizedBox(
                                        // Grid occupies only top portion like screenshot
                                        height: (middleH * 0.52).clamp(160.0, 360.0),
                                        child: ClipRect(
                                          child: SingleChildScrollView(
                                            physics: const BouncingScrollPhysics(),
                                            child: Wrap(
                                              spacing: 1,
                                              runSpacing: 2,
                                              children: [
                                                for (final t in topGrid)
                                                  _TileAsset(
                                                    name: t,
                                                    w: gridTileW,
                                                    h: gridTileH,
                                                    rotateQuarterTurns: 0,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // RIGHT RAIL
                              SizedBox(
                                width: railW,
                                child: _RailColumn(
                                  tiles: rightRailTiles,
                                  tileW: railTileW,
                                  tileH: railTileH,
                                  // right rail tiles typically face inward (rotate 90)
                                  rotateQuarterTurns: 1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // CONTROLS (centered inside board, like screenshot)
                        SizedBox(
                          height: controlsH,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: _ControlsRow(height: controlsH),
                          ),
                        ),

                        // STATUS BAR (full width inside board)
                        SizedBox(
                          height: statusH,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: _StatusBar(
                              height: statusH,
                              bg: status,
                              leftText: "42 tiles left",
                              centerText: "Pick a tile",
                            ),
                          ),
                        ),

                        // MELDS (full width, purple)
                        SizedBox(
                          height: meldsH,
                          child: Container(
                            color: purple,
                            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                            alignment: Alignment.centerLeft,
                            child: bottomMelds.isEmpty
                                ? const SizedBox()
                                : _TileStrip(
                              tiles: bottomMelds,
                              tileW: handTileW,
                              tileH: handTileH,
                              gap: 1,
                              rotateQuarterTurns: 0,
                            ),
                          ),
                        ),

                        // HAND (full width, purple)
                        SizedBox(
                          height: handH,
                          child: Container(
                            color: purple,
                            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                            alignment: Alignment.centerLeft,
                            child: _TileStrip(
                              tiles: bottomHand,
                              tileW: handTileW,
                              tileH: handTileH,
                              gap: 1,
                              rotateQuarterTurns: 0,
                            ),
                          ),
                        ),

                        // BOTTOM NAME (full width)
                        SizedBox(
                          height: bottomNameH,
                          child: Center(
                            child: Text(
                              bottomName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (bottomNameH * 0.55).clamp(14.0, 24.0),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // RIGHT BLACK STRIP
                SizedBox(
                  width: labelStripW,
                  child: _VerticalNameStrip(text: rightName, rotateOpposite: true),
                ),
              ],
            );
          },
        ),
      ),
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
              fontSize: 10,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _RailColumn extends StatelessWidget {
  final List<String> tiles;
  final double tileW;
  final double tileH;
  final int rotateQuarterTurns;

  const _RailColumn({
    required this.tiles,
    required this.tileW,
    required this.tileH,
    required this.rotateQuarterTurns,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00E6E6),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ClipRect(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                for (final t in tiles) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: _TileAsset(
                      name: t,
                      w: tileW,
                      h: tileH,
                      rotateQuarterTurns: rotateQuarterTurns,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TileStrip extends StatelessWidget {
  final List<String> tiles;
  final double tileW;
  final double tileH;
  final double gap;
  final int rotateQuarterTurns;

  const _TileStrip({
    required this.tiles,
    required this.tileW,
    required this.tileH,
    required this.gap,
    required this.rotateQuarterTurns,
  });

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: bounded + no unbounded width errors
    return ClipRect(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (int i = 0; i < tiles.length; i++) ...[
              _TileAsset(
                name: tiles[i],
                w: tileW,
                h: tileH,
                rotateQuarterTurns: rotateQuarterTurns,
              ),
              if (i != tiles.length - 1) SizedBox(width: gap),
            ],
          ],
        ),
      ),
    );
  }
}

class _TileAsset extends StatelessWidget {
  final String name;
  final double w;
  final double h;
  final int rotateQuarterTurns;

  const _TileAsset({
    required this.name,
    required this.w,
    required this.h,
    required this.rotateQuarterTurns,
  });

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(
      'assets/images/$name',
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) {
        // If asset missing, show a visible placeholder instead of crashing silently
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text(
            name,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        );
      },
    );

    return SizedBox(
      width: w,
      height: h,
      child: rotateQuarterTurns == 0 ? img : RotatedBox(quarterTurns: rotateQuarterTurns, child: img),
    );
  }
}

class _ControlsRow extends StatelessWidget {
  final double height;
  const _ControlsRow({required this.height});

  @override
  Widget build(BuildContext context) {
    //final fontSize = (height * 0.38).clamp(14.0, 22.0);
    final fontSize = 12.0;

    Widget btn(String text, {required bool enabled, required Color color}) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              color: enabled ? color : const Color(0xFFD0D0D0),
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  color: enabled ? Colors.white : const Color(0xFFB0B0B0),
                  fontSize: fontSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        btn("Pick", enabled: true, color: const Color(0xFFE53935)),
        btn("Skip", enabled: false, color: const Color(0xFFBDBDBD)),
        btn("Call", enabled: false, color: const Color(0xFFBDBDBD)),
        btn("Mahj", enabled: true, color: const Color(0xFF5B5E9C)),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  final double height;
  final Color bg;
  final String leftText;
  final String centerText;

  const _StatusBar({
    required this.height,
    required this.bg,
    required this.leftText,
    required this.centerText,
  });

  @override
  Widget build(BuildContext context) {
    final leftSize = (height * 0.30).clamp(12.0, 18.0);
    final centerSize = (height * 0.34).clamp(14.0, 20.0);
    final iconSize = (height * 0.30).clamp(16.0, 22.0);

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        children: [
          Icon(Icons.check_box_outline_blank, color: Colors.white, size: iconSize),
          const SizedBox(width: 10),

          // Left text should NOT push icons out of screen
          Expanded(
            flex: 4,
            child: Text(
              leftText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: leftSize),
            ),
          ),

          // Center text
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                centerText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: centerSize),
              ),
            ),
          ),

          // Icons (fixed, won't overflow)
          _IconHit(icon: Icons.swap_horiz, size: iconSize),
          _IconHit(icon: Icons.chat_bubble_outline, size: iconSize),
          _IconHit(icon: Icons.settings, size: iconSize),
        ],
      ),
    );
  }
}

class _IconHit extends StatelessWidget {
  final IconData icon;
  final double size;
  const _IconHit({required this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white, size: size),
      constraints: const BoxConstraints.tightFor(width: 44, height: 44),
      padding: EdgeInsets.zero,
      splashRadius: 22,
      tooltip: '',
    );
  }
}
