// Quran Center Landing Page in Flutter Web
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

class _QuranCenterHomePageState extends State<QuranCenterHomePage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late final AnimationController _arrowController;
  late final Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _arrowAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  void scrollToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  Widget jumpButton(int pageIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: AnimatedBuilder(
        animation: _arrowAnimation,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _arrowAnimation.value),
          child: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, size: 36, color: Color(0xFF1A6560)),
            onPressed: () => scrollToPage(pageIndex),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: const Color(0xFF1A6560),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => scrollToPage(0),
                child: const Text("Home", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => scrollToPage(1),
                child: const Text("About", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => scrollToPage(2),
                child: const Text("Donate", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => scrollToPage(3),
                child: const Text("Gallery", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => scrollToPage(4),
                child: const Text("Team", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        pageSnapping: true,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          HomeSection(
              jumpToNext: () => scrollToPage(1), donateButton: () => scrollToPage(2), arrowAnimation: _arrowAnimation),
          AboutSection(jumpToNext: () => scrollToPage(2), arrowAnimation: _arrowAnimation),
          DonateSection(jumpToNext: () => scrollToPage(3), arrowAnimation: _arrowAnimation),
          GallerySection(jumpToNext: () => scrollToPage(4), arrowAnimation: _arrowAnimation),
          TeamSection(),
        ],
      ),
    );
  }
}
