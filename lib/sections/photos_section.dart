import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../content/site_content.dart';
import '../i18n/locale_scope.dart';
import '../theme/brand.dart';
import '../widgets/zoom_gallery.dart';

class PhotosSection extends StatefulWidget {
  final AppLocale? locale;
  const PhotosSection({super.key, this.locale});
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

    WidgetsBinding.instance.addPostFrameCallback((_) => _warmCache());
  }

  Future<void> _warmCache() async {
    if (!mounted) return;

    final w = MediaQuery.sizeOf(context).width;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final isMobile = w < 900;

    final visibleW = w * (isMobile ? 1.0 : _viewportFraction);
    final targetW = (visibleW * dpr).clamp(600, 1600).round();

    final eagerCount = isMobile ? 6 : _providers.length;

    await Future.wait(
      _providers.take(eagerCount).map(
            (p) => precacheImage(ResizeImage(p, width: targetW), context),
          ),
      eagerError: false,
    );

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

  Future<void> _goRel(int delta) {
    if (images.isEmpty) return Future.value();
    final next = (_currentIndex + delta + images.length) % images.length;
    return _goAbs(next);
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
    final activeLocale = widget.locale ?? LocaleScope.of(context).value;

    _ensureViewportFraction(isMobile ? 1.0 : 0.85);

    final double height = isMobile ? 300 : 480;

    return Focus(
      autofocus: false,
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
          child: _buildGallery(height, isMobile, activeLocale),
        ),
      ),
    );
  }

  Widget _buildGallery(double height, bool isMobile, AppLocale locale) {
    final tt = Theme.of(context).textTheme;
    final title = t(PhotosContent.title, locale);
    final subtitle = t(PhotosContent.subtitle, locale);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Clear Section Header in Deep Teal (#1D6363)
        Container(
          width: 44,
          height: 4,
          decoration: BoxDecoration(
            color: Brand.yellow,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: tt.headlineMedium?.copyWith(
            color: Brand.green,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: tt.bodyLarge?.copyWith(color: Brand.text),
          ),
        ),
        SizedBox(height: isMobile ? 24 : 32),

        // Carousel Showcase Frame
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
                        scale = (1 - (diff * 0.08)).clamp(0.92, 1.0);
                      }
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Brand.outline, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x161D6363),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
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
                    ),
                  );
                },
              ),

              // PREVIOUS on physical LEFT
              if (images.length > 1)
                Positioned(
                  left: 12,
                  child: _NavButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => _goRel(isRtl ? 1 : -1),
                  ),
                ),

              // NEXT on physical RIGHT
              if (images.length > 1)
                Positioned(
                  right: 12,
                  child: _NavButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: () => _goRel(isRtl ? -1 : 1),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Sleek Pill Indicator ("1 / 27") instead of wrapping dots
        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Brand.card,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Brand.outline),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A1D6363),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: const Icon(Icons.chevron_left_rounded, color: Brand.green, size: 20),
                  onPressed: () => _goRel(isRtl ? 1 : -1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${_currentIndex + 1} / ${images.length}',
                    style: tt.labelLarge?.copyWith(
                      color: Brand.green,
                      fontWeight: FontWeight.w800,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: const Icon(Icons.chevron_right_rounded, color: Brand.green, size: 20),
                  onPressed: () => _goRel(isRtl ? -1 : 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

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
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Brand.green.withValues(alpha: 0.85),
        shape: const CircleBorder(),
        elevation: 3,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(icon, size: 26, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
