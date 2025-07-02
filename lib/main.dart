import 'package:flutter/material.dart';
import 'ui/sections/home_section.dart';
import 'ui/sections/about_section.dart';
import 'ui/sections/donate_section.dart';
import 'ui/sections/gallery_section.dart';
import 'ui/sections/team_section.dart';

void main() => runApp(const QuranCenterApp());

class QuranCenterApp extends StatelessWidget {
  const QuranCenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dar al-Fajr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Segoe UI',
        primaryColor: const Color(0xFF1A6560),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFF1D31D),
        ),
      ),
      home: const QuranCenterHomePage(),
    );
  }
}

class QuranCenterHomePage extends StatefulWidget {
  const QuranCenterHomePage({super.key});

  @override
  State<QuranCenterHomePage> createState() => _QuranCenterHomePageState();
}

class _QuranCenterHomePageState extends State<QuranCenterHomePage> {
  final ScrollController _scrollController = ScrollController();

  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final donateKey = GlobalKey();
  final galleryKey = GlobalKey();
  final teamKey = GlobalKey();

  void scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A6560),
        centerTitle: true,
        title: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _navButton("Home", () => scrollTo(homeKey), isMobile),
                _navButton("About", () => scrollTo(aboutKey), isMobile),
                _navButton("Donate", () => scrollTo(donateKey), isMobile),
                _navButton("Gallery", () => scrollTo(galleryKey), isMobile),
                _navButton("Team", () => scrollTo(teamKey), isMobile),
              ],
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KeyedSubtree(key: homeKey, child: HomeSection(donateKey: donateKey)),
            KeyedSubtree(key: aboutKey, child: const AboutSection()),
            KeyedSubtree(key: donateKey, child: const DonateSection()),
            KeyedSubtree(key: galleryKey, child: const GallerySection()),
            KeyedSubtree(key: teamKey, child: const TeamSection()),
          ],
        ),
      ),
    );
  }

  Widget _navButton(String label, VoidCallback onPressed, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 10 : 16, // smaller on mobile
          ),
        ),
      ),
    );
  }
}
