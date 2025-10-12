// lib/widgets/zoom_gallery.dart
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// Call this to open a fullscreen zoomable gallery.
Future<void> showPhotoGallery(
  BuildContext context, {
  required List<ImageProvider> providers,
  int initialIndex = 0,
  String? heroTagBase, // optional: enable Hero if you want (use same tag on the thumbnail)
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: true,
      barrierDismissible: true,
      pageBuilder: (_, __, ___) => _FullscreenGallery(
        providers: providers,
        initialIndex: initialIndex,
        heroTagBase: heroTagBase,
      ),
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
    ),
  );
}

/// Wrap any thumbnail with this to open the gallery on tap.
class ZoomableTap extends StatelessWidget {
  final Widget child;
  final List<ImageProvider> providers;
  final int initialIndex;
  final String? heroTagBase;

  const ZoomableTap({
    super.key,
    required this.child,
    required this.providers,
    this.initialIndex = 0,
    this.heroTagBase,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = child;
    if (heroTagBase != null) {
      body = Hero(tag: '$heroTagBase-$initialIndex', child: child);
    }
    return GestureDetector(
      onTap: () => showPhotoGallery(
        context,
        providers: providers,
        initialIndex: initialIndex,
        heroTagBase: heroTagBase,
      ),
      child: body,
    );
  }
}

class _FullscreenGallery extends StatefulWidget {
  final List<ImageProvider> providers;
  final int initialIndex;
  final String? heroTagBase;

  const _FullscreenGallery({
    required this.providers,
    required this.initialIndex,
    this.heroTagBase,
  });

  @override
  State<_FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<_FullscreenGallery> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.providers.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.providers.length,
            pageController: PageController(initialPage: _index),
            onPageChanged: (i) => setState(() => _index = i),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (context, i) {
              return PhotoViewGalleryPageOptions(
                imageProvider: widget.providers[i],
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                heroAttributes:
                    widget.heroTagBase == null ? null : PhotoViewHeroAttributes(tag: '${widget.heroTagBase}-$i'),
              );
            },
            // helpful on web/desktop for mouse wheel zoom:
            gaplessPlayback: true,
            allowImplicitScrolling: true,
          ),

          // Close + index overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${_index + 1}/${widget.providers.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
