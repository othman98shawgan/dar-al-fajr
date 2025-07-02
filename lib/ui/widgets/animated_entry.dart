import 'package:flutter/material.dart';

class AnimatedEntry extends StatelessWidget {
  final Widget child;
  final bool visible;
  final int delayMs;

  const AnimatedEntry({
    super.key,
    required this.child,
    required this.visible,
    this.delayMs = 0,
  });

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: 500 + delayMs);

    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, 0.1),
      duration: duration,
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: duration,
        curve: Curves.easeOut,
        child: child,
      ),
    );
  }
}
