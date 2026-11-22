import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AnimatedBusRoad extends StatefulWidget {
  final double height;
  final String? destinationName;

  const AnimatedBusRoad({
    super.key,
    this.height = 110,
    this.destinationName,
  });

  @override
  State<AnimatedBusRoad> createState() => _AnimatedBusRoadState();
}

class _AnimatedBusRoadState extends State<AnimatedBusRoad>
    with TickerProviderStateMixin {
  late AnimationController _roadController;
  late AnimationController _busHoverController;
  late AnimationController _honkController;
  bool _showHonkText = false;

  @override
  void initState() {
    super.initState();
    // Continuous road animation
    _roadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    // Subtle bus driving suspension bounce
    _busHoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    // Honk pop-up animation
    _honkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _honkController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showHonkText = false);
        _honkController.reset();
      }
    });
  }

  @override
  void dispose() {
    _roadController.dispose();
    _busHoverController.dispose();
    _honkController.dispose();
    super.dispose();
  }

  void _triggerHonk() {
    setState(() => _showHonkText = true);
    _honkController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0F172A),
            AppColors.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Ambient stars/clouds in sky
            Positioned(
              top: 10,
              left: 24,
              child: Icon(Icons.star, size: 8, color: Colors.white.withValues(alpha: 0.4)),
            ),
            Positioned(
              top: 18,
              right: 32,
              child: Icon(Icons.star, size: 10, color: Colors.amber.withValues(alpha: 0.5)),
            ),
            Positioned(
              top: 12,
              right: 110,
              child: Icon(Icons.star, size: 7, color: Colors.white.withValues(alpha: 0.3)),
            ),

            // Animated Road with moving center line
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 44,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                ),
                child: AnimatedBuilder(
                  animation: _roadController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _RoadPainter(offsetFraction: _roadController.value),
                    );
                  },
                ),
              ),
            ),

            // Bus with suspension hover and tap interaction
            Positioned(
              left: 36,
              bottom: 22,
              child: AnimatedBuilder(
                animation: _busHoverController,
                builder: (context, child) {
                  final dy = math.sin(_busHoverController.value * math.pi) * 2.2;
                  return Transform.translate(
                    offset: Offset(0, -dy),
                    child: GestureDetector(
                      onTap: _triggerHonk,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Bus Body
                          _buildBus(),
                          // Honk Bubble
                          if (_showHonkText)
                            Positioned(
                              top: -28,
                              right: -12,
                              child: ScaleTransition(
                                scale: CurvedAnimation(
                                  parent: _honkController,
                                  curve: Curves.elasticOut,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.accent.withValues(alpha: 0.4),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Beep Beep! 📢',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Top Info Bar (Route destination or Express tag)
            Positioned(
              top: 14,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'LIVE HIGHWAY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.destinationName != null
                            ? 'Heading to ${widget.destinationName}'
                            : 'SmartBus Express Highway',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.touch_app_rounded, size: 12, color: AppColors.secondaryLight),
                        SizedBox(width: 4),
                        Text(
                          'Tap Bus to Honk',
                          style: TextStyle(
                            color: AppColors.secondaryLight,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBus() {
    return Container(
      width: 140,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          // Headlight Beam
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.4),
            blurRadius: 18,
            spreadRadius: 4,
            offset: const Offset(36, 0),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Orange Accent Racing Stripe
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            height: 4,
            child: Container(color: AppColors.accent),
          ),
          // Front Windshield
          Positioned(
            top: 5,
            right: 6,
            width: 24,
            height: 18,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFBAE6FD),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ),
          // Passenger Windows
          Positioned(
            top: 6,
            left: 8,
            right: 36,
            height: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (i) => Container(
                  width: 16,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBAE6FD),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          // Bus Brand Label
          Positioned(
            bottom: 18,
            left: 10,
            child: const Text(
              'SMARTBUS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ),
          // Headlight
          Positioned(
            right: 2,
            bottom: 8,
            child: Container(
              width: 5,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Left Wheel
          Positioned(
            left: 18,
            bottom: -6,
            child: _buildWheel(),
          ),
          // Right Wheel
          Positioned(
            right: 22,
            bottom: -6,
            child: _buildWheel(),
          ),
        ],
      ),
    );
  }

  Widget _buildWheel() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: Center(
        child: Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: Colors.amberAccent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _RoadPainter extends CustomPainter {
  final double offsetFraction;

  _RoadPainter({required this.offsetFraction});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final dashWidth = 18.0;
    final dashSpace = 16.0;
    final totalSpan = dashWidth + dashSpace;
    final y = size.height / 2;

    // Moving from right to left
    final shift = offsetFraction * totalSpan;

    double startX = -totalSpan + shift;
    while (startX < size.width + totalSpan) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        paint,
      );
      startX += totalSpan;
    }
  }

  @override
  bool shouldRepaint(covariant _RoadPainter oldDelegate) {
    return oldDelegate.offsetFraction != offsetFraction;
  }
}
