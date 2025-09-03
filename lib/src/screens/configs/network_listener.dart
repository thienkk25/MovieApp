import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';

class NetworkListener extends StatefulWidget {
  final Widget child;
  const NetworkListener({super.key, required this.child});

  @override
  State<NetworkListener> createState() => _NetworkListenerState();
}

class _NetworkListenerState extends State<NetworkListener> {
  late final Connectivity connectivity;
  late final Stream<List<ConnectivityResult>> subscription;
  bool firstTime = true;
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    connectivity = Connectivity();
    subscription = connectivity.onConnectivityChanged;

    subscription.listen((results) {
      if (!mounted) return;

      bool isOffline = results.contains(ConnectivityResult.none);

      if (firstTime) {
        firstTime = false;

        if (isOffline) {
          OverlayScreen().showOverlay(
            context,
            'errors.network'.tr(),
            Colors.red,
            duration: 600,
          );
        }
        return;
      }

      if (isOffline) {
        OverlayScreen().showOverlay(
          context,
          'errors.network'.tr(),
          Colors.red,
          duration: 600,
        );
      } else {
        OverlayScreen().removeOverlay();
        OverlayScreen().showOverlay(
          context,
          'success.network'.tr(),
          Colors.green,
          duration: 3,
        );
      }
    });
  }

  @override
  void dispose() {
    OverlayScreen().removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
