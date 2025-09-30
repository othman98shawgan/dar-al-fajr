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

    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
        begin: const Offset(0, 0.2), // Start lower for more pronounced slide-up
        end: visible ? Offset.zero : const Offset(0, 0.2),
      ),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(0, offset.dy * MediaQuery.of(context).size.height),
          child: AnimatedOpacity(
            opacity: visible ? 1.0 : 0.0,
            duration: duration,
            curve: Curves.easeOut,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
