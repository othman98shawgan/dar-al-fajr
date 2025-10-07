// lib/widgets/site_logo.dart
import 'package:flutter/material.dart';

import 'site_content.dart';

class SiteLogo extends StatelessWidget {
  final double size;
  const SiteLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        ContentConfig.brandLogo,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        // Reserve layout space
        frameBuilder: (_, child, frame, __) {
          if (frame == null) {
            return Container(width: 48, height: 48, color: Colors.transparent);
          }
          return child;
        },
      ),
    );
  }
}
