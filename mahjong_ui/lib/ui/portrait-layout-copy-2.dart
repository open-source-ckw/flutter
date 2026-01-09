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

    //final topRack = ["2C", "2C", "2C", "JOKER"];
    final topRack = ["char_2.png", "char_2.png", "char_2.png", "joker.png"];
    //final topGrid = List.generate(45, (i) => "T${i + 1}"); // pretend discard/wall area
    final topGrid = ["circle_1.png", "circle_9.png", "char_2.png", "dragon_red.png", "circle_3.png", "dragon_green.png", "flower_1.png", "circle_7.png", "char_7.png", "wind_noth.png", "dragon_white.png", "bamboo_1.png", "bamboo_2.png", "wind_west.png", "flower_3.png", "circle_9.png"]; // pretend discard/wall area
    final leftRailTiles = ["circle_1.png", "circle_1.png", "circle_1.png", "circle_1.png", "joker.png"];
    final rightRailTiles = ["dragon_green.png", "dragon_green.png", "dragon_red.png", "dragon_red.png", "dragon_red.png"];

    final bottomHand = ["wind_suth.png", "wind_east.png", "wind_east.png", "wind_west.png", "wind_noth.png", "char_7.png", "char_8.png", "char_6.png", "char_9.png", "circle_3.png", "circle_4.png", "circle_9.png", "circle_6.png"];
    final bottomMelds = <String>[]; // keep empty or add tiles

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            // Screen sizes
            final w = c.maxWidth;
            final h = c.maxHeight;

            // Layout constants tuned for a “like the screenshot” feel
            final labelStripW = (w * 0.06).clamp(22.0, 34.0); // black vertical name strip
            //final railW = (w * 0.12).clamp(70.0, 110.0);      // turquoise rails
            final railW = (w * 0.05).clamp(30.0, 30.0);      // turquoise rails
            //final railW = 50.0;
            final innerPad = 10.0;

            // Center available size (between rails)
            final centerW = w - (labelStripW * 2) - (railW * 2) - (innerPad * 2);

            // Tile sizes (key to making it look right)
            //final tileW = (centerW / 12).clamp(34.0, 52.0);
            final tileW = (centerW / 12).clamp(32.0, 32.0);
            //final tileH = tileW * 1.28;
            final tileH = tileW * 1.05;

            // Top rack tiles slightly larger than grid tiles
            // final rackTileW = (tileW * 1.05).clamp(36.0, 58.0);
            final rackTileW = (tileW * 1.01).clamp(30.0, 30.0);
            // final rackTileH = rackTileW * 1.28;
            final rackTileH = rackTileW * 0.80;

            // Grid tiles slightly smaller
            final gridTileW = (tileW * 0.92).clamp(32.0, 48.0);
            final gridTileH = gridTileW * 1.28;

            // Heights for bottom area
            final controlsH = (h * 0.08).clamp(54.0, 78.0);
            final statusH = (h * 0.07).clamp(52.0, 70.0);
            final meldsH = (h * 0.07).clamp(54.0, 80.0);
            //final handH = (h * 0.12).clamp(90.0, 140.0);
            final handH = (h * 0.07).clamp(50.0, 90.0);
            final bottomNameH = 22.0;

            // Top name bar
            final topNameH = 22.0;//44.0;

            // Main felt area height
            final mainH = h - topNameH - controlsH - statusH - meldsH - handH - bottomNameH - (innerPad * 2);
            final feltH = mainH.clamp(280.0, double.infinity);

            // The tile field should live in the *top portion* of the felt (like your screenshot)
            final tileFieldH = (feltH * 0.45).clamp(140.0, 260.0);

            return Padding(
              padding: EdgeInsets.all(innerPad),
              child: Container(
                color: const Color(0xFF00E6E6), // turquoise outer frame
                child: Row(
                  children: [
                    // LEFT black label strip
                    _VerticalNameStrip(width: labelStripW, text: leftName),

                    // LEFT turquoise rail with vertical tiles
                    _SideRail(
                      width: railW,
                      tiles: leftRailTiles,
                      tileW: railW * 0.72,
                      tileH: railW * 0.72 * 1.22,
                      alignTop: true,
                    ),

                    // CENTER felt + top/bottom UI
                    Expanded(
                      child: Container(
                        color: const Color(0xFF3D5972), // felt background
                        child: Column(
                          children: [
                            SizedBox(
                              height: topNameH,
                              child: Center(
                                child: Text(
                                  topName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),

                            // Main felt area: top rack + grid at the top + empty space below
                            SizedBox(
                              height: feltH,
                              child: Stack(
                                children: [
                                  // Top turquoise strip behind opponent rack (like screenshot)
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 0,
                                    height: rackTileH + 12,
                                    child: Container(color: const Color(0xFF00E6E6)),
                                  ),

                                  // Opponent rack row (top-left in screenshots)
                                  Positioned(
                                    left: 8,
                                    right: 8, // ✅ THIS IS THE FIX
                                    top: 6,
                                    height: rackTileH,
                                    child: _TileRow(
                                      tiles: topRack,
                                      tileW: rackTileW,
                                      tileH: rackTileH,
                                      spacing: 1,
                                    ),
                                  ),

                                  // Tile field (grid) beneath the rack, top section of felt
                                  Positioned(
                                    left: 6,
                                    right: 6,
                                    top: rackTileH + 18,
                                    height: tileFieldH,
                                    child: _TileGrid(
                                      tiles: topGrid,
                                      tileW: gridTileW,
                                      tileH: gridTileH,
                                      spacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Controls row (Pick/Skip/Call/Mahj)
                            SizedBox(
                              height: controlsH,
                              child: _ControlsRow(),
                            ),

                            // Status bar
                            SizedBox(
                              height: statusH,
                              child: _StatusBar(
                                leftText: "42 tiles left",
                                centerText: "Pick a tile",
                              ),
                            ),

                            // Purple meld strip
                            SizedBox(
                              height: meldsH,
                              child: _PurpleStrip(
                                child: bottomMelds.isEmpty
                                    ? const SizedBox()
                                    : _TileRow(
                                  tiles: bottomMelds,
                                  tileW: tileW,
                                  tileH: tileH,
                                  spacing: 1,
                                ),
                              ),
                            ),

                            // Purple hand strip
                            SizedBox(
                              height: handH,
                              child: _PurpleStrip(
                                child: _TileRow(
                                  tiles: bottomHand,
                                  tileW: tileW,
                                  tileH: tileH,
                                  spacing: 1,
                                ),
                              ),
                            ),

                            // Bottom player name
                            SizedBox(
                              height: bottomNameH,
                              child: Center(
                                child: Text(
                                  bottomName,
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // RIGHT turquoise rail
                    _SideRail(
                      width: railW,
                      tiles: rightRailTiles,
                      tileW: railW * 0.58,
                      tileH: railW * 0.58 * 1.22,
                      alignTop: true,
                    ),

                    // RIGHT black label strip
                    _VerticalNameStrip(width: labelStripW, text: rightName, rotateOpposite: true),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Black vertical strip with rotated player name (like screenshot)
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
            style: const TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 1.0),
          ),
        ),
      ),
    );
  }
}

/// Turquoise rail with vertical tiles
class _SideRail extends StatelessWidget {
  final double width;
  final List<String> tiles;
  final double tileW;
  final double tileH;
  final bool alignTop;

  const _SideRail({
    required this.width,
    required this.tiles,
    required this.tileW,
    required this.tileH,
    required this.alignTop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: const Color(0xFF00E6E6),
      child: Align(
        alignment: alignTop ? Alignment.topCenter : Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final t in tiles) ...[
              _Tile(t, w: tileW, h: tileH, rotateLabelVertical: true),
            ]
          ],
        ),
      ),
    );
  }
}

class _ControlsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget btn(String text, {required bool enabled, required Color color}) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            text,
            style: TextStyle(
              color: enabled ? Colors.white : const Color(0xFFE0E0E0),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
      /*return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            // height: double.infinity,
            child: ElevatedButton(
              onPressed: enabled ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                disabledBackgroundColor: const Color(0xFFBFBFBF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: enabled ? 6 : 0,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: TextStyle(
                    color: enabled ? Colors.white : const Color(0xFFE0E0E0),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      );*/
    }

    return Row(
      children: [
        btn("Pick", enabled: true, color: Colors.red),
        btn("Skip", enabled: false, color: const Color(0xFFBFBFBF)),
        btn("Call", enabled: false, color: const Color(0xFFBFBFBF)),
        btn("Mahj", enabled: true, color: const Color(0xFF5B5E9C)),
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
      child: Row(
        children: [
          const Icon(Icons.check_box_outline_blank, color: Colors.white, size: 20),
          Flexible(
            child: Text(
              leftText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          /*Text(
            centerText,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),*/
          const Spacer(),
          _IconHit(icon: Icons.swap_horiz),
          _IconHit(icon: Icons.chat_bubble_outline),
          _IconHit(icon: Icons.settings),
        ],
      ),
    );
  }
}
class _StatusBarTiles extends StatelessWidget {
  final String leftText;
  final String centerText;

  const _StatusBarTiles({required this.leftText, required this.centerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F2E2A),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const Icon(Icons.check_box_outline_blank, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              leftText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          const Spacer(),
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  centerText,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          const Spacer(),
          _IconHit(icon: Icons.swap_horiz),
          _IconHit(icon: Icons.chat_bubble_outline),
          _IconHit(icon: Icons.settings),
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
      icon: Icon(icon, color: Colors.white,size: 16,),
      //constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      //padding: EdgeInsets.zero,
      //splashRadius: 12,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: tiles.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, __) => SizedBox(width: 0),
      itemBuilder: (_, i) => _Tile(tiles[i], w: tileW, h: tileH),
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
    // Wrap creates the “pile/grid” look like the screenshot’s top area.
    return SingleChildScrollView(
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

/// Placeholder tile widget.
/// Replace the inner Text with Image.asset(...) when you have real tile PNGs.
class _Tile extends StatelessWidget {
  final String label;
  final double w;
  final double h;
  final bool rotateLabelVertical;

  const _Tile(
      this.label, {
        required this.w,
        required this.h,
        this.rotateLabelVertical = false,
      });

  @override
  Widget build(BuildContext context) {
    /*final child = Text(
      label,
      style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );*/

    //final child = Image.asset('assets/images/'+label);
    final child = Image.asset('assets/images/$label', fit: BoxFit.contain);

    return Container(
      width: w,
      height: h,
      /*decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(1, 2),
            color: Colors.black26,
          ),
        ],
      ),*/
      alignment: Alignment.center,
      child: rotateLabelVertical
          ? RotatedBox(quarterTurns: 1, child: child)
          : child,
    );
  }
}
