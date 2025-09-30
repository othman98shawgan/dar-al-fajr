import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/animated_entry.dart';

class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;

    final galleryImages = List.generate(
      9,
      (index) => 'assets/images/image-${(index + 1).toString().padLeft(2, '0')}.jpg',
    );

    return VisibilityDetector(
      key: const Key('gallery-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 && !visible) {
          setState(() => visible = true);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
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
              child: const Text("Photo Gallery", style: TextStyle(fontSize: 36, color: Color(0xFF1A6560))),
            ),
            const SizedBox(height: 40),
            AnimatedEntry(
              visible: visible,
              delayMs: 300,
              child: Center(
                child: SizedBox(
                  width: isMobile ? screenWidth * 0.95 : screenWidth * 0.85,
                  child: CarouselSlider.builder(
                    itemCount: galleryImages.length,
                    itemBuilder: (context, index, realIdx) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.asset(
                              galleryImages[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      height: isMobile ? screenHeight * 0.32 : screenHeight * 0.6,
                      enlargeCenterPage: true,
                      viewportFraction: isMobile ? 0.88 : 0.72,
                      padEnds: true,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: isMobile ? 0 : 64),
          ],
        ),
      ),
    );
  }
}
