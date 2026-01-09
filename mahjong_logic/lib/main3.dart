import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

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

/// Routes to portrait vs landscape.
/// Replace LandscapeTableScreen with your real landscape screen later.
class TableEntry extends StatelessWidget {
  const TableEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (_, o) => o == Orientation.portrait
          ? const PortraitTableScreenResponsive()
          : const LandscapeTableScreen(),
    );
  }
}

class PortraitTableScreenResponsive extends StatelessWidget {
  const PortraitTableScreenResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Layout tuning with clamps so it looks sane across phones/tablets.
    final topBarH = 56.0;
    final opponentH = (size.height * 0.12).clamp(90.0, 140.0);
    final actionsH = (size.height * 0.09).clamp(70.0, 110.0);
    final statusH = 56.0;
    final exposedH = (size.height * 0.07).clamp(56.0, 90.0);
    final handH = (size.height * 0.12).clamp(100.0, 160.0);
    final bottomLabelH = 44.0;

    // Tile sizing based on width (for later when you render real tiles)
    final tileW = ((size.width - 32) / 12).clamp(44.0, 66.0);
    final tileH = tileW * 1.25;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            // Turquoise frame
            decoration: BoxDecoration(
              color: const Color(0xFF00E6E6),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Container(
              // Inner felt background
              decoration: BoxDecoration(
                color: const Color(0xFF3D5972),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Top title
                  SizedBox(
                    height: topBarH,
                    child: _TopTitleBar(title: 'Computer 1'),
                  ),

                  // Opponent area
                  SizedBox(
                    height: opponentH,
                    child: _OpponentArea(tileW: tileW, tileH: tileH),
                  ),

                  // Main play area: side players + felt
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          // Left mini player
                          SizedBox(
                            width: (size.width * 0.14).clamp(64.0, 100.0),
                            child: const _MiniSidePlayer(label: 'linda', score: '2025'),
                          ),

                          const SizedBox(width: 10),

                          // Center felt (biggest)
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF3D5972),
                                border: Border.all(color: Colors.black, width: 5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'PLAY AREA',
                                  style: TextStyle(color: Colors.white54, fontSize: 16, letterSpacing: 1.5),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Right mini player
                          SizedBox(
                            width: (size.width * 0.14).clamp(64.0, 100.0),
                            child: const _MiniSidePlayer(label: 'carol', score: '100'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Actions
                  SizedBox(
                    height: actionsH,
                    child: const _ActionButtonsRow(),
                  ),

                  // Status bar
                  SizedBox(
                    height: statusH,
                    child: const _StatusBar(),
                  ),

                  // Exposed melds strip
                  SizedBox(
                    height: exposedH,
                    child: _PurpleStrip(
                      label: 'Exposed melds',
                      hint: 'tiles here',
                      big: false,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Hand strip (dominant)
                  SizedBox(
                    height: handH,
                    child: _PurpleStrip(
                      label: 'Your hand',
                      hint: 'big tiles here',
                      big: true,
                    ),
                  ),

                  // Bottom player name
                  SizedBox(
                    height: bottomLabelH,
                    child: const Center(
                      child: Text(
                        'marilyn (4370)',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
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
        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _OpponentArea extends StatelessWidget {
  final double tileW;
  final double tileH;
  const _OpponentArea({required this.tileW, required this.tileH});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF00E6E6),
        border: Border.all(color: const Color(0xFF2B3C4A), width: 8),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // opponent name row could go here if you want
          Expanded(
            child: Row(
              children: [
                Expanded(child: _FakeTileRow(count: 6, tileW: tileW * 0.75, tileH: tileH * 0.75)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _FakeTileRow(count: 6, tileW: tileW * 0.75, tileH: tileH * 0.75)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FakeTileRow extends StatelessWidget {
  final int count;
  final double tileW;
  final double tileH;
  const _FakeTileRow({required this.count, required this.tileW, required this.tileH});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) => Container(
        width: tileW,
        height: tileH,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2),
        ),
        alignment: Alignment.center,
        child: Text('T${i + 1}', style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}

class _MiniSidePlayer extends StatelessWidget {
  final String label;
  final String score;
  const _MiniSidePlayer({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00E6E6),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            '($score)',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          const Icon(Icons.view_week, color: Colors.white, size: 26),
          const SizedBox(height: 6),
          const Text('x13', style: TextStyle(color: Colors.white70, fontSize: 12)), // tiles remaining placeholder
        ],
      ),
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  const _ActionButtonsRow();

  @override
  Widget build(BuildContext context) {
    Widget btn(String text, {required bool enabled, required Color color}) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: double.infinity,
            child: ElevatedButton(
              onPressed: enabled ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                disabledBackgroundColor: const Color(0xFFBFBFBF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: enabled ? 6 : 0,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: TextStyle(
                    color: enabled ? Colors.white : const Color(0xFFE0E0E0),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
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
        btn('Skip', enabled: false, color: const Color(0xFFBFBFBF)),
        btn('Call', enabled: false, color: const Color(0xFFBFBFBF)),
        btn('Mahj', enabled: true, color: const Color(0xFF5B5E9C)),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F2E2A),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const Icon(Icons.check_box_outline_blank, color: Colors.white, size: 20),
          const SizedBox(width: 8),

          // Left text: flexible so it never overflows
          const Flexible(
            child: Text(
              '48 tiles left',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),

          const Spacer(),

          // Center status: scales down if needed
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Pick a tile',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: 1,
                ),
              ),
            ),
          ),

          const Spacer(),

          _StatusIconButton(icon: Icons.swap_horiz),
          _StatusIconButton(icon: Icons.chat_bubble_outline),
          _StatusIconButton(icon: Icons.settings),
        ],
      ),
    );
  }
}

class _StatusIconButton extends StatelessWidget {
  final IconData icon;
  const _StatusIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      padding: EdgeInsets.zero,
      splashRadius: 24,
      tooltip: '',
    );
  }
}

class _PurpleStrip extends StatelessWidget {
  final String label;
  final String hint;
  final bool big;

  const _PurpleStrip({required this.label, required this.hint, required this.big});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF9A63FF),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontSize: big ? 18 : 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black87,
                fontSize: big ? 16 : 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder landscape
class LandscapeTableScreen extends StatelessWidget {
  const LandscapeTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Text(
            'Landscape layout goes here',
            style: TextStyle(color: Colors.white),
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
