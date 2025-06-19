import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/scroll_arrow_button.dart';

class GallerySection extends StatelessWidget {
  final VoidCallback jumpToNext;
  final Animation<double> arrowAnimation;

  const GallerySection({super.key, required this.jumpToNext, required this.arrowAnimation});

  @override
  Widget build(BuildContext context) {
    // Generate a list of local asset paths for your 9 images
    final galleryImages = List.generate(
      9,
      (index) => 'assets/images/image-${(index + 1).toString().padLeft(2, '0')}.jpg',
    );

    final screenHeight = MediaQuery.of(context).size.height;
    final sectionHeight = screenHeight * 0.90; // Subtracting app bar height
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
            options: CarouselOptions(autoPlay: true, height: 500, enlargeCenterPage: true),
            // Use Image.asset for local images
            items: galleryImages
                .map((imgPath) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      // Change from Image.network to Image.asset
                      child: Image.asset(imgPath, fit: BoxFit.cover, width: double.infinity),
                    ))
                .toList(),
          ),
          ScrollArrowButton(
            arrowAnimation: arrowAnimation,
            jumpToNext: () => jumpToNext(),
          ),
        ],
      ),
    );
  }
}
