import 'package:flutter/material.dart';

/// Semantic color system for MovieApp that supports light/dark themes.
///
/// Usage: `final colors = Theme.of(context).extension<AppColors>()!;`
/// Or shortcut: `context.appColors`
class AppColors extends ThemeExtension<AppColors> {
  // ─── Backgrounds ──────────────────────────────────────
  final Color scaffoldBg;
  final Color scaffoldBgSecondary;
  final Color appBarBg;
  final Color appBarBgSecondary;
  final Color cardBg;
  final Color surfaceBg;

  // ─── Text ─────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnAccent;

  // ─── Borders & Dividers ───────────────────────────────
  final Color border;
  final Color borderLight;
  final Color divider;

  // ─── Icons ────────────────────────────────────────────
  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconInactive;

  // ─── Accent ───────────────────────────────────────────
  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentGlow;
  final Color accentOnAccent;

  // ─── Status ───────────────────────────────────────────
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // ─── Special Badges ───────────────────────────────────
  final Color ratingColor;
  final Color newBadgeColor;

  // ─── Gradient Colors ──────────────────────────────────
  final Color gradientStart;
  final Color gradientMid;
  final Color gradientEnd;

  // ─── Header Gradient (profile/card) ───────────────────
  final Color headerGradientStart;
  final Color headerGradientMid;
  final Color headerGradientEnd;

  // ─── Search / Input ───────────────────────────────────
  final Color inputFill;
  final Color inputBorder;
  final Color inputText;
  final Color inputHint;

  // ─── Bottom Navigation ────────────────────────────────
  final Color navBarBg;
  final Color navBarBorder;
  final Color navBarShadow;

  // ─── Overlay / Sheet ──────────────────────────────────
  final Color sheetBg;
  final Color dialogBg;

  // ─── Shimmer ──────────────────────────────────────────
  final Color shimmerBase;
  final Color shimmerHighlight;

  // ─── Info tile (profile) ──────────────────────────────
  final Color infoTileGradientStart;
  final Color infoTileGradientEnd;
  final Color infoTileBorder;

  const AppColors({
    required this.scaffoldBg,
    required this.scaffoldBgSecondary,
    required this.appBarBg,
    required this.appBarBgSecondary,
    required this.cardBg,
    required this.surfaceBg,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnAccent,
    required this.border,
    required this.borderLight,
    required this.divider,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconInactive,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentGlow,
    required this.accentOnAccent,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.ratingColor,
    required this.newBadgeColor,
    required this.gradientStart,
    required this.gradientMid,
    required this.gradientEnd,
    required this.headerGradientStart,
    required this.headerGradientMid,
    required this.headerGradientEnd,
    required this.inputFill,
    required this.inputBorder,
    required this.inputText,
    required this.inputHint,
    required this.navBarBg,
    required this.navBarBorder,
    required this.navBarShadow,
    required this.sheetBg,
    required this.dialogBg,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.infoTileGradientStart,
    required this.infoTileGradientEnd,
    required this.infoTileBorder,
  });

  // ═══════════════════════════════════════════════════════
  //  DARK THEME — preserves existing hardcoded values
  // ═══════════════════════════════════════════════════════
  static const dark = AppColors(
    scaffoldBg: Color(0xFF0A0B10),
    scaffoldBgSecondary: Color(0xFF0E1017),
    appBarBg: Color(0xFF0A0B10),
    appBarBgSecondary: Color(0xFF12141F),
    cardBg: Color(0xFF151824),
    surfaceBg: Color(0xFF181B2A),

    textPrimary: Colors.white,
    textSecondary: Colors.white70,
    textTertiary: Colors.white30,
    textOnAccent: Colors.white,

    border: Color(0x14FFFFFF),
    borderLight: Color(0x1FFFFFFF),
    divider: Color(0x1AFFFFFF),

    iconPrimary: Colors.white,
    iconSecondary: Colors.white70,
    iconInactive: Colors.white30,

    accentPrimary: Color(0xFFFFC107),     // Amber
    accentSecondary: Color(0xFFFF8F00),   // Deep Orange
    accentGlow: Color(0x66FFC107),        // Amber 40% for glow
    accentOnAccent: Color(0xFF000000),    // Black text on amber

    success: Color(0xFF00E676),
    warning: Color(0xFFFFAB40),
    error: Color(0xFFFF5252),
    info: Color(0xFF448AFF),

    ratingColor: Color(0xFFFFD740),
    newBadgeColor: Color(0xFFFF5252),

    gradientStart: Color(0xFF090A0F),
    gradientMid: Color(0xFF141622),
    gradientEnd: Color(0xFF090A0F),

    headerGradientStart: Color(0xFF0F2027),
    headerGradientMid: Color(0xFF203A43),
    headerGradientEnd: Color(0xFF2C5364),

    inputFill: Color(0x0AFFFFFF),
    inputBorder: Color(0x14FFFFFF),
    inputText: Colors.white,
    inputHint: Color(0x61FFFFFF),

    navBarBg: Color(0xD90F111D),
    navBarBorder: Color(0x14FFFFFF),
    navBarShadow: Color(0x80000000),

    sheetBg: Color(0xFF141622),
    dialogBg: Color(0xFF1A1C29),

    shimmerBase: Color(0xFF2A2D3A),
    shimmerHighlight: Color(0xFF3D4155),

    infoTileGradientStart: Color(0xFF1E1F25),
    infoTileGradientEnd: Color(0xFF16181D),
    infoTileBorder: Colors.white12,
  );

