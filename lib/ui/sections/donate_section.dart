import 'package:flutter/material.dart';

import '../widgets/scroll_arrow_button.dart';

class DonateSection extends StatelessWidget {
  final VoidCallback jumpToNext;
  final Animation<double> arrowAnimation;

  const DonateSection({super.key, required this.jumpToNext, required this.arrowAnimation});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final sectionHeight = screenHeight - 60; // Subtracting app bar height
    const sectionTitleFontSize = 36.0;
    const bankDetails = "Bank Name: Al Quds Islamic Bank\n"
        "Branch: Kfar Kama Branch (123)\n"
        "Account Number: 456789123";
    const bankDetailsTextStyle = TextStyle(fontSize: 18, color: Colors.black87);

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
          SizedBox(height: sectionHeight * 0.1),
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
