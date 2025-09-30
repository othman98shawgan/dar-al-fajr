import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/brand.dart';

class PhotosSection extends StatefulWidget {
  const PhotosSection({super.key});
  @override
  State<PhotosSection> createState() => _PhotosSectionState();
}

class _PhotosSectionState extends State<PhotosSection> {
  late PageController _ctrl;
  Timer? _timer;
  int _currentIndex = 0;
  double _viewportFraction = 0.85;

  final images = List.generate(
    10,
    (i) => 'assets/images/image-${(i + 1).toString().padLeft(2, '0')}.jpg',
  );

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(viewportFraction: _viewportFraction);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_ctrl.hasClients || images.isEmpty) return;
      final next = (_currentIndex + 1) % images.length;
      _ctrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
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

  void _ensureViewportFraction(double desired) {
    if (desired == _viewportFraction) return;
    final oldIndex = _currentIndex;
    _viewportFraction = desired;
    final newCtrl = PageController(
      viewportFraction: _viewportFraction,
      initialPage: oldIndex,
    );
    _ctrl.dispose();
    _ctrl = newCtrl;
    _startTimer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 700;

    // Full width on mobile, peeking on desktop
    _ensureViewportFraction(isMobile ? 1.0 : 0.85);

    // Height adaptive
    final double height = isMobile ? 300 : 480;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _ctrl,
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, i) {
              return AnimatedBuilder(
                animation: _ctrl,
                builder: (context, child) {
                  double scale = 1.0;
                  if (_ctrl.position.haveDimensions) {
                    final page = _ctrl.page ?? _ctrl.initialPage.toDouble();
                    final diff = (page - i).abs();
                    scale = (1 - (diff * 0.1)).clamp(0.9, 1.0);
                  }
                  return Transform.scale(scale: scale, child: child);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      images[i],
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          children: List.generate(images.length, (i) {
            final active = i == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: active ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active ? Brand.green : Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
