import 'package:flutter/material.dart';

class PulseRadarWidget extends StatefulWidget {
  final Color color;
  final double size;
  final Widget? centerChild;

  const PulseRadarWidget({
    super.key,
    this.color = const Color(0xFF10B981),
    this.size = 32.0,
    this.centerChild,
  });

  @override
  State<PulseRadarWidget> createState() => _PulseRadarWidgetState();
}

class _PulseRadarWidgetState extends State<PulseRadarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _controller.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer Wave
              Container(
                width: widget.size * (0.4 + 0.6 * progress),
                height: widget.size * (0.4 + 0.6 * progress),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: (1.0 - progress) * 0.45),
                ),
              ),
              // Inner Wave
              Container(
                width: widget.size * (0.3 + 0.4 * progress),
                height: widget.size * (0.3 + 0.4 * progress),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: (1.0 - progress) * 0.7),
                ),
              ),
              // Core dot or child
              widget.centerChild ??
                  Container(
                    width: widget.size * 0.35,
                    height: widget.size * 0.35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
