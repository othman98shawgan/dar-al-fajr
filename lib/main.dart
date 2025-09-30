// main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for Clipboard
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const DarAlFajrApp());

/// === Brand palette from your logo ===
class Brand {
  static const green = Color(0xFF006C5B); // main brand green
  static const yellow = Color(0xFFFFD43B); // accent yellow
  static const bg = Color(0xFFFDFDFB); // soft white
  static const text = Color(0xFF1E1E1E); // body text
}

class DarAlFajrApp extends StatelessWidget {
  const DarAlFajrApp({super.key});
  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: Brand.text,
      displayColor: Brand.green,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dar al-Fajr',
      theme: base.copyWith(
        textTheme: textTheme,
        scaffoldBackgroundColor: Brand.bg,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Brand.green,
          onPrimary: Colors.white,
          secondary: Brand.yellow,
          onSecondary: Brand.green,
          surface: Colors.white,
          onSurface: Brand.text,
          background: Brand.bg,
          onBackground: Brand.text,
          error: Colors.red,
          onError: Colors.white,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Brand.yellow,
            foregroundColor: Brand.green,
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Brand.green,
            side: const BorderSide(color: Brand.green),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        cardTheme: const CardTheme(
          elevation: 0.5,
          surfaceTintColor: Colors.transparent,
          clipBehavior: Clip.antiAlias,
        ),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final donateKey = GlobalKey();
  final photosKey = GlobalKey();
  final contactKey = GlobalKey();
  final scrollCtrl = ScrollController();

  Future<void> _scrollTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.05,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nav = [
      ('Home', homeKey),
      ('About', aboutKey),
      ('Donate', donateKey),
      ('Photos', photosKey),
      ('Contact', contactKey),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 72,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Row(children: [
          // TODO: replace with real logo asset
          const FlutterLogo(size: 28),
          const SizedBox(width: 12),
          const Text(
            'Dar al-Fajr',
            style: TextStyle(fontWeight: FontWeight.w700, color: Brand.green),
          ),
          const Spacer(),
          Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final item in nav.take(4))
                TextButton(
                  onPressed: () => _scrollTo(item.$2),
                  child: Text(item.$1, style: const TextStyle(color: Brand.green)),
                ),
              // Accent CTA
              FilledButton(
                onPressed: () => _scrollTo(donateKey),
                child: const Text('Donate'),
              ),
            ],
          )
        ]),
      ),
      body: SingleChildScrollView(
        controller: scrollCtrl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Section(key: homeKey, child: const HomeSection()),
            Section(key: aboutKey, child: const AboutSection()),
            Section(key: donateKey, child: const DonationSection()),
            Section(key: photosKey, child: const PhotosSection()),
            Section(key: contactKey, child: const ContactSection()),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final Widget child;
  const Section({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: child,
        ),
      ),
    );
  }
}

// ===== Home =====
class HomeSection extends StatelessWidget {
  const HomeSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'وَقُل رَّبِّ زِدْنِي عِلْمًا',
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            // Arabic headline
            textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(color: Brand.green),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Building hearts and minds through Qur’an, character, and community.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 28),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 24,
          runSpacing: 16,
          children: const [
            StatCard(label: 'Students', value: '180+'),
            StatCard(label: 'Weekly Classes', value: '25'),
            StatCard(label: 'Volunteers', value: '30'),
            StatCard(label: 'Years Serving', value: '6'),
          ],
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () {
            // handled by nav Donate scroll; could be passed down as a callback
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text('Donate Now'),
          ),
        )
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label, value;
  const StatCard({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Brand.green,
                  ),
            ),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}

// ===== About =====
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('About Dar al-Fajr', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            const Text(
              'We are a community center dedicated to Qur’an learning, character education, and service. '
              'Our programs support students, parents, and volunteers with structured learning and real-world impact.',
            ),
            const SizedBox(height: 16),
            Wrap(spacing: 12, runSpacing: 12, children: const [
              Pill('Education'),
              Pill('Community'),
              Pill('Service'),
            ]),
          ]),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ColoredBox(color: Colors.black12, child: Center(child: Text('Photo'))),
            ),
          ),
        )
      ],
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  const Pill(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      side: const BorderSide(color: Brand.green),
      backgroundColor: Brand.bg,
      labelStyle: const TextStyle(color: Brand.green),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

// ===== Donation =====
class DonationSection extends StatelessWidget {
  const DonationSection({super.key});
  @override
  Widget build(BuildContext context) {
    final bankBlock = 'Bank: ...\nAccount Name: ...\nAccount Number: ...\nIBAN: ...\nSWIFT: ...';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Make an Impact Today', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 8),
      const Text('Your support sustains classes, scholarships, and community programs.'),
      const SizedBox(height: 16),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Bank Transfer', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SelectableText(bankBlock, style: const TextStyle(fontFamily: 'monospace')),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Clipboard.setData(ClipboardData(text: bankBlock)),
              child: const Text('Copy Details'),
            ),
          ]),
        ),
      ),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: () {
          // TODO: link to external card processor
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text('Pay by Card'),
        ),
      )
    ]);
  }
}

// ===== Photos (peek carousel) =====
class PhotosSection extends StatefulWidget {
  const PhotosSection({super.key});
  @override
  State<PhotosSection> createState() => _PhotosSectionState();
}

class _PhotosSectionState extends State<PhotosSection> {
  late final PageController _ctrl;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(viewportFraction: 0.85);
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_ctrl.hasClients) return;
      final next = (_ctrl.page ?? 0).round() + 1;
      _ctrl.animateToPage(
        next % 5, // replace 5 with images.length
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = List.generate(5, (i) => Colors.grey[(i + 3) * 100]!);
    return SizedBox(
      height: 360,
      child: PageView.builder(
        controller: _ctrl,
        itemCount: images.length,
        itemBuilder: (context, i) {
          return AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              double value = 1.0;
              if (_ctrl.position.haveDimensions) {
                value = ((_ctrl.page ?? _ctrl.initialPage) - i).toDouble();
                value = (1 - (value.abs() * 0.1)).clamp(0.9, 1.0);
              }
              return Transform.scale(scale: value, child: child);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ColoredBox(color: images[i], child: const SizedBox.expand()),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ===== Contact =====
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});
  @override
  Widget build(BuildContext context) {
    final members = [
      ('Ghazi Ashmooz', 'Director', 'mailto:...', 'https://wa.me/9725...', 'https://youtube.com/...'),
      ('Haroun Thawko', 'Programs Lead', 'mailto:...', 'https://wa.me/9725...', 'https://youtube.com/...'),
      ('Othman Shawgan', 'Tech & Media', 'mailto:...', 'https://wa.me/9725...', 'https://youtube.com/...'),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Contact Us', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 16),
      Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (final m in members)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(m.$1, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                    Text(m.$2),
                    const SizedBox(height: 8),
                    Row(children: [
                      IconButton(
                          onPressed: () {/* launchUrl(Uri.parse(m.$3)) */},
                          icon: const Icon(Icons.email),
                          color: Brand.green),
                      IconButton(
                          onPressed: () {/* launchUrl(Uri.parse(m.$4)) */},
                          icon: const Icon(Icons.phone),
                          color: Brand.green),
                      IconButton(
                          onPressed: () {/* launchUrl(Uri.parse(m.$5)) */},
                          icon: const Icon(Icons.ondemand_video),
                          color: Brand.green),
                    ]),
                  ]),
                ),
              ),
            ),
        ],
      ),
    ]);
  }
}
