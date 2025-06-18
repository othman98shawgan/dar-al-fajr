import 'package:flutter/material.dart';

class ScrollArrowButton extends StatelessWidget {
  final Animation<double> arrowAnimation;
  final VoidCallback jumpToNext;

  const ScrollArrowButton({
    super.key,
    required this.arrowAnimation,
    required this.jumpToNext,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: arrowAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, arrowAnimation.value),
        child: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 36, color: Color(0xFF1A6560)),
          onPressed: jumpToNext,
        ),
      ),
    );
  }
}
