import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AnimatedDriverCabin extends StatefulWidget {
  final String label;

  const AnimatedDriverCabin({
    super.key,
    this.label = 'Front / Driver Cabin',
  });

  @override
  State<AnimatedDriverCabin> createState() => _AnimatedDriverCabinState();
}

class _AnimatedDriverCabinState extends State<AnimatedDriverCabin>
    with TickerProviderStateMixin {
  late AnimationController _steerController;
  late AnimationController _spinController;
  bool _showHorn = false;

  @override
  void initState() {
    super.initState();
    // Continuous subtle steering
    _steerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Interactive 360 spin when tapped
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _spinController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showHorn = false);
        _spinController.reset();
      }
    });
  }

  @override
  void dispose() {
    _steerController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  void _onWheelTap() {
    setState(() => _showHorn = true);
    _spinController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Windshield & Road Icon + Label
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.alt_route_rounded, size: 18, color: AppColors.secondary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Entry & Windshield Ahead',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right: Interactive Animated Steering Wheel
          GestureDetector(
            onTap: _onWheelTap,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge([_steerController, _spinController]),
                  builder: (context, child) {
                    final idleAngle = (math.sin(_steerController.value * math.pi * 2)) * 0.22;
                    final spinAngle = _spinController.value * math.pi * 2;
                    return Transform.rotate(
                      angle: idleAngle + spinAngle,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9), // Slate 100
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.secondary, width: 1.8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.radio_button_checked_rounded,
                      size: 22,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                if (_showHorn)
                  Positioned(
                    top: -24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Honk! 🎺',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
