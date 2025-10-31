import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OverlayScreen {
  static final OverlayScreen _instance = OverlayScreen._internal();
  factory OverlayScreen() => _instance;
  OverlayScreen._internal();

  OverlayEntry? overlayEntry;

  void showOverlay(BuildContext context, String message, Color color,
      {int duration = 0}) {
    removeOverlay();

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 15,
        left: 40,
        right: 40,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ).animate().slideY(duration: 300.ms),
    );

    Overlay.of(context, rootOverlay: true).insert(overlayEntry!);

    if (duration > 0) {
      Future.delayed(Duration(seconds: duration), () => removeOverlay());
    }
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void hideOverlay() => removeOverlay();
}
