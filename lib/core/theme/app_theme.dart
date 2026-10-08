import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'design_tokens.dart';
import 'scheme_definition.dart';

/// Text styles of the type scale. Colors are applied by [AppTheme] (label) or
/// by the call site via `copyWith(color: context.palette.…)`.
abstract final class AppTextStyles {
  static const largeTitle = TextStyle(
    fontSize: DesignTokens.largeTitleSize,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.37,
    height: 1.2,
  );
  static const title = TextStyle(
    fontSize: DesignTokens.titleSize,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.38,
    height: 1.25,
  );
  static const headline = TextStyle(
    fontSize: DesignTokens.bodySize,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    height: 1.3,
  );
  static const body = TextStyle(
    fontSize: DesignTokens.bodySize,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.3,
  );
  static const subhead = TextStyle(
    fontSize: DesignTokens.subheadSize,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    height: 1.3,
  );
  static const footnote = TextStyle(
    fontSize: DesignTokens.footnoteSize,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    height: 1.3,
  );
}

/// Builds the app's [ThemeData]. Material is only used as an engine: ripples
/// are disabled and the platform is forced to iOS so scrolling, transitions
/// and text selection look the same on Android.
abstract final class AppTheme {
  static ThemeData build(SchemeDefinition scheme, Brightness brightness) {
    final p = AppPalette.from(scheme, brightness);
    TextStyle c(TextStyle s, [Color? color]) =>
        s.copyWith(color: color ?? p.label);
    final textTheme = TextTheme(
      displayLarge: c(AppTextStyles.largeTitle),
      headlineLarge: c(AppTextStyles.largeTitle),
      titleLarge: c(AppTextStyles.title),
      titleMedium: c(AppTextStyles.headline),
      titleSmall: c(AppTextStyles.subhead),
      bodyLarge: c(AppTextStyles.body),
      bodyMedium: c(AppTextStyles.body),
      bodySmall: c(AppTextStyles.footnote, p.secondaryLabel),
      labelLarge: c(AppTextStyles.headline),
      labelMedium: c(AppTextStyles.subhead),
      labelSmall: c(AppTextStyles.footnote, p.secondaryLabel),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      platform: TargetPlatform.iOS,
      splashFactory: NoSplash.splashFactory,
      splashColor: const Color(0x00000000),
      highlightColor: const Color(0x00000000),
      hoverColor: const Color(0x00000000),
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      dividerColor: p.separator,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: p.accent,
        onPrimary: p.onAccent,
        secondary: p.accent,
        onSecondary: p.onAccent,
        error: p.destructive,
        onError: p.onAccent,
        surface: p.card,
        onSurface: p.label,
        surfaceContainerHighest: p.cardElevated,
        outline: p.separator,
      ),
      textTheme: textTheme,
      iconTheme: IconThemeData(color: p.accent),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.accent,
        selectionHandleColor: p.accent,
        selectionColor: p.accent.withValues(alpha: 0.3),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: p.accent,
        scaffoldBackgroundColor: p.background,
        barBackgroundColor: p.barBackground,
        textTheme: CupertinoTextThemeData(
          primaryColor: p.accent,
          textStyle: c(AppTextStyles.body),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.label,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: c(AppTextStyles.headline),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(p.card),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.success : p.fill,
        ),
      ),
      extensions: [p],
    );
  }
}
