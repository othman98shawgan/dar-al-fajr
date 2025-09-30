import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../widgets/animated_entry.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return VisibilityDetector(
      key: const Key('about-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 64, 24, 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x4DF1D31D), Color(0x101A6560)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedEntry(
              visible: _visible,
              child: Text(
                "About the Center",
                style: TextStyle(
                  fontSize: isMobile ? 26 : 36,
                  color: const Color(0xFF1A6560),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: isMobile ? 32 : 96),
            AnimatedEntry(
              visible: _visible,
              delayMs: 300,
              child: SizedBox(
                width: isMobile ? double.infinity : MediaQuery.of(context).size.width * 0.6,
                child: const SelectableText(
                  "Dar al-Fajr is a Quranic education center dedicated to teaching the children and youth of Kfar Kama reading, memorization, and proper recitation of the Quran. The center operates five days a week and serves around 70 students, offering tailored programs for different levels starting from a young age. Our mission is to nurture a generation that loves the Quran and lives by its guidance.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: isMobile ? 0 : 96),
          ],
        ),
      ),
    );
  }
}
