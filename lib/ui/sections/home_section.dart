import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeSection extends StatefulWidget {
  final GlobalKey<State<StatefulWidget>> donateKey;
  const HomeSection({super.key, required this.donateKey});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> with SingleTickerProviderStateMixin {
  bool _visible = false;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _offsetAnimation = Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final stats = [
      {"label": "Active Students", "value": "70+"},
      {"label": "Weekly Class Hours", "value": "50+"},
      {"label": "Study Groups", "value": "10+"},
    ];

    return VisibilityDetector(
      key: const Key('home-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_visible) {
          setState(() => _visible = true);
          _controller.forward();
        }
      },
      child: Container(
        padding: isMobile ? const EdgeInsets.fromLTRB(24, 20, 24, 20) : const EdgeInsets.fromLTRB(24, 80, 24, 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x4DF1D31D), Color(0x101A6560)],
          ),
        ),
        child: SlideTransition(
          position: _offsetAnimation,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _visible ? 1.0 : 0.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Dar al-Fajr",
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 40,
                    color: const Color(0xFF1A6560),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                const Text(
                  "The Prophet (PBUH) said:\n\"The best of you are those who learn the Qur'an and teach it.\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: isMobile ? 56 : 72),
                Text(
                  "Join us in our mission to spread knowledge and understanding of the Qur'an.",
                  style: TextStyle(fontSize: isMobile ? 16 : 20, color: const Color(0xFF1A6560)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 56 : 56),
                isMobile
                    ? Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        alignment: WrapAlignment.center,
                        children: stats
                            .map((stat) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(stat['value']!,
                                        style: const TextStyle(fontSize: 20, color: Color(0xFF1A6560))),
                                    Text(stat['label']!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                  ],
                                ))
                            .toList(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: stats
                            .map((stat) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(stat['value']!,
                                          style: const TextStyle(fontSize: 24, color: Color(0xFF1A6560))),
                                      Text(stat['label']!, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),

                SizedBox(height: isMobile ? 56 : 96),
                ElevatedButton(
                  onPressed: () {
                    Scrollable.ensureVisible(
                      widget.donateKey.currentContext!,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1D31D),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 28 : 36, vertical: isMobile ? 14 : 18),
                    textStyle: TextStyle(fontSize: isMobile ? 16 : 18),
                  ),
                  child: const Text("Donate Now"),
                ),
                SizedBox(height: isMobile ? 0 : 64), // Spacer between sections
              ],
            ),
          ),
        ),
      ),
    );
  }
}
