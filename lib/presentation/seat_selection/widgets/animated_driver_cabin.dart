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
    with SingleTickerProviderStateMixin {
  late AnimationController _steerController;

  @override
  void initState() {
    super.initState();
    _steerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _steerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.alt_route_rounded, size: 16, color: AppColors.secondaryLight),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Entry & Windshield Ahead',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right: Animated Steering Wheel
          AnimatedBuilder(
            animation: _steerController,
            builder: (context, child) {
              // Smooth gentle steering left and right
              final angle = (math.sin(_steerController.value * math.pi * 2)) * 0.22;
              return Transform.rotate(
                angle: angle,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondaryLight, width: 1.5),
              ),
              child: const Icon(
                Icons.radio_button_checked_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
