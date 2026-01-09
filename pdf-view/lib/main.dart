// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

/*
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _pdfPath;
  // final _receiveSharingIntent = ReceiveSharingIntent();

  // @override
  // void initState() {
  //   super.initState();
  //
  //   // Handle cold start (app opened via "Open with")
  //   _receiveSharingIntent.getInitialMedia().then((files) {
  //     if (files.isNotEmpty) {
  //       setState(() => _pdfPath = files.first.path);
  //     }
  //   });
  //
  //   // Handle when app already running
  //   _receiveSharingIntent.getMediaStream().listen((files) {
  //     if (files.isNotEmpty) {
  //       setState(() => _pdfPath = files.first.path);
  //     }
  //   });
  // }

  // Pick PDF manually
  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() => _pdfPath = result.files.single.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _pdfPath == null
          ? Scaffold(
        appBar: AppBar(title: Text("PDF Viewer")),
        body: Center(
          child: ElevatedButton(
            onPressed: _pickPdf,
            child: Text("Choose PDF from Device"),
          ),
        ),
      )
          : PdfViewerPage(filePath: _pdfPath!, onPickNewPdf: _pickPdf),
    );
  }
}

class PdfViewerPage extends StatefulWidget {
  final String filePath;
  final VoidCallback onPickNewPdf;

  PdfViewerPage({required this.filePath, required this.onPickNewPdf});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  int _lastPage = 0;

  @override
  void initState() {
    super.initState();
    _loadLastPage();
  }

  Future<void> _loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastPage = prefs.getInt(widget.filePath) ?? 0;
    });
  }

  Future<void> _saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(widget.filePath, page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
        actions: [
          IconButton(
            icon: Icon(Icons.folder_open),
            onPressed: widget.onPickNewPdf,
          )
        ],
      ),
      body: SfPdfViewer.file(
        File(widget.filePath),
        key: _pdfViewerKey,
        initialPageNumber: _lastPage,
        scrollDirection: PdfScrollDirection.horizontal,
        currentSearchTextHighlightColor: Colors.yellow,
        enableDoubleTapZooming: true,
        canShowTextSelectionMenu: true,
        onPageChanged: (details) {
          _saveLastPage(details.newPageNumber);
        },
      ),
    );
  }
}
*/



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _pdfPath;
  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() => _pdfPath = result.files.single.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: _pdfPath == null
      //     ? Scaffold(
      //   appBar: AppBar(title: const Text("PDF Viewer")),
      //   body: Center(
      //     child: ElevatedButton(
      //       onPressed: _pickPdf,
      //       child: const Text("Choose PDF from Device"),
      //     ),
      //   ),
      // )
      //     : const PdfViewerPage(),
      home: PdfViewerPage(),
    );
  }
}

class PdfViewerPage extends StatefulWidget {
  // final String filePath;
  // final VoidCallback onPickNewPdf;

  const PdfViewerPage({super.key});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  late PdfTextSearchResult _searchResult;
  int _lastPage = 0;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  final String _pageKey = 'lastPage';
  // late PdfViewerController _pdfController;
  int _currentPage = 1;
  bool _isLoaded = false;


  @override
  void initState() {
    super.initState();
    _searchResult = PdfTextSearchResult();
    _loadLastPage();
  }

  // Future<void> _loadLastPage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _lastPage = prefs.getInt(widget.filePath) ?? 0;
  //   });
  // }

  Future<void> _loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPage = prefs.getInt(_pageKey) ?? 1;
    setState(() {
      _currentPage = lastPage;
    });
    _isLoaded = true;
    _pdfViewerController.jumpToPage(lastPage);
  }

  Future<void> _saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pageKey, page);
  }

  void _startSearch(String query) {
    setState(() {
      _searchResult = _pdfViewerController.searchText(query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchResult.clear();
    setState(() => _isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search text...",
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: _startSearch,
        )
            : const Text("PDF Viewer"),
        actions: [
          if (_isSearching)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up),
                  onPressed: () => _searchResult.previousInstance(),
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onPressed: () => _searchResult.nextInstance(),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearSearch,
                ),
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _isSearching = true),
            ),
          // IconButton(
          //   icon: const Icon(Icons.folder_open),
          //   onPressed: () {
          //     _showJumpToPageDialog(context);
          //   },
          // ),
        ],
      ),
      body: SfPdfViewer.asset("assets/files/flutter_tutorial.pdf",
        key: _pdfViewerKey,
        controller: _pdfViewerController,
        initialPageNumber: _lastPage,
        scrollDirection: PdfScrollDirection.horizontal,
        enableTextSelection: true,
        currentSearchTextHighlightColor: Colors.yellow.withOpacity(0.3),
        enableDoubleTapZooming: true,
        onPageChanged: (details) {
          _currentPage = details.newPageNumber;
          _saveLastPage(_currentPage);
        },
      ),
    );
  }

  // Future<int?> _showJumpToPageDialog(BuildContext context) async {
  //   final controller = TextEditingController();
  //   return showDialog<int>(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text('Go to Page'),
  //       content: TextField(
  //         controller: controller,
  //         keyboardType: TextInputType.number,
  //         decoration: const InputDecoration(hintText: 'Enter page number'),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             final page = int.tryParse(controller.text);
  //             Navigator.pop(context, page);
  //           },
  //           child: const Text('Go'),
  //         ),
  //       ],
  //     ),
  //   );
  // }


}

