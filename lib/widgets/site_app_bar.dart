import 'package:dar_al_fajr/i18n/locale_scope.dart';
import 'package:flutter/material.dart';
import '../content/site_logo.dart';
import '../theme/brand.dart';
import '../content/site_content.dart';

enum SiteSectionId { home, about, donate, photos, contact }

class SiteNavKeys {
  final GlobalKey home, about, donate, photos, contact;
  const SiteNavKeys({
    required this.home,
    required this.about,
    required this.donate,
    required this.photos,
    required this.contact,
  });

  GlobalKey keyFor(SiteSectionId id) => switch (id) {
        SiteSectionId.home => home,
        SiteSectionId.about => about,
        SiteSectionId.donate => donate,
        SiteSectionId.photos => photos,
        SiteSectionId.contact => contact,
      };
}

class SiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppLocale locale;
  final SiteNavKeys keys;
  final SiteSectionId activeSection;
  final void Function(GlobalKey key) onNavigate;
  final void Function(AppLocale locale) onLocaleChanged;

  const SiteAppBar({
    super.key,
    required this.locale,
    required this.keys,
    this.activeSection = SiteSectionId.home,
    required this.onNavigate,
    required this.onLocaleChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 900;

    final tt = Theme.of(context).textTheme;

    final brandTitleStyle = (isMobile ? tt.titleLarge : tt.headlineSmall)?.copyWith(
      fontWeight: FontWeight.w800,
      color: Brand.green,
    );

    final donateTextStyle = (tt.labelLarge ?? tt.titleSmall ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w800,
      color: Brand.green,
    );

    final home = t(NavContent.home, locale);
    final about = t(NavContent.about, locale);
    final donate = t(NavContent.donate, locale);
    final photos = t(NavContent.photos, locale);
    final contact = t(NavContent.contact, locale);

    return AppBar(
      elevation: 0,
      toolbarHeight: isMobile ? 64 : 76,
      backgroundColor: Brand.nav,
      surfaceTintColor: Colors.transparent,
      titleSpacing: isMobile ? 12 : 24,
      title: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onNavigate(keys.home),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SiteLogo(size: isMobile ? 36 : 44),
              if (!isMobile) ...[
                const SizedBox(width: 10),
                Text(
                  ContentConfig.brandNameLocalized[locale] ?? ContentConfig.brandName,
                  style: brandTitleStyle,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: isMobile
          ? [
              _LocaleButton(
                current: locale,
                onChanged: onLocaleChanged,
                isMobile: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: FilledButton.icon(
                  onPressed: () => onNavigate(keys.donate),
                  icon: const Icon(Icons.volunteer_activism, size: 16, color: Brand.green),
                  label: Text(donate, style: donateTextStyle),
                ),
              ),
              IconButton(
                tooltip: 'Menu',
                icon: const Icon(Icons.menu, color: Brand.green),
                onPressed: () => _openMenu(context, [
                  _NavItem(
                    id: SiteSectionId.home,
                    icon: Icons.home_outlined,
                    label: home,
                    key: keys.home,
                  ),
                  _NavItem(
                    id: SiteSectionId.about,
                    icon: Icons.info_outline,
                    label: about,
                    key: keys.about,
                  ),
                  _NavItem(
                    id: SiteSectionId.donate,
                    icon: Icons.volunteer_activism_outlined,
                    label: donate,
                    key: keys.donate,
                  ),
                  _NavItem(
                    id: SiteSectionId.photos,
                    icon: Icons.photo_library_outlined,
                    label: photos,
                    key: keys.photos,
                  ),
                  _NavItem(
                    id: SiteSectionId.contact,
                    icon: Icons.contact_mail_outlined,
                    label: contact,
                    key: keys.contact,
                  ),
                ]),
              ),
              const SizedBox(width: 4),
            ]
          : [
              _DesktopNavLink(
                label: home,
                isActive: activeSection == SiteSectionId.home,
                onTap: () => onNavigate(keys.home),
              ),
              _DesktopNavLink(
                label: about,
                isActive: activeSection == SiteSectionId.about,
                onTap: () => onNavigate(keys.about),
              ),
              _DesktopNavLink(
                label: donate,
                isActive: activeSection == SiteSectionId.donate,
                onTap: () => onNavigate(keys.donate),
              ),
              _DesktopNavLink(
                label: photos,
                isActive: activeSection == SiteSectionId.photos,
                onTap: () => onNavigate(keys.photos),
              ),
              _DesktopNavLink(
                label: contact,
                isActive: activeSection == SiteSectionId.contact,
                onTap: () => onNavigate(keys.contact),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () => onNavigate(keys.donate),
                icon: const Icon(Icons.favorite_rounded, size: 18, color: Brand.green),
                label: Text(donate, style: donateTextStyle),
              ),
              const SizedBox(width: 8),
              _LocaleButton(
                current: locale,
                onChanged: onLocaleChanged,
                isMobile: false,
              ),
              const SizedBox(width: 20),
            ],
    );
  }

  void _openMenu(BuildContext context, List<_NavItem> items) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Brand.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final it = items[i];
            final isActive = it.id == activeSection;
            return ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: isActive ? Brand.altBg : null,
              leading: Icon(it.icon, color: Brand.green),
              title: Text(
                it.label,
                style: TextStyle(
                  color: Brand.green,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
              trailing: isActive
                  ? Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Brand.yellow,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
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

class _DesktopNavLink extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DesktopNavLink({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final style = (tt.labelLarge ?? tt.titleSmall ?? const TextStyle()).copyWith(
      color: Brand.green,
      fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: style),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: isActive ? 24 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: isActive ? Brand.yellow : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final SiteSectionId id;
  final IconData icon;
  final String label;
  final GlobalKey key;
  _NavItem({
    required this.id,
    required this.icon,
    required this.label,
    required this.key,
  });
}

// === Locale picker button ===
class _LocaleButton extends StatelessWidget {
  final AppLocale current;
  final void Function(AppLocale) onChanged;
  final bool isMobile;
  const _LocaleButton({
    required this.current,
    required this.onChanged,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    const langs = [
      ('he', 'HE', 'עברית'),
      ('ar', 'AR', 'العربية'),
      ('en', 'EN', 'English'),
    ];

    final currentShort = langs.firstWhere((l) => l.$1 == current, orElse: () => langs.first).$2;

    return PopupMenuButton<String>(
      tooltip: 'Language',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Brand.altBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Brand.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, color: Brand.green, size: 18),
            const SizedBox(width: 6),
            Text(
              currentShort,
              style: (Theme.of(context).textTheme.labelLarge ?? const TextStyle()).copyWith(
                color: Brand.green,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      onSelected: (code) => onChanged(code),
      itemBuilder: (ctx) => [
        for (final l in langs)
          PopupMenuItem(
            value: l.$1,
            child: Row(
              children: [
                if (l.$1 == current)
                  const Icon(Icons.check_rounded, size: 18, color: Brand.green)
                else
                  const SizedBox(width: 18),
                const SizedBox(width: 8),
                Text(
                  l.$3,
                  style: TextStyle(
                    fontWeight: l.$1 == current ? FontWeight.w700 : FontWeight.w500,
                    color: l.$1 == current ? Brand.green : Brand.text,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
