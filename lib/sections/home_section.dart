import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

    final headlineStyle = GoogleFonts.cairo(
      textStyle: (isMobile ? Theme.of(context).textTheme.headlineMedium : Theme.of(context).textTheme.displaySmall)
          ?.copyWith(color: Brand.green),
    );

    final subStyle = (isMobile ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleLarge)
        ?.copyWith(height: 1.25);

    final gridCount = isMobile ? 2 : 4;
    final valueBoxWidth = isMobile ? 64.0 : 72.0; // fixed width for animated number

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
            _StatCard(label: labels['students']!, value: values['students']!, valueBoxWidth: valueBoxWidth),
            _StatCard(label: labels['weeklyClasses']!, value: values['weeklyClasses']!, valueBoxWidth: valueBoxWidth),
            _StatCard(label: labels['volunteers']!, value: values['volunteers']!, valueBoxWidth: valueBoxWidth),
            _StatCard(label: labels['years']!, value: values['years']!, valueBoxWidth: valueBoxWidth),
          ],
        ),

        SizedBox(height: isMobile ? 20 : 28),

        // Donate button: full width on mobile, normal on desktop
        Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 260,
            ),
            child: SizedBox(
              width: isMobile ? double.infinity : null,
              child: FilledButton(
                onPressed: () {
                  // scrolling handled in LandingPage; leave as-is or pass a callback later
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                child: Text(HomeContent.donateCta(locale)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated number with locked width & tabular digits (no layout shift)
class _StatCard extends StatelessWidget {
  final String label, value;
  final double valueBoxWidth;
  const _StatCard({
    required this.label,
    required this.value,
    required this.valueBoxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final target = _parseInt(value);
    final suffix = _suffixOf(value);

    final valueStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: Brand.green,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Card(
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // comfy taps on mobile
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: valueBoxWidth, // fixed width from before
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: target.toDouble()),
                duration: const Duration(milliseconds: 3000), // ⬅️ longer (2s instead of 1.1s)
                curve: Curves.easeOutQuart, // ⬅️ smoother easing
                builder: (_, v, __) {
                  final shown = v.floor().toString(); // floor avoids jitter on last frames
                  return Text(
                    '$shown$suffix',
                    textAlign: TextAlign.center,
                    style: valueStyle,
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
