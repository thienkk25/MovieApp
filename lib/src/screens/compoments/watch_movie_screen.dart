import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/services/riverpod_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WatchMovieScreen extends ConsumerStatefulWidget {
  const WatchMovieScreen({
    super.key,
  });

  @override
  ConsumerState<WatchMovieScreen> createState() => _WatchMovieScreenState();
}

class _WatchMovieScreenState extends ConsumerState<WatchMovieScreen> {
  InAppWebViewController? controller;
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
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
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final link = ref.watch(isClickLWatchEpisodeLinkMovies);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller != null && link != null) {
        controller!.loadUrl(
          urlRequest: URLRequest(url: WebUri(link)),
        );
      }
    });
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(link!)),
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
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
    );
  }
}
