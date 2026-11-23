import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AnimatedBusRoad extends StatefulWidget {
  final double height;
  final String? destinationName;

  const AnimatedBusRoad({
    super.key,
    this.height = 118,
    this.destinationName,
  });

  @override
  State<AnimatedBusRoad> createState() => _AnimatedBusRoadState();
}

class _AnimatedBusRoadState extends State<AnimatedBusRoad>
    with TickerProviderStateMixin {
  late AnimationController _roadController;
  late AnimationController _busHoverController;
  late AnimationController _cloudController;
  late AnimationController _honkController;
  late AnimationController _turboController;

  bool _showHonkText = false;
  double _busDragOffset = 0.0;
  bool _showSparkles = false;
  Offset _sparklePosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    // Continuous road animation
    _roadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Subtle bus driving suspension bounce
    _busHoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);

    // Drifting clouds in daytime sky
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 14000),
    )..repeat();

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

    // Turbo speed burst when tapped
    _turboController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _roadController.dispose();
    _busHoverController.dispose();
    _cloudController.dispose();
    _honkController.dispose();
    _turboController.dispose();
    super.dispose();
  }

  void _triggerHonk() {
    setState(() => _showHonkText = true);
    _honkController.forward(from: 0.0);
    _turboController.forward(from: 0.0).then((_) => _turboController.reverse());
  }

  void _triggerSkyTap(TapDownDetails details) {
    setState(() {
      _showSparkles = true;
      _sparklePosition = details.localPosition;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showSparkles = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _triggerSkyTap,
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBAE6FD), // Sky 200
              Color(0xFFE0F2FE), // Sky 100
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF7DD3FC), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0284C7).withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Drifting Fluffy Daylight Clouds
              AnimatedBuilder(
                animation: _cloudController,
                builder: (context, child) {
                  final screenW = MediaQuery.of(context).size.width;
                  final x1 = (screenW + 100) * _cloudController.value - 60;
                  final x2 = (screenW + 120) * ((_cloudController.value + 0.5) % 1.0) - 80;
                  return Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: x1,
                        child: Icon(Icons.cloud_rounded, size: 36, color: Colors.white.withValues(alpha: 0.7)),
                      ),
                      Positioned(
                        top: 24,
                        left: x2,
                        child: Icon(Icons.cloud_rounded, size: 28, color: Colors.white.withValues(alpha: 0.5)),
                      ),
                    ],
                  );
                },
              ),

              // Sun ray sparkle badge in top right
              Positioned(
                top: 8,
                right: 14,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade300.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 16),
                  ),
                ),
              ),

              // Tap sparkles on sky
              if (_showSparkles)
                Positioned(
                  left: _sparklePosition.dx - 16,
                  top: _sparklePosition.dy - 16,
                  child: const Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
                ),

              // Animated Highway Road with Moving White Dashes
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 48,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF334155), // Slate 700
                    border: Border(
                      top: BorderSide(color: Color(0xFFFACC15), width: 2.5), // Yellow curb
                    ),
                  ),
                  child: AnimatedBuilder(
                    animation: _roadController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _DaylightRoadPainter(offsetFraction: _roadController.value),
                      );
                    },
                  ),
                ),
              ),

              // Interactive Bus (Hover, Drag, Tap-to-Honk)
              Positioned(
                left: 28 + _busDragOffset,
                bottom: 24,
                child: AnimatedBuilder(
                  animation: Listenable.merge([_busHoverController, _turboController]),
                  builder: (context, child) {
                    final dy = math.sin(_busHoverController.value * math.pi) * 2.2;
                    final turboScale = 1.0 + (_turboController.value * 0.08);
                    return Transform.translate(
                      offset: Offset(0, -dy),
                      child: Transform.scale(
                        scale: turboScale,
                        child: GestureDetector(
                          onTap: _triggerHonk,
                          onHorizontalDragUpdate: (details) {
                            setState(() {
                              _busDragOffset = (_busDragOffset + details.primaryDelta!)
                                  .clamp(-20.0, 100.0);
                            });
                          },
                          onHorizontalDragEnd: (_) {
                            setState(() => _busDragOffset = 0.0);
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Bus Body
                              _buildBus(),

                              // Honk Speech Bubble
                              if (_showHonkText)
                                Positioned(
                                  top: -30,
                                  right: -10,
                                  child: ScaleTransition(
                                    scale: CurvedAnimation(
                                      parent: _honkController,
                                      curve: Curves.elasticOut,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.accent.withValues(alpha: 0.35),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: const Text(
                                        'Beep Beep! 📢',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Top Info Bar (Route destination or Express tag)
              Positioned(
                top: 10,
                left: 16,
                right: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
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
                              : 'SmartBus Daylight Express',
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFBAE6FD)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.touch_app_rounded, size: 12, color: AppColors.secondary),
                          SizedBox(width: 4),
                          Text(
                            'Tap Bus to Honk',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
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
      ),
    );
  }

  Widget _buildBus() {
    return Container(
      width: 144,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          // Headlight Beam
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.35),
            blurRadius: 16,
            spreadRadius: 3,
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
              decoration: const BoxDecoration(
                color: Color(0xFFE0F2FE),
                borderRadius: BorderRadius.only(
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
                  width: 17,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(3),
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
        border: Border.all(color: Colors.grey.shade300, width: 2),
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

class _DaylightRoadPainter extends CustomPainter {
  final double offsetFraction;

  _DaylightRoadPainter({required this.offsetFraction});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.5
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
  bool shouldRepaint(covariant _DaylightRoadPainter oldDelegate) {
    return oldDelegate.offsetFraction != offsetFraction;
  }
}
