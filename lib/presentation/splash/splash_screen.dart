import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _roadController;

  @override
  void initState() {
    super.initState();
    _roadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _roadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Ambient Glow Orbs
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: 0.12),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Vehicle with suspension bounce & road
                AnimatedBuilder(
                  animation: _roadController,
                  builder: (context, child) {
                    final bounce = sin(_roadController.value * pi * 4) * 3.5;
                    return Transform.translate(
                      offset: Offset(0, bounce),
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Headlight Beams
                      Positioned(
                        right: -40,
                        top: 25,
                        child: Container(
                          width: 80,
                          height: 35,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFDE047).withValues(alpha: 0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Bus Logo Badge
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.5),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.directions_bus_rounded,
                          size: 56,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Animated Scrolling Road / Highway
                SizedBox(
                  width: 180,
                  height: 14,
                  child: AnimatedBuilder(
                    animation: _roadController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _HighwayRoadPainter(progress: _roadController.value),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // App Brand Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Smart',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      'Bus',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondaryLight,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.tagLine,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.75),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '100% Offline SQLite Architecture',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Loading Spinner
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.secondaryLight.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HighwayRoadPainter extends CustomPainter {
  final double progress;

  _HighwayRoadPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Road surface
    final roadPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(7),
      ),
      roadPaint,
    );

    // Dashed moving stripes
    final stripePaint = Paint()
      ..color = const Color(0xFFFDE047)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    const stripeLength = 16.0;
    const stripeGap = 16.0;
    final totalCycle = stripeLength + stripeGap;
    final offset = progress * totalCycle;

    for (double x = -totalCycle + offset; x < size.width + totalCycle; x += totalCycle) {
      final startX = x.clamp(0.0, size.width);
      final endX = (x + stripeLength).clamp(0.0, size.width);
      if (endX > startX) {
        canvas.drawLine(
          Offset(startX, size.height / 2),
          Offset(endX, size.height / 2),
          stripePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HighwayRoadPainter oldDelegate) => true;
}
