import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConfettiCelebration extends StatefulWidget {
  final Widget child;

  const ConfettiCelebration({
    super.key,
    required this.child,
  });

  @override
  State<ConfettiCelebration> createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _generateParticles();
    _controller.forward();
  }

  void _generateParticles() {
    final colors = [
      const Color(0xFFFF6B35), // Accent Orange
      const Color(0xFF0077B6), // Sky Blue
      const Color(0xFF10B981), // Emerald Green
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEC4899), // Pink
    ];

    for (int i = 0; i < 65; i++) {
      _particles.add(
        _ConfettiParticle(
          x: 0.5 + (_random.nextDouble() - 0.5) * 0.3,
          y: 0.2,
          speedX: (_random.nextDouble() - 0.5) * 600,
          speedY: -200 - _random.nextDouble() * 500,
          gravity: 550 + _random.nextDouble() * 350,
          color: colors[_random.nextInt(colors.length)],
          size: 6 + _random.nextDouble() * 6,
          rotation: _random.nextDouble() * 2 * math.pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 10,
          shape: _random.nextBool() ? _ParticleShape.rectangle : _ParticleShape.circle,
        ),
      );
    }
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
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              if (_controller.value >= 1.0) return const SizedBox.shrink();
              return CustomPaint(
                size: Size.infinite,
                painter: _ConfettiPainter(
                  particles: _particles,
                  progress: _controller.value,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

enum _ParticleShape { rectangle, circle }

class _ConfettiParticle {
  final double x;
  final double y;
  final double speedX;
  final double speedY;
  final double gravity;
  final Color color;
  final double size;
  final double rotation;
  final double rotationSpeed;
  final _ParticleShape shape;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.speedX,
    required this.speedY,
    required this.gravity,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.shape,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * 2.5; // time elapsed in seconds

    for (final p in particles) {
      final currentX = (p.x * size.width) + (p.speedX * t);
      final currentY = (p.y * size.height) + (p.speedY * t) + (0.5 * p.gravity * t * t);

      // Fade out as progress advances
      final opacity = (1.0 - (progress * 1.1)).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(p.rotation + p.rotationSpeed * t);

      if (p.shape == _ParticleShape.circle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
