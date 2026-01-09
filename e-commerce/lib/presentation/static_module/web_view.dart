import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  Map<String, dynamic> webPages = {};
  WebView({Key? key, required this.webPages}) : super(key: key);

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  WebViewController? controller;

  @override
  void initState() {
    super.initState();

    // #docregion webview_controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            /*if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }*/
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(widget.webPages['content']['rendered']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.webPages['title']['rendered'], style: const TextStyle(color: Colors.black),)),
      body: WebViewWidget(controller: controller!),
    );
  }
}
