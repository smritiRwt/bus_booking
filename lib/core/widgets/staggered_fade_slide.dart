import 'package:flutter/material.dart';

class StaggeredFadeSlide extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration duration;

  const StaggeredFadeSlide({
    super.key,
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  Widget build(BuildContext context) {
    // Stagger delay based on index capped at 8 items
    final delay = Duration(milliseconds: (index.clamp(0, 8) * 60));

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + delay,
      curve: Curves.easeOutCubic,
      builder: (context, value, animChild) {
        final slideY = (1.0 - value) * 24.0;
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, slideY),
            child: animChild,
          ),
        );
      },
      child: child,
    );
  }
}
