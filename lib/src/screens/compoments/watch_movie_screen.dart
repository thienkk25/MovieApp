import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WatchMovieScreen extends StatefulWidget {
  final int episode;
  final String linkMovie;

  const WatchMovieScreen({
    super.key,
    required this.episode,
    required this.linkMovie,
  });

  @override
  State<WatchMovieScreen> createState() => _WatchMovieScreenState();
}

class _WatchMovieScreenState extends State<WatchMovieScreen> {
  InAppWebViewController? controller;
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: Colors.blue),
      onRefresh: () async {
        if (!mounted) return;
        final ctrl = controller;
        if (ctrl != null) {
          await ctrl.reload();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tập ${widget.episode + 1}"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (!mounted) return;
              controller?.reload();
            },
          )
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.linkMovie)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          allowsInlineMediaPlayback: true,
          mediaPlaybackRequiresUserGesture: false,
        ),
        pullToRefreshController: pullToRefreshController,
        onWebViewCreated: (ctrl) {
          if (!mounted) return;
          controller = ctrl;
        },
        onLoadStop: (ctrl, url) {
          if (!mounted) return;
          pullToRefreshController?.endRefreshing();
        },
        onEnterFullscreen: (ctrl) {
          if (!mounted) return;
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        },
        onExitFullscreen: (ctrl) {
          if (!mounted) return;
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        },
      ),
    );
  }
}
