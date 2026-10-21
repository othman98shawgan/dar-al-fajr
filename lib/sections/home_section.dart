import 'package:flutter/material.dart';

import '../i18n/locale_scope.dart';
import '../theme/brand.dart';
import '../content/site_content.dart';

class HomeSection extends StatelessWidget {
  final AppLocale locale;
  final VoidCallback? onDonateTap;
  final VoidCallback? onAboutTap;

  const HomeSection({
    super.key,
    required this.locale,
    this.onDonateTap,
    this.onAboutTap,
  });

  Text _arabicWithMark(String text, TextStyle? baseStyle) {
    // U+FDFA “ﷺ”
    const mark = '\uFDFA';
    final parts = text.split(mark);
    final s = (baseStyle ?? const TextStyle()).copyWith(
      fontFamily: 'Cairo',
      letterSpacing: 0,
    );

    final spans = <InlineSpan>[];
    for (var i = 0; i < parts.length; i++) {
      if (i > 0) {
        spans.add(TextSpan(
          text: ' $mark',
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
    final isMobile = w < 750;

    final labels = HomeContent.statsLabels(locale);
    final values = HomeContent.statsValues;

    List<String> splitLines(String s) => s.split('\n');
    final hadithArLines = splitLines(t(HomeContent.hadith, 'ar'));
    final arIntro = hadithArLines.length > 1 ? hadithArLines.first : '';
    final arQuote = hadithArLines.length > 1 ? hadithArLines.sublist(1).join('\n') : hadithArLines.first;

    final showTranslation = locale == 'he' || locale == 'en';
    final hadithTrLines = showTranslation ? splitLines(t(HomeContent.hadith, locale)) : const <String>[];
    final trIntro = showTranslation && hadithTrLines.length > 1 ? hadithTrLines.first : '';
    final trQuote = showTranslation && hadithTrLines.isNotEmpty
        ? (hadithTrLines.length > 1 ? hadithTrLines.sublist(1).join('\n') : hadithTrLines.first)
        : '';

    final tt = Theme.of(context).textTheme;
    final base = isMobile ? tt.headlineMedium : tt.displaySmall;
    final trBase = isMobile ? tt.titleMedium : tt.titleLarge;

    final translationStyle = trBase?.copyWith(
      height: 1.4,
      color: Colors.white.withValues(alpha: 0.95),
      fontWeight: FontWeight.w600,
      letterSpacing: locale == 'he' ? 0 : null,
    );

    final translationIntroStyle = (tt.labelLarge ?? trBase)?.copyWith(
      height: 1.35,
      fontSize: (trBase?.fontSize ?? (isMobile ? 18 : 22)) - 2,
      letterSpacing: locale == 'he' ? 0 : null,
      color: Colors.white.withValues(alpha: 0.8),
    );

    final subStyle = (isMobile ? tt.bodyLarge : tt.titleMedium)?.copyWith(
      height: 1.45,
      color: Colors.white.withValues(alpha: 0.9),
    );

    final statEntries = <_StatEntry>[
      _StatEntry(
        icon: Icons.school_rounded,
        label: labels['students']!,
        value: values['students']!,
        forcePlus: true,
      ),
      _StatEntry(
        icon: Icons.menu_book_rounded,
        label: labels['weeklyClasses']!,
        value: values['weeklyClasses']!,
        forcePlus: true,
      ),
      _StatEntry(
        icon: Icons.groups_rounded,
        label: labels['volunteers']!,
        value: values['volunteers']!,
        forcePlus: true,
      ),
      _StatEntry(
        icon: Icons.verified_rounded,
        label: labels['years']!,
        value: values['years']!,
        forcePlus: false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Hero Banner Container in Deep Teal (#1D6363)
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Brand.green,
                Color(0xFF144A4A),
              ],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x181D6363),
                blurRadius: 28,
                offset: Offset(0, 12),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 48,
            vertical: isMobile ? 32 : 52,
          ),
          child: Column(
            children: [
              // Registered Non-Profit Amuta Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Brand.yellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        t(ContentConfig.amutaBadge, locale),
                        style: tt.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 20 : 28),

              // Arabic intro (if present)
              if (arIntro.isNotEmpty)
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: _arabicWithMark(
                    arIntro,
                    tt.labelLarge?.copyWith(color: Brand.yellow),
                  ),
                ),

              // Main Arabic Hadith Quote
              Directionality(
                textDirection: TextDirection.rtl,
                child: _arabicWithMark(
                  arQuote,
                  (base ?? tt.titleLarge)?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
              ),

              // Translation (on he/en)
              if (showTranslation && (trIntro.isNotEmpty || trQuote.isNotEmpty)) ...[
                const SizedBox(height: 12),
                Directionality(
                  textDirection: locale == 'he' ? TextDirection.rtl : TextDirection.ltr,
                  child: Column(
                    children: [
                      if (trIntro.isNotEmpty)
                        Text(trIntro, textAlign: TextAlign.center, style: translationIntroStyle),
                      if (trQuote.isNotEmpty)
                        Text(trQuote, textAlign: TextAlign.center, style: translationStyle),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Subtitle
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  t(HomeContent.subtitle, locale),
                  textAlign: TextAlign.center,
                  style: subStyle,
                ),
              ),

              SizedBox(height: isMobile ? 24 : 32),

              // Above-the-fold CTAs: High-contrast Golden Yellow (#F2C924) primary CTA + Secondary CTA
              Wrap(
                spacing: 14,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: onDonateTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: Brand.yellow,
                      foregroundColor: Brand.green,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : 30,
                        vertical: isMobile ? 14 : 18,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.volunteer_activism_rounded, color: Brand.green, size: 22),
                    label: Text(
                      HomeContent.donateCta(locale),
                      style: tt.titleMedium?.copyWith(
                        color: Brand.green,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (onAboutTap != null)
                    OutlinedButton.icon(
                      onPressed: onAboutTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.45)),
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : 26,
                          vertical: isMobile ? 14 : 18,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.auto_stories_outlined, color: Colors.white, size: 20),
                      label: Text(
                        t(HomeContent.secondaryCta, locale),
                        style: tt.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 4-Column Intrinsic-Height Stat Cards (Flex + IntrinsicHeight — no rigid GridView)
        _ResponsiveStatsBar(entries: statEntries, isMobile: isMobile),
      ],
    );
  }
}

class _StatEntry {
  final IconData icon;
  final String label;
  final String value;
  final bool forcePlus;

  const _StatEntry({
    required this.icon,
    required this.label,
    required this.value,
    this.forcePlus = false,
  });
}

class _ResponsiveStatsBar extends StatelessWidget {
  final List<_StatEntry> entries;
  final bool isMobile;

  const _ResponsiveStatsBar({
    required this.entries,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      // 2x2 IntrinsicHeight rows on mobile
      return Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _StatCard(entry: entries[0], isMobile: true)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(entry: entries[1], isMobile: true)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _StatCard(entry: entries[2], isMobile: true)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(entry: entries[3], isMobile: true)),
              ],
            ),
          ),
        ],
      );
    }

    // 4-column IntrinsicHeight row on tablet/desktop
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < entries.length; i++) ...[
            Expanded(child: _StatCard(entry: entries[i], isMobile: false)),
            if (i < entries.length - 1) const SizedBox(width: 16),
          ],
        ],
      ),
    );
  }
}

/// Animated number with tabular digits inside an intrinsic-height card
class _StatCard extends StatelessWidget {
  final _StatEntry entry;
  final bool isMobile;

  const _StatCard({
    required this.entry,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final target = _parseInt(entry.value);
    final baseSuffix = _suffixOf(entry.value);
    final suffix = entry.forcePlus ? (baseSuffix.contains('+') ? baseSuffix : '$baseSuffix+') : baseSuffix;

    final tt = Theme.of(context).textTheme;
    final valueStyle = (isMobile ? tt.headlineSmall : tt.headlineMedium)?.copyWith(
      fontWeight: FontWeight.w800,
      color: Brand.green,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Container(
      decoration: BoxDecoration(
        color: Brand.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Brand.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x081D6363),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : 20,
        vertical: isMobile ? 16 : 22,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Brand.altBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(entry.icon, color: Brand.green, size: 20),
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: target.toDouble()),
            duration: const Duration(milliseconds: 2400),
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
          const SizedBox(height: 4),
          Text(
            entry.label,
            textAlign: TextAlign.center,
            style: tt.bodyMedium?.copyWith(
              color: Brand.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
