// Quran Center Landing Page in Flutter Web
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

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
            icon: const Icon(Icons.arrow_drop_down, size: 60, color: Color(0xFF1A6560)),
            onPressed: () => scrollToPage(pageIndex),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = [
      {"label": "Active Students", "value": "70+"},
      {"label": "Weekly Class Hours", "value": "50+"},
      {"label": "Study Groups", "value": "10+"},
    ];

    final galleryImages = [
      'https://picsum.photos/id/1018/800/400',
      'https://picsum.photos/id/1015/800/400',
      'https://picsum.photos/id/1016/800/400',
    ];

    final management = [
      {"name": "Aslan Nash", "role": "Center Manager", "phone": "+972501234567"},
      {"name": "Ahmad Shawgan", "role": "Board member", "phone": "+972501234568"},
      {"name": "Noah Thawko", "role": "Board member", "phone": "+972501234568"},
      {"name": "Hani Ashmooz", "role": "Board member", "phone": "+972501234568"},
      {"name": "Sam Thawko", "role": "Board member", "phone": "+972501234568"},
    ];

    final teachers = [
      {"name": "Ghazi Ashmooz", "role": "Teacher"},
      {"name": "Haroun Thawko", "role": "Teacher"},
      {"name": "Abdulrahman Labay", "role": "Teacher"},
      {"name": "Othman Shawgan", "role": "Teacher"},
      {"name": "Nurdin Shamsi", "role": "Teacher"},
    ];

    Widget sectionWrapper({required Widget child}) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x4DF1D31D), Color(0x101A6560)],
          ),
        ),
        child: child,
      );
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final sectionHeight = screenHeight - 60; // Subtracting app bar height
    const toolbarButtonSize = 18.0;
    const sectionTitleFontSize = 36.0;
    const bankDetails = "Bank Name: Al Quds Islamic Bank\n"
        "Branch: Kfar Kama Branch (123)\n"
        "Account Number: 456789123";
    const bankDetailsTextStyle = TextStyle(fontSize: 18, color: Colors.black87);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          height: double.infinity,
          color: const Color(0xFF1A6560),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => scrollToPage(0),
                child: const Text("Home", style: TextStyle(fontSize: toolbarButtonSize, color: Colors.white)),
              ),
              TextButton(
                onPressed: () => scrollToPage(1),
                child: const Text("About", style: TextStyle(fontSize: toolbarButtonSize, color: Colors.white)),
              ),
              TextButton(
                onPressed: () => scrollToPage(2),
                child: const Text("Donate", style: TextStyle(fontSize: toolbarButtonSize, color: Colors.white)),
              ),
              TextButton(
                onPressed: () => scrollToPage(3),
                child: const Text("Gallery", style: TextStyle(fontSize: toolbarButtonSize, color: Colors.white)),
              ),
              TextButton(
                onPressed: () => scrollToPage(4),
                child: const Text("Team", style: TextStyle(fontSize: toolbarButtonSize, color: Colors.white)),
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
          sectionWrapper(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: sectionHeight * 0.1,
                  child: const Text("Dar al-Fajr",
                      style: TextStyle(fontSize: sectionTitleFontSize, color: Color(0xFF1A6560))),
                ),
                SizedBox(
                  height: sectionHeight * 0.1,
                ),
                SizedBox(
                  height: sectionHeight * 0.1,
                  child: const Text(
                      "The Prophet (PBUH) said:\n\"The best of you are those who learn the Qur'an and teach it.\"",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                ),
                SizedBox(height: sectionHeight * 0.25),
                SizedBox(
                  height: sectionHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: stats
                        .map((stat) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Text(stat['value']!, style: const TextStyle(fontSize: 24, color: Color(0xFF1A6560))),
                                  Text(stat['label']!, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(height: sectionHeight * 0.05),
                SizedBox(
                  height: sectionHeight * 0.05,
                  child: ElevatedButton(
                    onPressed: () => scrollToPage(2),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1D31D), foregroundColor: Colors.black),
                    child: const Text("Donate Now"),
                  ),
                ),
                SizedBox(height: sectionHeight * 0.05),
                SizedBox(
                  height: sectionHeight * 0.1,
                  child: jumpButton(1),
                ),
              ],
            ),
          ),
          sectionWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: sectionHeight * 0.05),
                SizedBox(
                  height: sectionHeight * 0.1,
                  child: const Text("About the Center",
                      style: TextStyle(fontSize: sectionTitleFontSize, color: Color(0xFF1A6560))),
                ),
                SizedBox(height: sectionHeight * 0.1),
                SizedBox(
                  height: sectionHeight * 0.3,
                  width: screenWidth * 0.5,
                  child: const SelectableText(
                    "Dar al-Fajr is a Quranic education center dedicated to teaching the children and youth of Kfar Kama reading, memorization, and proper recitation of the Quran. "
                    "The center operates five days a week and serves around 70 students, offering tailored programs for different levels starting from a young age."
                    " Our mission is to nurture a generation that loves the Quran and lives by its guidance.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: sectionHeight * 0.25),
                SizedBox(
                  height: sectionHeight * 0.1,
                  child: jumpButton(2),
                ),
              ],
            ),
          ),
          sectionWrapper(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: sectionHeight * 0.25),
                SizedBox(
                  height: sectionHeight * 0.10,
                  child: const Text("Donate to Dar al-Fajr",
                      style: TextStyle(fontSize: sectionTitleFontSize, color: Color(0xFF1A6560))),
                ),
                SizedBox(height: sectionHeight * 0.05),
                SizedBox(
                  height: sectionHeight * 0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SelectableText(bankDetails, style: bankDetailsTextStyle),
                      SizedBox(height: sectionHeight * 0.05),
                      ElevatedButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Card payment feature coming soon!")),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50), // width: 200, height: 60
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            textStyle: const TextStyle(fontSize: 18),
                            backgroundColor: const Color(0xFFF1D31D),
                            foregroundColor: Colors.black),
                        child: const Text("Pay with Card"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sectionHeight * 0.05),
                jumpButton(3),
              ],
            ),
          ),
          sectionWrapper(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Photo Gallery", style: TextStyle(fontSize: sectionTitleFontSize, color: Color(0xFF1A6560))),
                const SizedBox(height: 16),
                CarouselSlider(
                  options: CarouselOptions(autoPlay: true, height: 300, enlargeCenterPage: true),
                  items: galleryImages
                      .map((img) => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(img, fit: BoxFit.cover, width: double.infinity),
                          ))
                      .toList(),
                ),
                jumpButton(4),
              ],
            ),
          ),
          sectionWrapper(
            child: Column(
              children: [
                const Text("Our Team", style: TextStyle(fontSize: sectionTitleFontSize, color: Color(0xFF1A6560))),
                SizedBox(height: screenHeight * 0.05),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.3,
                      child: Column(
                        children: management
                            .map((person) => Card(
                                  child: ListTile(
                                    title: RichText(
                                        text: TextSpan(
                                      style: const TextStyle(color: Colors.black87),
                                      children: [
                                        TextSpan(
                                            text: person['name']!,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        const TextSpan(text: " - "),
                                        TextSpan(text: person['role']!, style: const TextStyle(fontSize: 16)),
                                      ],
                                    )),
                                    // title: Text("${person['name']} - ${person['role']}",
                                    //     style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: InkWell(
                                      onTap: () => launchUrl(
                                          Uri.parse("https://wa.me/${person['phone'].toString().replaceAll('+', '')}")),
                                      child: Text("${person['phone']} - WhatsApp",
                                          style: const TextStyle(color: Color.fromARGB(255, 28, 166, 79))),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 24),
                    SizedBox(
                      width: screenWidth * 0.3,
                      child: Column(
                        children: teachers
                            .map((t) => Card(
                                  child: ListTile(
                                    title: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(color: Colors.black87),
                                        children: [
                                          TextSpan(
                                              text: t['name']!,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                          const TextSpan(text: " - "),
                                          TextSpan(text: t['role']!, style: const TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
