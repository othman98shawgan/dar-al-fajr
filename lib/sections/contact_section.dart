import 'package:flutter/material.dart';
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

    // Columns: 1 (mobile), 2 (tablet), 3 (desktop)
    final cols = w < 700 ? 1 : (w < 1024 ? 2 : 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t(ContactContent.title, locale), style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            // Taller cards on mobile for breathing room
            childAspectRatio: cols == 1 ? 1.6 : 3.0,
          ),
          itemCount: members.length,
          itemBuilder: (context, i) => _MemberCard(member: members[i], locale: locale),
        ),
        const SizedBox(height: 48),
        _GlobalContactRow(locale: locale),
      ],
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
    final isNarrow = w < 500; // stack actions on very small phones

    final actionButtons = isNarrow
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LaunchIcon(
                tooltip: t(ContactContent.call, locale),
                icon: Icons.call,
                url: member.phone,
              ),
              const SizedBox(height: 6),
              _LaunchIcon(
                tooltip: t(ContactContent.whatsapp, locale),
                icon: FontAwesomeIcons.whatsapp,
                url: member.whatsapp,
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LaunchIcon(
                tooltip: t(ContactContent.call, locale),
                icon: Icons.call,
                url: member.phone,
              ),
              _LaunchIcon(
                tooltip: t(ContactContent.whatsapp, locale),
                icon: FontAwesomeIcons.whatsapp,
                url: member.whatsapp,
              ),
            ],
          );

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Brand.bg,
              child: Text(
                _initials(member.name),
                style: const TextStyle(color: Brand.green, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
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
  final IconData icon;
  final String? url;
  const _LaunchIcon({required this.tooltip, required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    final isEnabled = url != null && url!.trim().isNotEmpty;
    return IconButton(
      tooltip: tooltip,
      onPressed: !isEnabled ? null : () => launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication),
      icon: Icon(icon),
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
        icon: FontAwesomeIcons.youtube,
        label: t(ContactContent.youtube, locale),
        url: ContentConfig.youtubeUrl,
        color: const Color(0xFFFF0000),
        expand: isMobile,
      ),
      _BigIconButton(
        icon: Icons.call,
        label: t(ContactContent.phone, locale),
        url: ContentConfig.contactPhone,
        color: Brand.green,
        expand: isMobile,
      ),
      _BigIconButton(
        icon: FontAwesomeIcons.whatsapp,
        label: t(ContactContent.whatsapp, locale), // or keep 'WhatsApp' literal if you prefer
        url: ContentConfig.whatsappLink,
        color: const Color(0xFF25D366),
        expand: isMobile,
      ),
      _BigIconButton(
        icon: Icons.email_outlined,
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
  final IconData icon;
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
      onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      icon: Icon(icon, color: color),
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
