import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme/brand.dart';
import 'pages/landing_page.dart';
import 'i18n/locale_scope.dart';

void main() {
  // Boot with default 'en' (URL ?lang= and saved prefs will override on web / after first run)
  final controller = LocaleController('en');
  runApp(LocaleScope(notifier: controller, child: const DarAlFajrApp()));
}

class DarAlFajrApp extends StatelessWidget {
  const DarAlFajrApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: Brand.text,
      displayColor: Brand.green,
    );

    final localeCode = LocaleScope.of(context).value; // 'en' | 'ar' | 'he'

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dar al-Fajr',

      // Tell Flutter which locale we’re using (drives RTL, formats, etc.)
      locale: Locale(localeCode),
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('he'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: base.copyWith(
        textTheme: textTheme,
        scaffoldBackgroundColor: Brand.bg,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Brand.green,
          onPrimary: Colors.white,
          secondary: Brand.yellow,
          onSecondary: Brand.green,
          surface: Colors.white,
          onSurface: Brand.text,
          background: Brand.bg,
          onBackground: Brand.text,
          error: Colors.red,
          onError: Colors.white,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Brand.yellow,
            foregroundColor: Brand.green,
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
        cardTheme: const CardTheme(
          elevation: 0.5,
          surfaceTintColor: Colors.transparent,
          clipBehavior: Clip.antiAlias,
        ),
      ),

      home: const LandingPage(),
    );
  }
}
