import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WatchMovieScreen extends StatefulWidget {
  final int episode;
  final String linkMovie;
  const WatchMovieScreen(
      {super.key, required this.episode, required this.linkMovie});

  @override
  State<WatchMovieScreen> createState() => _WatchMovieScreenState();
}

class _WatchMovieScreenState extends State<WatchMovieScreen> {
  WebViewController webViewController = WebViewController();
  @override
  void initState() {
    Uri uri = Uri.parse(widget.linkMovie);
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(uri);
    super.initState();
  }

  @override
  void dispose() {
    webViewController.clearCache();
    webViewController.clearLocalStorage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tập ${widget.episode + 1}"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () => webViewController.reload(),
                child: const Icon(Icons.refresh_rounded)),
          )
        ],
      ),
      body: Center(child: WebViewWidget(controller: webViewController)),
    );
  }
}
