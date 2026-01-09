import 'dart:math' as math;
import 'package:flutter/material.dart';

class PortraitTableScreen extends StatelessWidget {
  const PortraitTableScreen({super.key});

  static const double designW = 1200;
  static const double designH = 1920;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, c) {
          final sx = c.maxWidth / designW;
          final sy = c.maxHeight / designH;
          final scale = math.min(sx, sy);

          // Boost text/icons slightly when scaled down.
          // Keep modest to avoid overflow.
          final boost = (1 / scale).clamp(1.0, 1.25);

          return Center(
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.center,
              child: SizedBox(
                width: designW,
                height: designH,
                child: Stack(
                  children: [
                    Positioned.fill(child: _PortraitBoardBackground()),

                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 90,
                      child: _TopBar(title: 'Computer 1', boost: boost),
                    ),

                    Positioned(
                      top: 110,
                      left: 40,
                      right: 40,
                      height: 160,
                      child: _OpponentArea(boost: boost),
                    ),

                    Positioned(
                      top: 290,
                      left: 0,
                      width: 110,
                      height: 420,
                      child: _MiniSidePlayer(label: 'linda', score: '2025', boost: boost),
                    ),

                    Positioned(
                      top: 290,
                      right: 0,
                      width: 110,
                      height: 420,
                      child: _MiniSidePlayer(label: 'carol', score: '100', boost: boost),
                    ),

                    Positioned(
                      top: 290,
                      left: 120,
                      right: 120,
                      height: 760,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D5972),
                          border: Border.all(color: Colors.black, width: 6),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 40,
                      right: 40,
                      top: 1080,
                      height: 140,
                      child: _ActionButtonsRowPortrait(boost: boost),
                    ),

                    Positioned(
                      left: 40,
                      right: 40,
                      top: 1230,
                      height: 70,
                      child: _StatusBarPortrait(boost: boost),
                    ),

                    Positioned(
                      left: 40,
                      right: 40,
                      bottom: 260,
                      height: 90,
                      child: Container(
                        color: const Color(0xFF9A63FF),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Exposed melds row (tiles here)',
                          style: TextStyle(fontSize: 18 * boost, color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    Positioned(
                      left: 40,
                      right: 40,
                      bottom: 120,
                      height: 130,
                      child: Container(
                        color: const Color(0xFF9A63FF),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Player hand row (big tiles here)',
                          style: TextStyle(fontSize: 22 * boost, color: Colors.black87, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 20,
                      height: 60,
                      child: Center(
                        child: Text(
                          'marilyn (4370)',
                          style: TextStyle(color: Colors.white, fontSize: 32 * boost),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PortraitBoardBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00E6E6),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(color: const Color(0xFF3D5972)),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final double boost;
  const _TopBar({required this.title, required this.boost});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 34 * boost, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _OpponentArea extends StatelessWidget {
  final double boost;
  const _OpponentArea({required this.boost});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00E6E6),
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(
          'Opponent tiles area (2 rows)',
          style: TextStyle(fontSize: 18 * boost, color: Colors.black87),
        ),
      ),
    );
  }
}

class _MiniSidePlayer extends StatelessWidget {
  final String label;
  final String score;
  final double boost;
  const _MiniSidePlayer({required this.label, required this.score, required this.boost});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00E6E6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label\n($score)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18 * boost),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Icon(Icons.view_week, color: Colors.white, size: 28 * boost),
        ],
      ),
    );
  }
}

class _ActionButtonsRowPortrait extends StatelessWidget {
  final double boost;
  const _ActionButtonsRowPortrait({required this.boost});

  @override
  Widget build(BuildContext context) {
    Widget btn(String text, {required bool enabled, Color? color}) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 110,
            child: ElevatedButton(
              onPressed: enabled ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                disabledBackgroundColor: const Color(0xFFBFBFBF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: TextStyle(fontSize: 38 * boost, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        btn('Pick', enabled: true, color: Colors.red),
        btn('Skip', enabled: false),
        btn('Call', enabled: false),
        btn('Mahj', enabled: true, color: const Color(0xFF5B5E9C)),
      ],
    );
  }
}

class _StatusBarPortrait extends StatelessWidget {
  final double boost;
  const _StatusBarPortrait({required this.boost});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final narrow = c.maxWidth < 520; // design units
        final tBoost = narrow ? boost.clamp(1.0, 1.12) : boost;

        final font = (narrow ? 22.0 : 28.0) * tBoost;
        final iconSize = (narrow ? 22.0 : 28.0) * tBoost;
        final iconTap = narrow ? 48.0 : 56.0;

        Widget iconBtn(IconData icon) => IconButton(
          onPressed: () {},
          icon: Icon(icon, color: Colors.white, size: iconSize),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(width: iconTap, height: iconTap),
          splashRadius: iconTap / 2,
        );

        return Container(
          color: const Color(0xFF0F2E2A),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(Icons.check_box_outline_blank, color: Colors.white, size: iconSize),
              const SizedBox(width: 8),
              Flexible(
                flex: 4,
                child: Text(
                  '48 tiles left',
                  style: TextStyle(color: Colors.white, fontSize: font),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Pick a tile',
                      style: TextStyle(color: Colors.white, fontSize: font),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  iconBtn(Icons.swap_horiz),
                  iconBtn(Icons.chat_bubble_outline),
                  iconBtn(Icons.settings),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
