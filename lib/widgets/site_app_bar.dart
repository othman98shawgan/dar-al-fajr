import 'package:dar_al_fajr/i18n/locale_scope.dart';
import 'package:flutter/material.dart';
import '../content/site_logo.dart';
import '../theme/brand.dart';
import '../content/site_content.dart';

class SiteNavKeys {
  final GlobalKey home, about, donate, photos, contact;
  const SiteNavKeys({
    required this.home,
    required this.about,
    required this.donate,
    required this.photos,
    required this.contact,
  });
}

class SiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppLocale locale; // current locale (e.g., 'en' | 'ar' | 'he')
  final SiteNavKeys keys;
  final void Function(GlobalKey key) onNavigate;
  final void Function(AppLocale locale) onLocaleChanged;
  const SiteAppBar({
    super.key,
    required this.locale,
    required this.keys,
    required this.onNavigate,
    required this.onLocaleChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 900;

    final home = t(NavContent.home, locale);
    final about = t(NavContent.about, locale);
    final donate = t(NavContent.donate, locale);
    final photos = t(NavContent.photos, locale);
    final contact = t(NavContent.contact, locale);

    return AppBar(
      elevation: 0,
      toolbarHeight: isMobile ? 64 : 72,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Brand.nav,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 12,
      title: Row(children: [
        SiteLogo(size: isMobile ? 36 : 48),
        const SizedBox(width: 10),
        if (w >= 380) const Text('Dar al-Fajr', style: TextStyle(fontWeight: FontWeight.w700, color: Brand.green)),
      ]),
      actions: isMobile
          ? [
              // Locale picker (mobile: popup)
              _LocaleButton(
                current: locale,
                onChanged: onLocaleChanged,
                isMobile: true,
              ),
              // Donate always visible
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: FilledButton(
                  onPressed: () => onNavigate(keys.donate),
                  child: Text(donate),
                ),
              ),
              IconButton(
                tooltip: 'Menu',
                icon: const Icon(Icons.menu, color: Brand.green),
                onPressed: () => _openMenu(context, [
                  _NavItem(icon: Icons.home_outlined, label: home, key: keys.home),
                  _NavItem(icon: Icons.info_outline, label: about, key: keys.about),
                  _NavItem(icon: Icons.photo_library, label: photos, key: keys.photos),
                  _NavItem(icon: Icons.contact_mail, label: contact, key: keys.contact),
                ]),
              ),
            ]
          : [
              TextButton(
                  onPressed: () => onNavigate(keys.home),
                  child: Text(home, style: const TextStyle(color: Brand.green))),
              TextButton(
                  onPressed: () => onNavigate(keys.about),
                  child: Text(about, style: const TextStyle(color: Brand.green))),
              TextButton(
                  onPressed: () => onNavigate(keys.photos),
                  child: Text(photos, style: const TextStyle(color: Brand.green))),
              TextButton(
                  onPressed: () => onNavigate(keys.contact),
                  child: Text(contact, style: const TextStyle(color: Brand.green))),
              const SizedBox(width: 8),
              FilledButton(onPressed: () => onNavigate(keys.donate), child: Text(donate)),
              const SizedBox(width: 8),
              // Locale picker (desktop: compact popup)
              _LocaleButton(
                current: locale,
                onChanged: onLocaleChanged,
                isMobile: false,
              ),
              const SizedBox(width: 12),
            ],
    );
  }

  void _openMenu(BuildContext context, List<_NavItem> items) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8),
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final it = items[i];
            return ListTile(
              leading: Icon(it.icon, color: Brand.green),
              title: Text(it.label),
              onTap: () {
                Navigator.pop(ctx);
                onNavigate(it.key);
              },
            );
          },
        );
      },
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final GlobalKey key;
  _NavItem({required this.icon, required this.label, required this.key});
}

// === Locale picker button ===
class _LocaleButton extends StatelessWidget {
  final AppLocale current;
  final void Function(AppLocale) onChanged;
  final bool isMobile;
  const _LocaleButton({required this.current, required this.onChanged, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    // Simple 3-option language menu
    const langs = [
      ('en', 'EN', 'English'),
      ('ar', 'AR', 'العربية'),
      ('he', 'HE', 'עברית'),
    ];

    final currentShort = langs.firstWhere((l) => l.$1 == current, orElse: () => langs.first).$2;

    return PopupMenuButton<String>(
      tooltip: 'Language',
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language, color: Brand.green),
          if (!isMobile) ...[
            const SizedBox(width: 6),
            Text(currentShort, style: const TextStyle(color: Brand.green, fontWeight: FontWeight.w700)),
          ],
        ],
      ),
      onSelected: (code) => onChanged(code),
      itemBuilder: (ctx) => [
        for (final l in langs)
          PopupMenuItem(
            value: l.$1,
            child: Row(
              children: [
                if (l.$1 == current) const Icon(Icons.check, size: 18),
                if (l.$1 == current) const SizedBox(width: 6),
                Text(l.$3),
              ],
            ),
          ),
      ],
    );
  }
}
