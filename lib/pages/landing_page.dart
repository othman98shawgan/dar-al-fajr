import 'package:flutter/material.dart';

import '../sections/home_section.dart';
import '../sections/about_section.dart';
import '../sections/donation_section.dart';
import '../sections/photos_section.dart';
import '../sections/contact_section.dart';
import '../i18n/locale_scope.dart';
import '../widgets/site_app_bar.dart';

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

  Future<void> _scrollTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.05,
      );
    }
  }

  void _setLocale(AppLocale l) => LocaleScope.of(context).value = l;

  bool _isRtl(AppLocale l) => l == 'ar' || l == 'he';

  @override
  void initState() {
    super.initState();
    // Precaches during the first microtask/frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/images/logo.png'), context);
      precacheImage(const AssetImage('assets/images/image-00.jpg'), context); // <- change to your real file
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = LocaleScope.of(context).value;

    return Directionality(
      textDirection: _isRtl(l) ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: SiteAppBar(
          locale: l,
          keys: SiteNavKeys(
            home: homeKey,
            about: aboutKey,
            donate: donateKey,
            photos: photosKey,
            contact: contactKey,
          ),
          onNavigate: _scrollTo,
          onLocaleChanged: _setLocale,
        ),
        body: SingleChildScrollView(
          controller: scrollCtrl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Section(key: homeKey, child: HomeSection(locale: l)),
              Section(key: aboutKey, child: AboutSection(locale: l)),
              Section(key: donateKey, child: DonationSection(locale: l)),
              Section(key: photosKey, child: const PhotosSection()),
              Section(key: contactKey, child: ContactSection(locale: l)),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final Widget child;
  const Section({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 900;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 24.0 : 36.0, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: child,
        ),
      ),
    );
  }
}
