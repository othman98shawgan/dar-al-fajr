import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';

import '../i18n/locale_scope.dart';
import '../theme/brand.dart';
import '../content/site_content.dart';

class HomeSection extends StatelessWidget {
  final AppLocale locale;
  const HomeSection({super.key, required this.locale});

  Text _arabicWithMark(String text, TextStyle? baseStyle) {
    // U+FDFA “ﷺ”
    const mark = '\uFDFA';
    final parts = text.split(mark);
    final s = (baseStyle ?? const TextStyle()).copyWith(
      // your hadith base stays Cairo (or whatever you already use)
      fontFamily: 'Cairo',
      letterSpacing: 0,
    );

    // Build spans: normal text in Cairo, the mark in ScheherazadeNew
    final spans = <InlineSpan>[];
    for (var i = 0; i < parts.length; i++) {
      if (i > 0) {
        spans.add(TextSpan(
          text: ' $mark', // include a thin space before if you like
          style: s.copyWith(fontFamily: 'ScheherazadeNew', fontWeight: FontWeight.w700),
        ));
      }
      spans.add(TextSpan(text: parts[i], style: s));
    }

    return Text.rich(TextSpan(children: spans), textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 700; // breakpoints: <700 mobile, 700–1100 tablet, >1100 desktop

    final labels = HomeContent.statsLabels(locale);
    final values = HomeContent.statsValues;

    // --- Always fetch Arabic hadith (for the main line) ---
    List<String> _splitLines(String s) => s.split('\n');
    final hadithArLines = _splitLines(t(HomeContent.hadith, 'ar'));
    final arIntro = hadithArLines.length > 1 ? hadithArLines.first : '';
    final arQuote = hadithArLines.length > 1 ? hadithArLines.sublist(1).join('\n') : hadithArLines.first;

    // --- Translation only when locale is he/en ---
    final showTranslation = locale == 'he' || locale == 'en';
    final hadithTrLines = showTranslation ? _splitLines(t(HomeContent.hadith, locale)) : const <String>[];
    final trIntro = showTranslation && hadithTrLines.length > 1 ? hadithTrLines.first : '';
    final trQuote = showTranslation && hadithTrLines.isNotEmpty
        ? (hadithTrLines.length > 1 ? hadithTrLines.sublist(1).join('\n') : hadithTrLines.first)
        : '';

    final tt = Theme.of(context).textTheme;

    // Base headline sizes by screen
    final base = isMobile ? tt.headlineMedium : tt.displaySmall;

    // Arabic headline: force Cairo family so it looks correct on en/he pages too.
    final arabicHeadlineStyle = (base ?? tt.titleLarge)?.copyWith(
      color: Brand.green,
      fontWeight: FontWeight.w700,
      letterSpacing: 0, // Arabic: no extra letter spacing
      fontFamily: 'Cairo', // <- ensure Arabic font even if app locale is en/he
      height: 1.25,
    );

    // Arabic intro (small, green label style)
    final arabicIntroStyle = tt.labelLarge?.copyWith(
      color: Brand.green,
      letterSpacing: 0,
      fontFamily: 'Cairo',
    );
    final trBase = isMobile ? tt.titleMedium : tt.titleLarge;

    // Translation style: smaller than headline, neutral color
    final translationStyle = trBase?.copyWith(
      height: 1.35,
      // For Hebrew we usually avoid letter spacing; English can keep defaults

      color: Brand.green.withValues(alpha: 0.9),

      letterSpacing: locale == 'he' ? 0 : null,
      // No fontFamily here: theme already uses Heebo for he, Inter for en
    );

    final translationIntroStyle = (tt.labelLarge ?? trBase)?.copyWith(
      height: 1.35,
      fontSize: (trBase?.fontSize ?? (isMobile ? 18 : 22)) - 2,
      letterSpacing: locale == 'he' ? 0 : null,
      color: Brand.text.withOpacity(0.8),
    );

    final subStyle = (isMobile ? tt.titleMedium : tt.titleLarge)?.copyWith(height: 1.25);

    final gridCount = isMobile ? 2 : 4;
    final valueBoxWidth = isMobile ? 80.0 : 96.0; // fixed width for animated number

    return Column(
      children: [
        // --- Arabic intro (if present) ---
        if (arIntro.isNotEmpty)
          Directionality(
            textDirection: TextDirection.rtl,
            child: _arabicWithMark(
              arIntro,
              tt.labelLarge?.copyWith(color: Brand.green),
            ),
          ),

        // Arabic hadith (always)
        Directionality(
          textDirection: TextDirection.rtl,
          child: _arabicWithMark(
            arQuote,
            (base ?? tt.titleLarge)?.copyWith(
              color: Brand.green,
              fontWeight: FontWeight.w700,
              height: 1.35,
              // leave fontFamily off here (helper sets Cairo for body, Scheherazade for the mark)
            ),
          ),
        ),

        // --- Translation (only on he/en) ---
        if (showTranslation && (trIntro.isNotEmpty || trQuote.isNotEmpty)) ...[
          const SizedBox(height: 10),
          Directionality(
            textDirection: locale == 'he' ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              children: [
                if (trIntro.isNotEmpty) Text(trIntro, textAlign: TextAlign.center, style: translationIntroStyle),
                if (trQuote.isNotEmpty) Text(trQuote, textAlign: TextAlign.center, style: translationStyle),
              ],
            ),
          ),
        ],

        const SizedBox(height: 12),

        // Subtitle (slightly softer on mobile)
        Text(t(HomeContent.subtitle, locale), textAlign: TextAlign.center, style: subStyle),
        SizedBox(height: isMobile ? 20 : 28),

        // Stats grid (2x2 mobile, 4 across desktop)
        GridView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isMobile ? 1.6 : 1.9,
          ),
          children: [
            _StatCard(
              label: labels['students']!,
              value: values['students']!,
              valueBoxWidth: valueBoxWidth,
              forcePlus: true,
            ),
            _StatCard(
              label: labels['weeklyClasses']!,
              value: values['weeklyClasses']!,
              valueBoxWidth: valueBoxWidth,
              forcePlus: true,
            ),
            _StatCard(
              label: labels['volunteers']!,
              value: values['volunteers']!,
              valueBoxWidth: valueBoxWidth,
              forcePlus: true,
            ),
            _StatCard(
              label: labels['years']!,
              value: values['years']!,
              valueBoxWidth: valueBoxWidth,
            ),
          ],
        ),
      ],
    );
  }
}

/// Animated number with locked width & tabular digits (no layout shift)
class _StatCard extends StatelessWidget {
  final String label, value;
  final double valueBoxWidth;
  final bool forcePlus;

  const _StatCard({
    required this.label,
    required this.value,
    required this.valueBoxWidth,
    this.forcePlus = false,
  });

  @override
  Widget build(BuildContext context) {
    final target = _parseInt(value);
    final baseSuffix = _suffixOf(value);
    final suffix = forcePlus ? (baseSuffix.contains('+') ? baseSuffix : '$baseSuffix+') : baseSuffix;

    final valueStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: Brand.green,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Card(
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: valueBoxWidth,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: target.toDouble()),
                duration: const Duration(milliseconds: 3000),
                curve: Curves.easeOutQuart,
                builder: (_, v, __) {
                  final shown = v.floor().toString();
                  return Text(
                    '$shown$suffix',
                    textAlign: TextAlign.center,
                    style: valueStyle,
                    maxLines: 1,
                    softWrap: false,
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  int _parseInt(String s) {
    final m = RegExp(r'\d+').firstMatch(s);
    if (m == null) return 0;
    return int.parse(m.group(0)!);
  }

  String _suffixOf(String s) => s.replaceAll(RegExp(r'\d+'), '');
}
