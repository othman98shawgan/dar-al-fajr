import 'package:flutter/material.dart';

import '../i18n/locale_scope.dart';
import '../theme/brand.dart';
import '../content/site_content.dart';
import '../widgets/zoom_gallery.dart';

class AboutSection extends StatelessWidget {
  final AppLocale locale;
  const AboutSection({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 900;

    final title = t(AboutContent.title, locale);
    final body = t(AboutContent.description, locale);
    final pillars = AboutContent.pillars(locale);
    final pillarDescs = AboutContent.pillarDescriptions(locale);
    const imagePath = 'assets/images/image-00.jpg';

    final photoThumb = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        semanticLabel: 'Dar al-Fajr campus photo',
      ),
    );

    final photoZoomable = ZoomableTap(
      heroTagBase: 'about-photo',
      initialIndex: 0,
      providers: const [AssetImage(imagePath)],
      child: photoThumb,
    );

    final photoCard = Container(
      decoration: BoxDecoration(
        color: Brand.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Brand.outline, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x141D6363),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: photoZoomable,
      ),
    );

    final textBlock = _AboutTextBlock(
      title: title,
      body: body,
      locale: locale,
    );

    final pillarCardsData = [
      (Icons.menu_book_rounded, pillars[0], pillarDescs[0]),
      (Icons.groups_rounded, pillars[1], pillarDescs[1]),
      (Icons.volunteer_activism_rounded, pillars[2], pillarDescs[2]),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // RTL-aware split layout:
        // No forced TextDirection.ltr — Row naturally places text on the right in RTL (Hebrew/Arabic)
        // and on the left in LTR (English).
        if (isMobile) ...[
          textBlock,
          const SizedBox(height: 24),
          photoCard,
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 6, child: textBlock),
              const SizedBox(width: 36),
              Expanded(flex: 5, child: photoCard),
            ],
          ),

        if (!isMobile) ...[
          const SizedBox(height: 48),

          // 3 Value Pillar Cards (Education, Community, Service)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < pillarCardsData.length; i++) ...[
                  Expanded(
                    child: _PillarCard(
                      icon: pillarCardsData[i].$1,
                      title: pillarCardsData[i].$2,
                      description: pillarCardsData[i].$3,
                    ),
                  ),
                  if (i < pillarCardsData.length - 1) const SizedBox(width: 20),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _AboutTextBlock extends StatelessWidget {
  final String title;
  final String body;
  final AppLocale locale;

  const _AboutTextBlock({
    required this.title,
    required this.body,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = locale == 'ar';
    final tt = Theme.of(context).textTheme;

    final titleBase = tt.headlineMedium ?? tt.titleLarge ?? const TextStyle();
    final bodyBase = tt.bodyLarge ?? tt.bodyMedium ?? const TextStyle();

    final titleStyle = titleBase.copyWith(
      color: Brand.green,
      fontWeight: FontWeight.w800,
      letterSpacing: isArabic ? 0 : null,
    );

    final bodyStyle = bodyBase.copyWith(
      color: Brand.text,
      letterSpacing: isArabic ? 0 : null,
      height: isArabic ? 1.7 : 1.65,
      fontSize: 16.5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subtle accent bar + section title
        Container(
          width: 44,
          height: 4,
          decoration: BoxDecoration(
            color: Brand.yellow,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: 12),
        Text(title, style: titleStyle),
        const SizedBox(height: 16),
        SelectableText(body, style: bodyStyle),
      ],
    );
  }
}

class _PillarCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PillarCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_PillarCard> createState() => _PillarCardState();
}

class _PillarCardState extends State<_PillarCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Brand.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? Brand.green.withValues(alpha: 0.45) : Brand.outline,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered ? const Color(0x161D6363) : const Color(0x081D6363),
              blurRadius: _hovered ? 20 : 10,
              offset: Offset(0, _hovered ? 8 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _hovered ? Brand.green : Brand.altBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _hovered ? Brand.green : Brand.outline,
                ),
              ),
              child: Icon(
                widget.icon,
                color: _hovered ? Colors.white : Brand.green,
                size: 26,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              widget.title,
              style: tt.titleLarge?.copyWith(
                color: Brand.green,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: tt.bodyMedium?.copyWith(
                color: Brand.text,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
