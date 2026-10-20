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
    final tt = Theme.of(context).textTheme;

    // Columns: 1 (mobile), 2 (tablet), 3 (desktop)
    final cols = isMobile ? 1 : (w < 1024 ? 2 : 3);

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 16.0;
        final cardWidth = cols == 1 ? constraints.maxWidth : (constraints.maxWidth - (cols - 1) * spacing) / cols;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Header in Deep Teal (#1D6363)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Brand.yellow,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  t(ContactContent.title, locale),
                  textAlign: TextAlign.center,
                  style: tt.headlineMedium?.copyWith(
                    color: Brand.green,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    t(ContactContent.subtitle, locale),
                    textAlign: TextAlign.center,
                    style: tt.bodyLarge?.copyWith(color: Brand.text),
                  ),
                ),
              ],
            ),

            SizedBox(height: isMobile ? 24 : 32),

            // Prominent Secretariat Hours & Direct Contact Banner
            _SecretariatBanner(locale: locale, isMobile: isMobile),

            SizedBox(height: isMobile ? 24 : 32),

            // Responsive Wrap layout for Team/Member Cards (sizes naturally to content — no fixed aspect ratio GridView)
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final member in members)
                  SizedBox(
                    width: cardWidth,
                    child: _MemberCard(member: member, locale: locale),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SecretariatBanner extends StatelessWidget {
  final AppLocale locale;
  final bool isMobile;

  const _SecretariatBanner({
    required this.locale,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final title = t(ContactContent.officeHoursTitle, locale);
    final hours = t(ContactContent.officeHoursValue, locale);
    final tt = Theme.of(context).textTheme;

    final contactButtons = [
      _DirectContactButton(
        icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18, color: Color(0xFF25D366)),
        label: t(ContactContent.whatsapp, locale),
        url: ContentConfig.whatsappLink,
        iconColor: const Color(0xFF25D366),
        expand: isMobile,
      ),
      _DirectContactButton(
        icon: const Icon(Icons.call_rounded, size: 18, color: Color(0xFF1D6363)),
        label: t(ContactContent.phone, locale),
        url: ContentConfig.contactPhone,
        iconColor: const Color(0xFF1D6363),
        expand: isMobile,
      ),
      _DirectContactButton(
        icon: const Icon(Icons.email_outlined, size: 18, color: Color(0xFFEA4335)),
        label: t(ContactContent.email, locale),
        url: ContentConfig.contactEmail,
        iconColor: const Color(0xFFEA4335),
        expand: isMobile,
      ),
      _DirectContactButton(
        icon: const FaIcon(FontAwesomeIcons.instagram, size: 18, color: Color(0xFFE1306C)),
        label: t(ContactContent.instagram, locale),
        url: ContentConfig.instagramUrl,
        iconColor: const Color(0xFFE1306C),
        expand: isMobile,
      ),
      _DirectContactButton(
        icon: const FaIcon(FontAwesomeIcons.youtube, size: 18, color: Color(0xFFFF0000)),
        label: t(ContactContent.youtube, locale),
        url: ContentConfig.youtubeUrl,
        iconColor: const Color(0xFFFF0000),
        expand: isMobile,
      ),
    ].where((b) => b.url.isNotEmpty).toList();

    return Container(
      decoration: BoxDecoration(
        color: Brand.altBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Brand.green.withValues(alpha: 0.25), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1D6363),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Brand.green,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.access_time_filled_rounded,
                  color: Brand.yellow,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Brand.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hours,
                      style: tt.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Brand.text,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Brand.outline),
          const SizedBox(height: 20),
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < contactButtons.length; i++) ...[
                  contactButtons[i],
                  if (i < contactButtons.length - 1) const SizedBox(height: 10),
                ],
              ],
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.start,
              children: contactButtons,
            ),
        ],
      ),
    );
  }
}

class _DirectContactButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final String url;
  final Color? iconColor;
  final bool expand;

  const _DirectContactButton({
    required this.icon,
    required this.label,
    required this.url,
    this.iconColor,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = iconColor != null ? iconColor!.withValues(alpha: 0.35) : Brand.outline;

    final child = OutlinedButton.icon(
      onPressed: () => _launchExternal(context, url),
      style: OutlinedButton.styleFrom(
        backgroundColor: Brand.card,
        foregroundColor: Brand.green,
        side: BorderSide(color: borderColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: Size(expand ? double.infinity : 0, 48),
      ),
      icon: icon,
      label: Text(
        label,
        style: const TextStyle(color: Brand.green, fontWeight: FontWeight.w700),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}

class _MemberCard extends StatelessWidget {
  final Member member;
  final AppLocale locale;
  const _MemberCard({required this.member, required this.locale});

  @override
  Widget build(BuildContext context) {
    final hasPhone = member.phone != null && member.phone!.trim().isNotEmpty;
    final hasWhatsapp = member.whatsapp != null && member.whatsapp!.trim().isNotEmpty;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Brand.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Brand.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x061D6363),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Brand.altBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Brand.outline),
            ),
            alignment: Alignment.center,
            child: Text(
              _initials(member.nameFor('en')),
              style: const TextStyle(
                color: Brand.green,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.nameFor(locale),
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Brand.green,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Brand.altBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    member.roleFor(locale),
                    style: tt.labelMedium?.copyWith(
                      color: Brand.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (hasPhone || hasWhatsapp) ...[
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasPhone)
                  _LaunchIcon(
                    tooltip: t(ContactContent.call, locale),
                    icon: const Icon(Icons.call_rounded, size: 20),
                    url: member.phone,
                  ),
                if (hasPhone && hasWhatsapp) const SizedBox(width: 6),
                if (hasWhatsapp)
                  _LaunchIcon(
                    tooltip: t(ContactContent.whatsapp, locale),
                    icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20, color: Color(0xFF25D366)),
                    url: member.whatsapp,
                  ),
              ],
            ),
          ],
        ],
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
    if (!isEnabled) {
      return const SizedBox.shrink();
    }

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Brand.altBg,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _launchExternal(context, url!),
          child: SizedBox(
            width: 42,
            height: 42,
            child: Center(
              child: IconTheme(
                data: const IconThemeData(color: Brand.green, size: 20),
                child: icon,
              ),
            ),
          ),
        ),
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
