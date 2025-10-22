import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme/brand.dart';
import 'pages/landing_page.dart';
import 'i18n/locale_scope.dart';

void main() {
  // Boot with default 'en' (URL ?lang= and saved prefs will override on web / after first run)
  final controller = LocaleController('he');
  runApp(LocaleScope(notifier: controller, child: const DarAlFajrApp()));
}

class DarAlFajrApp extends StatelessWidget {
  const DarAlFajrApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final controller = LocaleScope.of(context);
    final localeCode = controller.value; // 'en' | 'ar' | 'he'

    // Pick the bundled family per locale (from pubspec.yaml fonts:)
    final family = switch (localeCode) {
      'ar' => 'Cairo',
      'he' => 'Heebo',
      _ => 'Inter',
    };

    // Start from a fresh ThemeData with fontFamily set in the constructor
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: family, // <-- set here
      scaffoldBackgroundColor: Brand.bg,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Brand.green,
        onPrimary: Colors.white,
        secondary: Brand.yellow,
        onSecondary: Brand.green,
        surface: Brand.card,
        onSurface: Brand.text,
        error: Colors.red,
        onError: Colors.white,
      ),
      textTheme: ThemeData.light().textTheme.apply(fontFamily: family),
      appBarTheme: const AppBarTheme(
        backgroundColor: Brand.nav,
        foregroundColor: Brand.green,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Brand.green),
        titleTextStyle: TextStyle(
          color: Brand.green,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        shape: Border(bottom: BorderSide(color: Brand.outline, width: 1)),
      ),
      cardTheme: const CardTheme(
        color: Brand.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Brand.outline),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Brand.outline,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Brand.yellow,
          foregroundColor: Brand.text,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Brand.green,
          side: const BorderSide(color: Brand.green),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dar al-Fajr',
      locale: Locale(localeCode),
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('he')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: base,
      home: controller.isLoaded ? const LandingPage() : const SizedBox.shrink(),
    );
  }
}
