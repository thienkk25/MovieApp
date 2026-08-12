import 'package:flutter/widgets.dart';

/// Centralized spacing, radius, and sizing tokens.
///
/// Usage: `AppDimensions.md` for 16px spacing,
///        `AppDimensions.radiusMd` for 12px border radius.
abstract final class AppDimensions {
  // ─── Spacing ─────────────────────────────────────────
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // ─── Border Radius ───────────────────────────────────
  static const double radiusXs = 6;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusXxl = 24;
  static const double radiusFull = 999;

  // ─── Icon Sizes ──────────────────────────────────────
  static const double iconXs = 14;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;
  static const double iconXxl = 48;

  // ─── Card / Container ────────────────────────────────
  static const double cardElevation = 0;
  static const double borderWidth = 1.0;
  static const double borderWidthThick = 1.2;

  // ─── Bottom Nav Bar ──────────────────────────────────
  static const double navBarHeight = 72;
  static const double navBarMargin = 16;
  static const double navBarRadius = 24;

  // ─── Hero Carousel ───────────────────────────────────
  static const double heroHeight = 380;
  static const double heroRadius = 28;

  // ─── Movie Card ──────────────────────────────────────
  static const double movieCardWidth = 140;
  static const double movieCardHeight = 250;
  static const double movieCardRadius = 18;

  // ─── Category Pill ───────────────────────────────────
  static const double pillHeight = 42;
  static const double pillRadius = 20;

  // ─── Bottom Sheet ────────────────────────────────────
  static const double sheetRadius = 24;
  static const double sheetHandleWidth = 40;
  static const double sheetHandleHeight = 4;
}

/// Extension for responsive screen size calculations (Phone, iPad, Tablet, Desktop)
extension ResponsiveContext on BuildContext {
  bool get isTablet => MediaQuery.of(this).size.width >= 600;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1024;

  int get responsiveColumnCount {
    final width = MediaQuery.of(this).size.width;
    if (width < 600) return 2;
    if (width < 900) return 4;
    if (width < 1200) return 5;
    return 6;
  }
}
