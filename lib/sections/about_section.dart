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
    const imagePath = 'assets/images/image-00.jpg';

    final photoThumb = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        semanticLabel: 'Dar al-Fajr photo',
      ),
    );

// Use ZoomableTap with a single image provider
    final photoZoomable = ZoomableTap(
      heroTagBase: 'about-photo', // optional hero
      initialIndex: 0,
      providers: [AssetImage(imagePath)],
      child: photoThumb,
    );

    // Desktop/tablet: add a soft shadow; Mobile: keep it flat (faster, lighter)
    final photo = AspectRatio(
      aspectRatio: 16 / 9,
      child: isMobile
          ? photoZoomable
          : DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: photoZoomable,
            ),
    );
    final textBlock = _AboutTextBlock(
      title: title,
      body: body,
      chips: [
        _Pill(icon: Icons.menu_book, text: pillars[0]), // Education
        _Pill(icon: Icons.groups, text: pillars[1]), // Community
        _Pill(icon: Icons.volunteer_activism, text: pillars[2]) // Service
      ],
    );

    // Mobile: photo first (visual hook), then text
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          photo,
          const SizedBox(height: 24),
          textBlock,
        ],
      );
    }

    // Desktop: text left, photo right — force LTR so RTL locales don’t flip order
    return Row(
      textDirection: TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: textBlock),
        const SizedBox(width: 24),
        Expanded(child: photo),
      ],
    );
  }
}

class _AboutTextBlock extends StatelessWidget {
  final String title;
  final String body;
  final List<Widget> chips;
  const _AboutTextBlock({required this.title, required this.body, required this.chips});

  @override
  Widget build(BuildContext context) {
    final l = LocaleScope.of(context).value; // 'en' | 'ar' | 'he'
    final isArabic = l == 'ar';

    final tt = Theme.of(context).textTheme;

// sensible fallbacks if any is null
    final titleBase = tt.headlineMedium ?? tt.titleLarge ?? const TextStyle();
    final bodyBase = tt.bodyLarge ?? tt.bodyMedium ?? const TextStyle();

// For Arabic we usually avoid extra letterSpacing and use a bit more line-height
    final titleStyle = isArabic
        ? titleBase.copyWith(letterSpacing: 0) // family already = Cairo via Theme
        : titleBase;

    final bodyStyle = isArabic ? bodyBase.copyWith(letterSpacing: 0, height: 1.6) : bodyBase;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SelectableText(body, style: bodyStyle),
        ),
        // const SizedBox(height: 16),
        // Wrap(spacing: 12, runSpacing: 12, children: chips),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: Brand.green, size: 18),
      label: Text(text),
      side: const BorderSide(color: Brand.green),
      backgroundColor: Brand.bg,
      labelStyle: const TextStyle(color: Brand.green),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
