import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../i18n/locale_scope.dart';
import '../theme/brand.dart';
import '../content/site_content.dart';

class ContactSection extends StatelessWidget {
  final AppLocale locale;
  const ContactSection({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final members = ContactContent.boardMembers;
    final isMobile = w < 700;

    // Columns: 1 (mobile), 2 (tablet), 3 (desktop)
    final cols = isMobile ? 1 : (w < 1024 ? 2 : 3);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardAspectRatio = cols == 1 ? 2.8 : 3.0;
        final cardWidth = (constraints.maxWidth - (cols - 1) * 16) / cols;
        final cardHeight = cardWidth / cardAspectRatio;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t(ContactContent.title, locale), style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: isMobile ? 10 : 12),
            SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: _OfficeHoursCard(locale: locale),
            ),
            SizedBox(height: isMobile ? 16 : 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 16,
                mainAxisSpacing: isMobile ? 12 : 16,
                childAspectRatio: cardAspectRatio,
              ),
              itemCount: members.length,
              itemBuilder: (context, i) => _MemberCard(member: members[i], locale: locale),
            ),
            SizedBox(height: isMobile ? 32 : 48),
            _GlobalContactRow(locale: locale),
          ],
        );
      },
    );
  }
}

class _OfficeHoursCard extends StatelessWidget {
  final AppLocale locale;
  const _OfficeHoursCard({required this.locale});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 700;

    final title = t(ContactContent.officeHoursTitle, locale);
    final hours = t(ContactContent.officeHoursValue, locale);

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: isMobile ? 4.0 : 14.0,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Brand.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.access_time_rounded,
                color: Brand.green,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Brand.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hours,
                    style: TextStyle(
                      fontSize: 16,
                      color: Brand.text.withOpacity(0.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final Member member;
  final AppLocale locale;
  const _MemberCard({required this.member, required this.locale});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 700;
    final isNarrow = w < 500; // stack actions on very small phones

    // Check validity before building widgets
    final hasPhone = member.phone != null && member.phone!.trim().isNotEmpty;
    final hasWhatsapp = member.whatsapp != null && member.whatsapp!.trim().isNotEmpty;

    Widget? actionButtons;

    // If neither exists, we render an empty box
    if (!hasPhone && !hasWhatsapp) {
      actionButtons = const SizedBox.shrink();
    } else {
      if (isNarrow) {
        // Mobile (Stacked)
        actionButtons = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasPhone)
              _LaunchIcon(
                tooltip: t(ContactContent.call, locale),
                icon: const Icon(Icons.call),
                url: member.phone,
              ),
            // Only show spacer if BOTH are present
            if (hasPhone && hasWhatsapp) const SizedBox(height: 6),
            if (hasWhatsapp)
              _LaunchIcon(
                tooltip: t(ContactContent.whatsapp, locale),
                icon: const FaIcon(FontAwesomeIcons.whatsapp),
                url: member.whatsapp,
              ),
          ],
        );
      } else {
        // Desktop/Tablet (Row)
        actionButtons = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasPhone)
              _LaunchIcon(
                tooltip: t(ContactContent.call, locale),
                icon: const Icon(Icons.call),
                url: member.phone,
              ),
            if (hasWhatsapp)
              _LaunchIcon(
                tooltip: t(ContactContent.whatsapp, locale),
                icon: const FaIcon(FontAwesomeIcons.whatsapp),
                url: member.whatsapp,
              ),
          ],
        );
      }
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: isMobile ? 4.0 : 14.0,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Brand.bg,
              child: Text(
                _initials(member.nameFor('en')),
                style: const TextStyle(color: Brand.green, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.nameFor(locale), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(member.roleFor(locale), style: TextStyle(color: Colors.black.withOpacity(0.7))),
                ],
              ),
            ),
            const SizedBox(width: 8),
            actionButtons,
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.take(2).toString().toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }
}

class _LaunchIcon extends StatelessWidget {
  final String tooltip;
  final Widget icon;
  final String? url;
  const _LaunchIcon({required this.tooltip, required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    final isEnabled = url != null && url!.trim().isNotEmpty;

    // If no URL, hide the widget entirely
    if (!isEnabled) {
      return const SizedBox.shrink();
    }

    return IconButton(
      tooltip: tooltip,
      onPressed: () => _launchExternal(context, url!),
      icon: icon,
      color: Brand.green,
      // Ensure comfy tap targets
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      splashRadius: 24,
    );
  }
}

/// Bottom global contacts: YouTube, phone, WhatsApp, email
class _GlobalContactRow extends StatelessWidget {
  final AppLocale locale;
  const _GlobalContactRow({required this.locale});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 700;

    final items = [
      _BigIconButton(
        icon: const FaIcon(FontAwesomeIcons.instagram, color: Color(0xFFE1306C)),
        label: t(ContactContent.instagram, locale),
        url: ContentConfig.instagramUrl,
        color: const Color(0xFFE1306C),
        expand: isMobile,
      ),
      _BigIconButton(
        icon: const FaIcon(FontAwesomeIcons.youtube, color: Color(0xFFFF0000)),
        label: t(ContactContent.youtube, locale),
        url: ContentConfig.youtubeUrl,
        color: const Color(0xFFFF0000),
        expand: isMobile,
      ),
      _BigIconButton(
        icon: const Icon(Icons.call, color: Brand.green),
        label: t(ContactContent.phone, locale),
        url: ContentConfig.contactPhone,
        color: Brand.green,
        expand: isMobile,
      ),
      _BigIconButton(
        icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)),
        label: t(ContactContent.whatsapp, locale),
        url: ContentConfig.whatsappLink,
        color: const Color(0xFF25D366),
        expand: isMobile,
      ),
      _BigIconButton(
        icon: const Icon(Icons.email_outlined, color: Brand.green),
        label: t(ContactContent.email, locale),
        url: ContentConfig.contactEmail,
        color: Brand.green,
        expand: isMobile,
      ),
    ].where((b) => b.url.isNotEmpty).toList();

    if (isMobile) {
      // Full-width stacked buttons on mobile (thumb-friendly)
      return Column(
        children: [
          for (final b in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SizedBox(width: double.infinity, child: b),
              ),
            ),
        ],
      );
    }

    // Horizontal row on tablet/desktop
    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: items,
      ),
    );
  }
}

class _BigIconButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final String url;
  final Color color;
  final bool expand; // full-width on mobile when true

  const _BigIconButton({
    required this.icon,
    required this.label,
    required this.url,
    this.color = Brand.green,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _launchExternal(context, url),
      icon: icon,
      label: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: Size(expand ? double.infinity : 0, 48), // bigger tap targets
      ),
    );
  }
}

Future<void> _launchExternal(BuildContext context, String rawUrl) async {
  final trimmed = rawUrl.trim();
  final uri = Uri.tryParse(trimmed);
  bool ok = false;
  if (trimmed.isNotEmpty && uri != null) {
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
  }

  if (!ok && context.mounted) {
    final locale = LocaleScope.of(context).value;
    final errMsg = t({
      'en': 'Could not open the link.',
      'ar': 'تعذّر فتح الرابط.',
      'he': 'לא ניתן לפתוח את הקישור.',
    }, locale);
    final copyLabel = t({
      'en': 'Copy',
      'ar': 'نسخ',
      'he': 'העתק',
    }, locale);

    final copyTarget = trimmed.replaceFirst(RegExp(r'^(tel:|mailto:)'), '');

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(errMsg),
          action: copyTarget.isNotEmpty
              ? SnackBarAction(
                  label: copyLabel,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: copyTarget));
                  },
                )
              : null,
        ),
      );
  }
}
