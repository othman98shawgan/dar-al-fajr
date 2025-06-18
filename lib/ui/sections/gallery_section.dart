import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/scroll_arrow_button.dart';

class GallerySection extends StatelessWidget {
  final VoidCallback jumpToNext;
  final Animation<double> arrowAnimation;

  const GallerySection({super.key, required this.jumpToNext, required this.arrowAnimation});

  @override
  Widget build(BuildContext context) {
    final galleryImages = [
      'https://picsum.photos/id/1018/800/400',
      'https://picsum.photos/id/1015/800/400',
      'https://picsum.photos/id/1016/800/400',
    ];

    final screenHeight = MediaQuery.of(context).size.height;
    final sectionHeight = screenHeight - 60; // Subtracting app bar height
    const sectionTitleFontSize = 36.0;

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Photo Gallery", style: TextStyle(fontSize: sectionTitleFontSize, color: Color(0xFF1A6560))),
          const SizedBox(height: 16),
          CarouselSlider(
            options: CarouselOptions(autoPlay: true, height: 300, enlargeCenterPage: true),
            items: galleryImages
                .map((img) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(img, fit: BoxFit.cover, width: double.infinity),
                    ))
                .toList(),
          ),
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