  // ═══════════════════════════════════════════════════════
  //  LIGHT THEME — clean white/grey with orange accent
  // ═══════════════════════════════════════════════════════
  static const light = AppColors(
    scaffoldBg: Color(0xFFF5F6FA),
    scaffoldBgSecondary: Color(0xFFF0F1F5),
    appBarBg: Color(0xFFFFFFFF),
    appBarBgSecondary: Color(0xFFF5F6FA),
    cardBg: Color(0xFFFFFFFF),
    surfaceBg: Color(0xFFFFFFFF),

    textPrimary: Color(0xFF1A1C2B),
    textSecondary: Color(0xFF5A5D72),
    textTertiary: Color(0xFF9A9DB0),
    textOnAccent: Colors.white,

    border: Color(0xFFE0E2EB),
    borderLight: Color(0xFFEBEDF5),
    divider: Color(0xFFE8E9F0),

    iconPrimary: Color(0xFF1A1C2B),
    iconSecondary: Color(0xFF5A5D72),
    iconInactive: Color(0xFFB0B3C5),

    accentPrimary: Color(0xFFFF9800),     // Orange
    accentSecondary: Color(0xFFE65100),   // Deep Orange
    accentGlow: Color(0x33FF9800),        // Orange 20% for glow
    accentOnAccent: Colors.white,

    success: Color(0xFF2E7D32),
    warning: Color(0xFFEF6C00),
    error: Color(0xFFC62828),
    info: Color(0xFF1565C0),

    ratingColor: Color(0xFFFFA000),
    newBadgeColor: Color(0xFFE53935),

    gradientStart: Color(0xFFF5F6FA),
    gradientMid: Color(0xFFFFFFFF),
    gradientEnd: Color(0xFFF5F6FA),

    headerGradientStart: Color(0xFF1B3A4B),
    headerGradientMid: Color(0xFF2A5568),
    headerGradientEnd: Color(0xFF3A7085),

    inputFill: Color(0xFFF0F1F5),
    inputBorder: Color(0xFFE0E2EB),
    inputText: Color(0xFF1A1C2B),
    inputHint: Color(0xFFB0B3C5),

    navBarBg: Color(0xF2FFFFFF),
    navBarBorder: Color(0xFFE0E2EB),
    navBarShadow: Color(0x1A000000),

    sheetBg: Color(0xFFFFFFFF),
    dialogBg: Color(0xFFFFFFFF),

    shimmerBase: Color(0xFFE0E2EB),
    shimmerHighlight: Color(0xFFF5F6FA),

    infoTileGradientStart: Color(0xFFF0F1F5),
    infoTileGradientEnd: Color(0xFFE8E9F0),
    infoTileBorder: Color(0xFFE0E2EB),
  );

