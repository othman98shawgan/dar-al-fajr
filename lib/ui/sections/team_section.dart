import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/animated_entry.dart';

class TeamSection extends StatefulWidget {
  const TeamSection({super.key});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection> {
  bool visible = false;

  final management = [
    {"name": "Aslan Nash", "role": "Center Manager", "phone": "+972501234567"},
    {"name": "Ahmad Shawgan", "role": "Board member", "phone": "+972501234568"},
    {"name": "Noah Thawko", "role": "Board member", "phone": "+972501234568"},
    {"name": "Hani Ashmooz", "role": "Board member", "phone": "+972501234568"},
    {"name": "Sam Thawko", "role": "Board member", "phone": "+972501234568"},
  ];

  final String youtubeUrl = "https://www.youtube.com/@Dar-al-Fajr";
  final String contactEmail = "daralfajerkfarkama@gmail.com";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return VisibilityDetector(
      key: const Key('team-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 && !visible) {
          setState(() => visible = true);
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 64, vertical: 32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x4DF1D31D), Color(0x101A6560)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedEntry(
              visible: visible,
              delayMs: 100,
              child: const Text("Our Team", style: TextStyle(fontSize: 36, color: Color(0xFF1A6560))),
            ),
            const SizedBox(height: 32),
            AnimatedEntry(
              visible: visible,
              delayMs: 200,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: management.map(_buildCard).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            AnimatedEntry(
              visible: visible,
              delayMs: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.youtube, color: Colors.red),
                    onPressed: () => launchUrl(Uri.parse(youtubeUrl)),
                    tooltip: "Visit our YouTube channel",
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.email, color: Colors.black87),
                    onPressed: () => launchUrl(Uri.parse("mailto:$contactEmail")),
                    tooltip: contactEmail,
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 0 : 96),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map person) {
    return Card(
      child: ListTile(
        title: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87),
            children: [
              TextSpan(text: person['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              if (person['role'] != null) const TextSpan(text: " - "),
              if (person['role'] != null) TextSpan(text: person['role']!, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        subtitle: person['phone'] != null
            ? InkWell(
                onTap: () => launchUrl(
                  Uri.parse("https://wa.me/${person['phone'].toString().replaceAll('+', '')}"),
                ),
                child: Text(
                  "${person['phone']} - WhatsApp",
                  style: const TextStyle(color: Color.fromARGB(255, 28, 166, 79)),
                ),
              )
            : null,
      ),
    );
  }
}
