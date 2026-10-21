import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../content/site_content.dart';
import '../content/site_logo.dart';
import '../i18n/locale_scope.dart';
import '../theme/brand.dart';
import 'site_app_bar.dart';

class SiteFooter extends StatelessWidget {
  final AppLocale locale;
  final SiteNavKeys keys;
  final void Function(GlobalKey key) onNavigate;

  const SiteFooter({
    super.key,
    required this.locale,
    required this.keys,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 750;
    final tt = Theme.of(context).textTheme;

    final brandName = ContentConfig.brandNameLocalized[locale] ?? ContentConfig.brandName;
    final tagline = t(FooterContent.tagline, locale);
    final registration = t(FooterContent.registration, locale);
    final rights = t(FooterContent.rights, locale);
    final donateLabel = HomeContent.donateCta(locale);

    return Container(
      width: double.infinity,
      color: Brand.green,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 36 : 48,
        horizontal: 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top row: Brand identity + Donate CTA
              Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const SiteLogo(size: 40),
                      ),
                      const SizedBox(width: 14),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              brandName,
                              style: tt.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tagline,
                              style: tt.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (isMobile) const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => onNavigate(keys.donate),
                    style: FilledButton.styleFrom(
                      backgroundColor: Brand.yellow,
                      foregroundColor: Brand.green,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.volunteer_activism, size: 18, color: Brand.green),
                    label: Text(
                      donateLabel,
                      style: const TextStyle(
                        color: Brand.green,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),
              Divider(color: Colors.white.withValues(alpha: 0.16), height: 1),
              const SizedBox(height: 24),

              // Middle row: Navigation links + Social icons
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 24,
                runSpacing: 16,
                children: [
                  Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    children: [
                      _FooterNavLink(
                        label: t(NavContent.home, locale),
                        onTap: () => onNavigate(keys.home),
                      ),
                      _FooterNavLink(
                        label: t(NavContent.about, locale),
                        onTap: () => onNavigate(keys.about),
                      ),
                      _FooterNavLink(
                        label: t(NavContent.donate, locale),
                        onTap: () => onNavigate(keys.donate),
                      ),
                      _FooterNavLink(
                        label: t(NavContent.photos, locale),
                        onTap: () => onNavigate(keys.photos),
                      ),
                      _FooterNavLink(
                        label: t(NavContent.contact, locale),
                        onTap: () => onNavigate(keys.contact),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _FooterSocialButton(
                        tooltip: t(ContactContent.whatsapp, locale),
                        icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18, color: Colors.white),
                        url: ContentConfig.whatsappLink,
                      ),
                      _FooterSocialButton(
                        tooltip: t(ContactContent.instagram, locale),
                        icon: const FaIcon(FontAwesomeIcons.instagram, size: 18, color: Colors.white),
                        url: ContentConfig.instagramUrl,
                      ),
                      _FooterSocialButton(
                        tooltip: t(ContactContent.youtube, locale),
                        icon: const FaIcon(FontAwesomeIcons.youtube, size: 18, color: Colors.white),
                        url: ContentConfig.youtubeUrl,
                      ),
                      _FooterSocialButton(
                        tooltip: t(ContactContent.phone, locale),
                        icon: const Icon(Icons.call_rounded, size: 18, color: Colors.white),
                        url: ContentConfig.contactPhone,
                      ),
                      _FooterSocialButton(
                        tooltip: t(ContactContent.email, locale),
                        icon: const Icon(Icons.email_outlined, size: 18, color: Colors.white),
                        url: ContentConfig.contactEmail,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Divider(color: Colors.white.withValues(alpha: 0.16), height: 1),
              const SizedBox(height: 20),

              // Bottom row: Amuta registration badge & copyright
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_outlined, size: 16, color: Brand.yellow),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          registration,
                          style: tt.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    rights,
                    style: tt.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterNavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterNavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class _FooterSocialButton extends StatelessWidget {
  final String tooltip;
  final Widget icon;
  final String url;

  const _FooterSocialButton({
    required this.tooltip,
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) return const SizedBox.shrink();

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _launchFooterUrl(context, url),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }

  Future<void> _launchFooterUrl(BuildContext context, String rawUrl) async {
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
}
