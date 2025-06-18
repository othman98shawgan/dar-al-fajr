import 'package:flutter/material.dart';

import '../widgets/scroll_arrow_button.dart';

class AboutSection extends StatelessWidget {
  final VoidCallback jumpToNext;
  final Animation<double> arrowAnimation;

  const AboutSection({super.key, required this.jumpToNext, required this.arrowAnimation});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final sectionHeight = screenHeight - 60; // Subtracting app bar height
    const sectionTitleFontSize = 36.0;

    return Container(
      height: screenHeight,
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x4DF1D31D), Color(0x101A6560)],
        ),
      ),
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
          SizedBox(height: sectionHeight * 0.30),
          SizedBox(
            height: sectionHeight * 0.05,
            child: ScrollArrowButton(
              arrowAnimation: arrowAnimation,
              jumpToNext: () => jumpToNext(),
            ),
          ),
        ],
      ),
    );
  }
}
