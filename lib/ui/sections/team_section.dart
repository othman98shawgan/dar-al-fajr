import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
        children: [
          const Text("Our Team", style: TextStyle(fontSize: 36, color: Color(0xFF1A6560))),
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
                                ),
                              ),
                              subtitle: InkWell(
                                onTap: () => launchUrl(
                                  Uri.parse("https://wa.me/${person['phone'].toString().replaceAll('+', '')}"),
                                ),
                                child: Text(
                                  "${person['phone']} - WhatsApp",
                                  style: const TextStyle(color: Color.fromARGB(255, 28, 166, 79)),
                                ),
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
    );
  }
}