  @override
  AppColors copyWith({
    Color? scaffoldBg,
    Color? scaffoldBgSecondary,
    Color? appBarBg,
    Color? appBarBgSecondary,
    Color? cardBg,
    Color? surfaceBg,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textOnAccent,
    Color? border,
    Color? borderLight,
    Color? divider,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? iconInactive,
    Color? accentPrimary,
    Color? accentSecondary,
    Color? accentGlow,
    Color? accentOnAccent,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? ratingColor,
    Color? newBadgeColor,
    Color? gradientStart,
    Color? gradientMid,
    Color? gradientEnd,
    Color? headerGradientStart,
    Color? headerGradientMid,
    Color? headerGradientEnd,
    Color? inputFill,
    Color? inputBorder,
    Color? inputText,
    Color? inputHint,
    Color? navBarBg,
    Color? navBarBorder,
    Color? navBarShadow,
    Color? sheetBg,
    Color? dialogBg,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? infoTileGradientStart,
    Color? infoTileGradientEnd,
    Color? infoTileBorder,
  }) {
    return AppColors(
      scaffoldBg: scaffoldBg ?? this.scaffoldBg,
      scaffoldBgSecondary: scaffoldBgSecondary ?? this.scaffoldBgSecondary,
      appBarBg: appBarBg ?? this.appBarBg,
      appBarBgSecondary: appBarBgSecondary ?? this.appBarBgSecondary,
      cardBg: cardBg ?? this.cardBg,
      surfaceBg: surfaceBg ?? this.surfaceBg,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      divider: divider ?? this.divider,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      iconInactive: iconInactive ?? this.iconInactive,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      accentGlow: accentGlow ?? this.accentGlow,
      accentOnAccent: accentOnAccent ?? this.accentOnAccent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      ratingColor: ratingColor ?? this.ratingColor,
      newBadgeColor: newBadgeColor ?? this.newBadgeColor,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientMid: gradientMid ?? this.gradientMid,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      headerGradientStart: headerGradientStart ?? this.headerGradientStart,
      headerGradientMid: headerGradientMid ?? this.headerGradientMid,
      headerGradientEnd: headerGradientEnd ?? this.headerGradientEnd,
      inputFill: inputFill ?? this.inputFill,
      inputBorder: inputBorder ?? this.inputBorder,
      inputText: inputText ?? this.inputText,
      inputHint: inputHint ?? this.inputHint,
      navBarBg: navBarBg ?? this.navBarBg,
      navBarBorder: navBarBorder ?? this.navBarBorder,
      navBarShadow: navBarShadow ?? this.navBarShadow,
      sheetBg: sheetBg ?? this.sheetBg,
      dialogBg: dialogBg ?? this.dialogBg,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      infoTileGradientStart:
          infoTileGradientStart ?? this.infoTileGradientStart,
      infoTileGradientEnd: infoTileGradientEnd ?? this.infoTileGradientEnd,
      infoTileBorder: infoTileBorder ?? this.infoTileBorder,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      scaffoldBg: Color.lerp(scaffoldBg, other.scaffoldBg, t)!,
      scaffoldBgSecondary:
          Color.lerp(scaffoldBgSecondary, other.scaffoldBgSecondary, t)!,
      appBarBg: Color.lerp(appBarBg, other.appBarBg, t)!,
      appBarBgSecondary:
          Color.lerp(appBarBgSecondary, other.appBarBgSecondary, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      surfaceBg: Color.lerp(surfaceBg, other.surfaceBg, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textOnAccent: Color.lerp(textOnAccent, other.textOnAccent, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      iconInactive: Color.lerp(iconInactive, other.iconInactive, t)!,
      accentPrimary: Color.lerp(accentPrimary, other.accentPrimary, t)!,
      accentSecondary: Color.lerp(accentSecondary, other.accentSecondary, t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
      accentOnAccent: Color.lerp(accentOnAccent, other.accentOnAccent, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      ratingColor: Color.lerp(ratingColor, other.ratingColor, t)!,
      newBadgeColor: Color.lerp(newBadgeColor, other.newBadgeColor, t)!,
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientMid: Color.lerp(gradientMid, other.gradientMid, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
      headerGradientStart:
          Color.lerp(headerGradientStart, other.headerGradientStart, t)!,
      headerGradientMid:
          Color.lerp(headerGradientMid, other.headerGradientMid, t)!,
      headerGradientEnd:
          Color.lerp(headerGradientEnd, other.headerGradientEnd, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputText: Color.lerp(inputText, other.inputText, t)!,
      inputHint: Color.lerp(inputHint, other.inputHint, t)!,
      navBarBg: Color.lerp(navBarBg, other.navBarBg, t)!,
      navBarBorder: Color.lerp(navBarBorder, other.navBarBorder, t)!,
      navBarShadow: Color.lerp(navBarShadow, other.navBarShadow, t)!,
      sheetBg: Color.lerp(sheetBg, other.sheetBg, t)!,
      dialogBg: Color.lerp(dialogBg, other.dialogBg, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight:
          Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      infoTileGradientStart:
          Color.lerp(infoTileGradientStart, other.infoTileGradientStart, t)!,
      infoTileGradientEnd:
          Color.lerp(infoTileGradientEnd, other.infoTileGradientEnd, t)!,
      infoTileBorder: Color.lerp(infoTileBorder, other.infoTileBorder, t)!,
    );
  }
}

/// Convenience extension to access AppColors from BuildContext.
extension AppColorsExtension on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}

