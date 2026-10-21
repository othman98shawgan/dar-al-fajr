import 'package:flutter/material.dart';

import '../sections/home_section.dart';
import '../sections/about_section.dart';
import '../sections/donation_section.dart';
import '../sections/photos_section.dart';
import '../sections/contact_section.dart';
import '../i18n/locale_scope.dart';
import '../theme/brand.dart';
import '../widgets/site_app_bar.dart';
import '../widgets/site_footer.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final donateKey = GlobalKey();
  final photosKey = GlobalKey();
  final contactKey = GlobalKey();
  final scrollCtrl = ScrollController();

  SiteSectionId _activeSection = SiteSectionId.home;

  SiteNavKeys get _navKeys => SiteNavKeys(
        home: homeKey,
        about: aboutKey,
        donate: donateKey,
        photos: photosKey,
        contact: contactKey,
      );

  @override
  void initState() {
    super.initState();
    scrollCtrl.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/images/logo.png'), context);
      precacheImage(const AssetImage('assets/images/image-00.jpg'), context);
    });
  }

  @override
  void dispose() {
    scrollCtrl.removeListener(_onScroll);
    scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    final entries = <(SiteSectionId, GlobalKey)>[
      (SiteSectionId.home, homeKey),
      (SiteSectionId.about, aboutKey),
      (SiteSectionId.donate, donateKey),
      (SiteSectionId.photos, photosKey),
      (SiteSectionId.contact, contactKey),
    ];

    // Pick the last section whose top has crossed near the top viewport threshold
    const threshold = 220.0;
    SiteSectionId current = SiteSectionId.home;

    for (final (id, key) in entries) {
      final ctx = key.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy <= threshold) {
        current = id;
      }
    }

    // If scrolled nearly to the very bottom, highlight Contact
    if (scrollCtrl.hasClients &&
        scrollCtrl.position.maxScrollExtent > 0 &&
        scrollCtrl.offset >= scrollCtrl.position.maxScrollExtent - 60) {
      current = SiteSectionId.contact;
    }

    if (current != _activeSection) {
      setState(() {
        _activeSection = current;
      });
    }
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.02,
      );
    }
  }

  void _setLocale(AppLocale l) => LocaleScope.of(context).value = l;

  bool _isRtl(AppLocale l) => l == 'ar' || l == 'he';

  @override
  Widget build(BuildContext context) {
    final l = LocaleScope.of(context).value;
    final keys = _navKeys;

    return Directionality(
      textDirection: _isRtl(l) ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Brand.bg,
        appBar: SiteAppBar(
          locale: l,
          keys: keys,
          activeSection: _activeSection,
          onNavigate: _scrollTo,
          onLocaleChanged: _setLocale,
        ),
        body: SingleChildScrollView(
          controller: scrollCtrl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Hero & Impact Section (White #FFFFFF)
              Section(
                key: homeKey,
                backgroundColor: Brand.bg,
                child: HomeSection(
                  locale: l,
                  onDonateTap: () => _scrollTo(donateKey),
                  onAboutTap: () => _scrollTo(aboutKey),
                ),
              ),

              // 2. About & Pillars Section (Pale Teal #F4F9F9)
              Section(
                key: aboutKey,
                backgroundColor: Brand.altBg,
                showBorders: true,
                child: AboutSection(locale: l),
              ),

              // 3. Donate & Support Section (White #FFFFFF)
              Section(
                key: donateKey,
                backgroundColor: Brand.bg,
                child: DonationSection(locale: l),
              ),

              // 4. Campus Gallery Section (Pale Teal #F4F9F9)
              Section(
                key: photosKey,
                backgroundColor: Brand.altBg,
                showBorders: true,
                child: PhotosSection(locale: l),
              ),

              // 5. Contact & Secretariat Section (White #FFFFFF)
              Section(
                key: contactKey,
                backgroundColor: Brand.bg,
                child: ContactSection(locale: l),
              ),

              // 6. Global Professional Footer (Deep Teal #1D6363)
              SiteFooter(
                locale: l,
                keys: keys,
                onNavigate: _scrollTo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final bool showBorders;

  const Section({
    super.key,
    required this.child,
    this.backgroundColor = Brand.bg,
    this.showBorders = false,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 900;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: showBorders
            ? const Border.symmetric(
                horizontal: BorderSide(color: Brand.outline, width: 1),
              )
            : null,
      ),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40.0 : 64.0,
        horizontal: isMobile ? 16.0 : 24.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: child,
        ),
      ),
    );
  }
}
