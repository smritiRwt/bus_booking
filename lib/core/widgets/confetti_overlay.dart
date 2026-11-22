import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool autoPlay;

  const ConfettiOverlay({
    super.key,
    required this.child,
    this.autoPlay = true,
  });

  @override
  State<ConfettiOverlay> createState() => ConfettiOverlayState();
}

class ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..addListener(() {
        setState(() {});
      });

    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        play();
      });
    }
  }

  void play() {
    _particles.clear();
    final colors = [
      const Color(0xFF0077B6),
      const Color(0xFFFF6B35),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF38BDF8),
    ];

    for (int i = 0; i < 65; i++) {
      _particles.add(
        _ConfettiParticle(
          x: 0.1 + _random.nextDouble() * 0.8,
          y: -0.1 - _random.nextDouble() * 0.2,
          vx: (_random.nextDouble() - 0.5) * 0.6,
          vy: 0.5 + _random.nextDouble() * 0.8,
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 8,
          size: 6 + _random.nextDouble() * 8,
          color: colors[_random.nextInt(colors.length)],
          isCircle: _random.nextBool(),
        ),
      );
    }
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_controller.isAnimating)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ConfettiPainter(
                  particles: _particles,
                  progress: _controller.value,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  double rotation;
  double rotationSpeed;
  double size;
  Color color;
  bool isCircle;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
    required this.color,
    required this.isCircle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = progress;
      final currentX = (p.x + p.vx * t) * size.width;
      final currentY = (p.y + p.vy * t + 0.3 * t * t) * size.height;
      final currentRotation = p.rotation + p.rotationSpeed * t;
      final opacity = (1.0 - t * 0.8).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(currentRotation);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.6,
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
