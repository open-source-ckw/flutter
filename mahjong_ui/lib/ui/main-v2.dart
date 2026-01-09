import 'dart:math' as math;
import 'package:flutter/material.dart';

/// FIX #1: Put these at TOP LEVEL so you never get "designH not found".
const double designW = 1200;
const double designH = 1920;

void main() {
  runApp(const MyApp());
}

/// App entry
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TableEntry(),
    );
  }
}

/// Chooses portrait vs landscape automatically
class TableEntry extends StatelessWidget {
  const TableEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (_, o) {
        return o == Orientation.portrait
            ? const PortraitTableScreen()
            : const LandscapeTableScreen();
      },
    );
  }
}

/// PORTRAIT SCREEN
class PortraitTableScreen extends StatelessWidget {
  const PortraitTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final sx = c.maxWidth / designW;
            final sy = c.maxHeight / designH;
            final scale = math.min(sx, sy);

            // Boost only for typography/icon visibility when scale is small.
            // Keep it modest so it doesn't explode layout.
            final boost = (1 / scale).clamp(1.0, 1.25);

            return Center(
              // NOTE: Transform.scale affects painting, not layout.
              // Child still lays out in design units, then paints scaled.
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: SizedBox(
                  width: designW,
                  height: designH,
                  child: _PortraitBoard(boost: boost),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PortraitBoard extends StatelessWidget {
  final double boost;
  const _PortraitBoard({required this.boost});

  TextStyle get titleStyle => TextStyle(
    color: Colors.white,
    fontSize: 34 * boost,
    fontWeight: FontWeight.w600,
  );

  TextStyle get labelStyle => TextStyle(
    color: Colors.white,
    fontSize: 22 * boost,
    fontWeight: FontWeight.w500,
  );

  TextStyle get smallStyle => TextStyle(
    color: Colors.white,
    fontSize: 18 * boost,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: _PortraitBoardBackground()),

        // Top title bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 90,
          child: Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: Text('Computer 1', style: titleStyle),
          ),
        ),

        // Opponent tiles area
        Positioned(
          top: 110,
          left: 40,
          right: 40,
          height: 170,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF00E6E6),
              border: Border.all(color: const Color(0xFF2B3C4A), width: 12),
            ),
            alignment: Alignment.center,
            child: Text(
              'Opponent tiles area (2 rows)',
              style: smallStyle.copyWith(color: Colors.black87),
            ),
          ),
        ),

        // Mini left player rail
        Positioned(
          top: 300,
          left: 0,
          width: 130,
          height: 470,
          child: _MiniSidePlayer(boost: boost, label: 'linda', score: '2025'),
        ),

        // Mini right player rail
        Positioned(
          top: 300,
          right: 0,
          width: 130,
          height: 470,
          child: _MiniSidePlayer(boost: boost, label: 'carol', score: '100'),
        ),

        // Center felt
        Positioned(
          top: 300,
          left: 140,
          right: 140,
          height: 820,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3D5972),
              border: Border.all(color: Colors.black, width: 6),
            ),
          ),
        ),

        // Buttons
        Positioned(
          left: 40,
          right: 40,
          top: 1140,
          height: 150,
          child: _ActionButtonsRowPortrait(boost: boost),
        ),

        // FIX #2: Status bar is now responsive (no overflow)
        Positioned(
          left: 40,
          right: 40,
          top: 1300,
          height: 80,
          child: _StatusBarPortrait(boost: boost),
        ),

        // Exposed row
        Positioned(
          left: 40,
          right: 40,
          bottom: 270,
          height: 95,
          child: Container(
            color: const Color(0xFF9A63FF),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.centerLeft,
            child: Text(
              'Exposed melds row (tiles here)',
              style: smallStyle.copyWith(color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // Hand row
        Positioned(
          left: 40,
          right: 40,
          bottom: 140,
          height: 130,
          child: Container(
            color: const Color(0xFF9A63FF),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.centerLeft,
            child: Text(
              'Player hand row (big tiles here)',
              style: labelStyle.copyWith(color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // Bottom label
        Positioned(
          left: 0,
          right: 0,
          bottom: 40,
          height: 60,
          child: Center(
            child: Text('marilyn (4370)', style: titleStyle),
          ),
        ),
      ],
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

class _MiniSidePlayer extends StatelessWidget {
  final double boost;
  final String label;
  final String score;

  const _MiniSidePlayer({
    required this.boost,
    required this.label,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00E6E6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label\n($score)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20 * boost),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Icon(Icons.view_week, color: Colors.white, size: 30 * boost),
          ],
        ),
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
            height: 120,
            child: ElevatedButton(
              onPressed: enabled ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                disabledBackgroundColor: const Color(0xFFBFBFBF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: enabled ? 8 : 0,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 38 * boost,
                    fontWeight: FontWeight.w700,
                    color: enabled ? Colors.white : const Color(0xFFE0E0E0),
                  ),
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

/// FIX #2 (continued): Responsive status bar that won't overflow on narrow widths.
class _StatusBarPortrait extends StatelessWidget {
  final double boost;
  const _StatusBarPortrait({required this.boost});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final narrow = c.maxWidth < 520; // design units
        final textBoost = narrow ? boost.clamp(1.0, 1.12) : boost;

        final leftFont = (narrow ? 22.0 : 28.0) * textBoost;
        final centerFont = (narrow ? 22.0 : 28.0) * textBoost;

        // Keep tap targets decent, but don't let icons eat the whole bar.
        final iconTap = narrow ? 48.0 : 56.0;
        final iconVisual = (narrow ? 22.0 : 28.0) * textBoost;

        Widget statusIcon(IconData icon, VoidCallback onTap) {
          return IconButton(
            onPressed: onTap,
            icon: Icon(icon, color: Colors.white, size: iconVisual),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tightFor(width: iconTap, height: iconTap),
            splashRadius: iconTap / 2,
          );
        }

        return Container(
          color: const Color(0xFF0F2E2A),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(Icons.check_box_outline_blank, color: Colors.white, size: iconVisual),
              const SizedBox(width: 8),

              // Left text: Flexible + ellipsis so it never overflows
              Flexible(
                flex: 4,
                child: Text(
                  '48 tiles left',
                  style: TextStyle(color: Colors.white, fontSize: leftFont),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),

              const SizedBox(width: 10),

              // Center text: Expanded + FittedBox so it scales down on tight space
              Expanded(
                flex: 5,
                child: Align(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Pick a tile',
                      style: TextStyle(color: Colors.white, fontSize: centerFont),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Right icons: fixed width, no overflow
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  statusIcon(Icons.swap_horiz, () {}),
                  statusIcon(Icons.chat_bubble_outline, () {}),
                  statusIcon(Icons.settings, () {}),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// LANDSCAPE placeholder
class LandscapeTableScreen extends StatelessWidget {
  const LandscapeTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Text(
            'Landscape layout here\n(rotate to portrait)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';

import 'ui/portrait.dart';
import 'ui/tiles.dart';

void main() {
  runApp(const MyApp());
}
class TableEntry extends StatelessWidget {
  const TableEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, o) {
        return o == Orientation.portrait
            ? const PortraitTableScreen()
            : const TableScreen(); // your landscape one
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
        home: const TableEntry(),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/
