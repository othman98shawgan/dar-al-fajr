import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';

import '../i18n/locale_scope.dart';
import '../theme/brand.dart';
import '../content/site_content.dart';

class HomeSection extends StatelessWidget {
  final AppLocale locale;
  const HomeSection({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 700; // breakpoints: <700 mobile, 700–1100 tablet, >1100 desktop

    final labels = HomeContent.statsLabels(locale);
    final values = HomeContent.statsValues;

    // split hadith -> intro + quote
    final hadithText = t(HomeContent.hadith, locale).split('\n');
    final intro = hadithText.length > 1 ? hadithText.first : '';
    final quote = hadithText.length > 1 ? hadithText.sublist(1).join('\n') : hadithText.first;

    final tt = Theme.of(context).textTheme;
    final base = isMobile ? tt.headlineMedium : tt.displaySmall;

    final headlineStyle = (base ?? tt.titleLarge)?.copyWith(
      color: Brand.green,
      fontWeight: FontWeight.w700, // optional
      letterSpacing: 0.1, // optional
    );

    final subStyle = (isMobile ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleLarge)
        ?.copyWith(height: 1.25);

    final gridCount = isMobile ? 2 : 4;
    final valueBoxWidth = isMobile ? 80.0 : 96.0; // fixed width for animated number

    return Column(
      children: [
        if (intro.isNotEmpty)
          Text(
            intro,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Brand.green,
                  letterSpacing: 0.25,
                ),
          ),
        // Hadith (hero)
        Text(quote, textAlign: TextAlign.center, style: headlineStyle),
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
                label: labels['students']!, value: values['students']!, valueBoxWidth: valueBoxWidth, forcePlus: true),
            _StatCard(
                label: labels['weeklyClasses']!,
                value: values['weeklyClasses']!,
                valueBoxWidth: valueBoxWidth,
                forcePlus: true),
            _StatCard(
                label: labels['volunteers']!,
                value: values['volunteers']!,
                valueBoxWidth: valueBoxWidth,
                forcePlus: true),
            _StatCard(label: labels['years']!, value: values['years']!, valueBoxWidth: valueBoxWidth),
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
    this.forcePlus = false, // default off
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
