import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DonateSection extends StatefulWidget {
  const DonateSection({super.key});

  @override
  State<DonateSection> createState() => _DonateSectionState();
}

class _DonateSectionState extends State<DonateSection> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    const bankDetails = "בנק: 17 - מרכנתיל דיסקונט בע\"מ\n"
        "סניף: התבור 695\n"
        "שם המוטב: דאר אל פג׳ר כפר כמא\n"
        "מספר חשבון: 69187";

    const bankDetailsTextStyle =
        TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87, locale: Locale("he", "IL"));

    return VisibilityDetector(
      key: const Key('donate-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 && !visible) {
          setState(() => visible = true);
        }
      },
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 800),
        child: AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, 0.2),
          duration: const Duration(milliseconds: 800),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x4DF1D31D), Color(0x101A6560)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Support Dar al-Fajr",
                    style: TextStyle(
                        fontSize: isMobile ? 26 : 36, color: const Color(0xFF1A6560), fontWeight: FontWeight.bold)),
                SizedBox(height: isMobile ? 32 : 48),
                Text(
                  "Your support helps us nurture the next generation of Qur'an learners and teachers.",
                  style: TextStyle(fontSize: isMobile ? 14 : 20, color: const Color(0xFF1A6560)),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: isMobile ? 32 : 48),

                Text(
                  "We are a registered non-profit organization. You can support us via bank transfer or card payment.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isMobile ? 12 : 18, color: Colors.black87),
                ),
                SizedBox(height: isMobile ? 12 : 24),
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: SelectableText(bankDetails, style: bankDetailsTextStyle),
                ),
                SizedBox(height: isMobile ? 32 : 48),
                ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Card payment feature coming soon!"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: const Color(0xFFF1D31D),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Pay with Card"),
                ),
                SizedBox(height: isMobile ? 0 : 96), // Spacer between sections
              ],
            ),
          ),
        ),
      ),
    );
  }
}
