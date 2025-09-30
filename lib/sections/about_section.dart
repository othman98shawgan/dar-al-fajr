import 'package:flutter/material.dart';
import '../i18n/locale_scope.dart';
import '../theme/brand.dart';
import '../content/site_content.dart';

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

    final photoCore = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/images/image-10.jpg',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        semanticLabel: 'Dar al-Fajr photo',
      ),
    );

    // Desktop/tablet: add a soft shadow; Mobile: keep it flat (faster, lighter)
    final photo = AspectRatio(
      aspectRatio: 16 / 9,
      child: isMobile
          ? photoCore
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
              child: photoCore,
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
    // Clamp paragraph width for readability on big screens
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SelectableText(body, style: Theme.of(context).textTheme.bodyLarge),
        ),
        const SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: chips),
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
