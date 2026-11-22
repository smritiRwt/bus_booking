import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AnimatedBusCockpit extends StatefulWidget {
  final String busType;
  final String deckLabel;

  const AnimatedBusCockpit({
    super.key,
    required this.busType,
    required this.deckLabel,
  });

  @override
  State<AnimatedBusCockpit> createState() => _AnimatedBusCockpitState();
}

class _AnimatedBusCockpitState extends State<AnimatedBusCockpit>
    with SingleTickerProviderStateMixin {
  late AnimationController _steerController;

  @override
  void initState() {
    super.initState();
    _steerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24), bottom: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Front Windshield Glass Area
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1E293B),
                  AppColors.primary.withValues(alpha: 0.95),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Headlight
                _buildHeadlight(true),
                // Center Windshield Wiper & Brand
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_rounded, size: 12, color: AppColors.secondaryLight),
                          const SizedBox(width: 4),
                          Text(
                            widget.deckLabel.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Right Headlight
                _buildHeadlight(false),
              ],
            ),
          ),
          // Cockpit Dashboard Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: const Color(0xFF1E293B),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Driver Station with Animated Steering Wheel
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: _steerController,
                      builder: (context, child) {
                        final angle = sin(_steerController.value * pi * 2) * 0.25;
                        return Transform.rotate(
                          angle: angle,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.secondaryLight, width: 2),
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                            child: const Icon(
                              Icons.album_outlined,
                              size: 16,
                              color: AppColors.secondaryLight,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Driver Cabin',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Front View',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Entry / Door Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.meeting_room_rounded, size: 12, color: Color(0xFF10B981)),
                      SizedBox(width: 4),
                      Text(
                        'MAIN DOOR',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF10B981),
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
    );
  }

  Widget _buildHeadlight(bool isLeft) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFFFDE047),
            borderRadius: BorderRadius.horizontal(
              left: isLeft ? const Radius.circular(8) : Radius.zero,
              right: !isLeft ? const Radius.circular(8) : Radius.zero,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFDE047).withValues(alpha: 0.6),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
