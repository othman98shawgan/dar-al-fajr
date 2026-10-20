import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../content/site_content.dart';
import '../theme/brand.dart';
import '../widgets/zoom_gallery.dart';

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
  late final List<ImageProvider> _providers;

  List<String> get images => PhotosContent.images;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(viewportFraction: _viewportFraction);
    _startTimer();
    _providers = images.map((p) => AssetImage(p) as ImageProvider).toList();

    // Warm the cache after we have a BuildContext
    WidgetsBinding.instance.addPostFrameCallback((_) => _warmCache());
  }

// Prefetch a small head set eagerly, then the rest in the background.
// No width/height on the widget; this only primes the decoder/cache.
  Future<void> _warmCache() async {
    if (!mounted) return;

    final w = MediaQuery.sizeOf(context).width;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final isMobile = w < 900;

    // Decode hint width roughly equal to on-screen card width (keeps aspect ratio).
    // This is only for the *prefetch*; your Image.asset stays unchanged.
    final visibleW = w * (isMobile ? 1.0 : _viewportFraction);
    final targetW = (visibleW * dpr).clamp(600, 1600).round();

    final eagerCount = isMobile ? 6 : _providers.length;

    // Eager prefetch first few
    await Future.wait(
      _providers.take(eagerCount).map(
            (p) => precacheImage(ResizeImage(p, width: targetW), context),
          ),
      eagerError: false,
    );

    // Background prefetch the rest without blocking a frame
    for (final p in _providers.skip(eagerCount)) {
      scheduleMicrotask(() {
        if (mounted) precacheImage(ResizeImage(p, width: targetW), context);
      });
    }
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

  void _restartTimer() {
    _timer?.cancel();
    _startTimer();
  }

  Future<void> _goAbs(int index) async {
    if (!_ctrl.hasClients || images.isEmpty) return;
    final clamped = index.clamp(0, images.length - 1);
    _restartTimer();
    await _ctrl.animateToPage(
      clamped,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  Future<void> _goRel(int delta) => _goAbs(_currentIndex + delta);

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

    return Focus(
      autofocus: true,
      child: Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.arrowLeft): _ArrowLeftIntent(),
          SingleActivator(LogicalKeyboardKey.arrowRight): _ArrowRightIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            _ArrowLeftIntent: CallbackAction<_ArrowLeftIntent>(onInvoke: (_) {
              _goRel(-1);
              return null;
            }),
            _ArrowRightIntent: CallbackAction<_ArrowRightIntent>(onInvoke: (_) {
              _goRel(1);
              return null;
            }),
          },
          child: _buildGallery(height, isMobile),
        ),
      ),
    );
  }

  Widget _buildGallery(double height, bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
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
                        child: ZoomableTap(
                          heroTagBase: 'gallery',
                          initialIndex: i,
                          providers: _providers,
                          child: Image.asset(
                            images[i],
                            fit: BoxFit.cover,
                            filterQuality: isMobile ? FilterQuality.medium : FilterQuality.high,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // PREVIOUS on physical LEFT
              if (images.length > 1)
                Positioned(
                  left: 8,
                  child: _NavButton(
                    icon: Icons.chevron_left,
                    onTap: () => _goRel(
                      Directionality.of(context) == TextDirection.rtl ? 1 : -1,
                    ),
                  ),
                ),

              // NEXT on physical RIGHT
              if (images.length > 1)
                Positioned(
                  right: 8,
                  child: _NavButton(
                    icon: Icons.chevron_right,
                    onTap: () => _goRel(
                      Directionality.of(context) == TextDirection.rtl ? -1 : 1,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          children: List.generate(images.length, (i) {
            final active = i == _currentIndex;
            return InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => _goAbs(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: active ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? Brand.green : Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ---- support types ----
class _ArrowLeftIntent extends Intent {
  const _ArrowLeftIntent();
}

class _ArrowRightIntent extends Intent {
  const _ArrowRightIntent();
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Freeze icon mirroring (always draw LTR so chevron directions are stable)
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.black.withOpacity(0.25),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
