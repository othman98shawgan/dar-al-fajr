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

        // Keep your explicit ColorScheme (fine), but surfaces will come from themes below.
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
          // crisp bottom hairline instead of drop shadow
          shape: Border(
            bottom: BorderSide(color: Brand.outline, width: 1),
          ),
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
            foregroundColor: Brand.text, // higher-contrast label on yellow
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
      ),

      home: const LandingPage(),
    );
  }
}
