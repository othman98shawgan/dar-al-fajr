import 'package:flutter/material.dart';

import '../widgets/scroll_arrow_button.dart';

class HomeSection extends StatelessWidget {
  final VoidCallback jumpToNext;
  final VoidCallback donateButton;
  final Animation<double> arrowAnimation;

  const HomeSection({super.key, required this.jumpToNext, required this.donateButton, required this.arrowAnimation});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final stats = [
      {"label": "Active Students", "value": "70+"},
      {"label": "Weekly Class Hours", "value": "50+"},
      {"label": "Study Groups", "value": "10+"},
    ];

    final screenHeight = MediaQuery.of(context).size.height;
    final sectionHeight = screenHeight * 0.90; // Subtracting app bar height
    const sectionTitleFontSize = 36.0;

    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x4DF1D31D), Color(0x101A6560)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: sectionHeight * 0.1,
            child:
                const Text("Dar al-Fajr", style: TextStyle(fontSize: sectionTitleFontSize, color: Color(0xFF1A6560))),
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
              onPressed: () => donateButton(),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF1D31D), foregroundColor: Colors.black),
              child: const Text("Donate Now"),
            ),
          ),
          SizedBox(height: sectionHeight * 0.05),
          ScrollArrowButton(
            arrowAnimation: arrowAnimation,
            jumpToNext: () => jumpToNext(),
          ),
        ],
      ),
    );
  }
}
