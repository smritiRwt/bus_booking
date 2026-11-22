import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/seat.dart';

class SeatWidget extends StatefulWidget {
  final SeatEntity seat;
  final bool isSelected;
  final VoidCallback onTap;

  const SeatWidget({
    super.key,
    required this.seat,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SeatWidget> createState() => _SeatWidgetState();
}

class _SeatWidgetState extends State<SeatWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.seat.isBooked) return;
    _animController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.seat.isBooked) return;
    _animController.reverse();
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  void _handleTapCancel() {
    if (widget.seat.isBooked) return;
    _animController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.seat.isBooked ? widget.onTap : null, // Show alert if tapped while booked
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.seat.isSleeper ? _buildSleeperBerth() : _buildSeaterChair(),
      ),
    );
  }

  Widget _buildSleeperBerth() {
    Color bgColor;
    Color borderColor;
    double borderWidth;
    Color textColor;
    List<BoxShadow>? shadows;

    if (widget.seat.isBooked) {
      bgColor = const Color(0xFFFEE2E2);
      borderColor = const Color(0xFFFCA5A5);
      borderWidth = 1.4;
      textColor = const Color(0xFFDC2626);
      shadows = null;
    } else if (widget.isSelected) {
      bgColor = AppColors.secondary;
      borderColor = const Color(0xFF023E8A);
      borderWidth = 2.6;
      textColor = Colors.white;
      shadows = [
        BoxShadow(
          color: AppColors.secondary.withValues(alpha: 0.45),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];
    } else {
      bgColor = Colors.white;
      borderColor = const Color(0xFF94A3B8);
      borderWidth = 1.6;
      textColor = AppColors.textPrimary;
      shadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      height: 68,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: shadows,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Pillow indicator at top of berth
          Container(
            width: 28,
            height: 5,
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? Colors.white.withValues(alpha: 0.85)
                  : (widget.seat.isBooked ? const Color(0xFFFCA5A5) : const Color(0xFFCBD5E1)),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          // Center info: Seat number + checkmark
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.seat.isBooked) ...[
                const Icon(Icons.lock_rounded, size: 12, color: Color(0xFFDC2626)),
                const SizedBox(width: 3),
                Text(
                  widget.seat.seatNumber,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ] else if (widget.isSelected) ...[
                const Icon(Icons.check_circle_rounded, size: 13, color: Colors.white),
                const SizedBox(width: 3),
                Text(
                  widget.seat.seatNumber,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ] else ...[
                Text(
                  widget.seat.seatNumber,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ],
          ),
          // Price / Booked label
          Text(
            widget.seat.isBooked ? 'Booked' : CurrencyFormatter.format(widget.seat.price),
            style: TextStyle(
              fontSize: 9,
              fontWeight: widget.isSelected ? FontWeight.w800 : FontWeight.w600,
              color: widget.isSelected
                  ? Colors.white
                  : (widget.seat.isBooked ? const Color(0xFFDC2626) : AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeaterChair() {
    Color bgColor;
    Color borderColor;
    double borderWidth;
    Color textColor;
    List<BoxShadow>? shadows;

    if (widget.seat.isBooked) {
      bgColor = const Color(0xFFFEE2E2);
      borderColor = const Color(0xFFFCA5A5);
      borderWidth = 1.4;
      textColor = const Color(0xFFDC2626);
      shadows = null;
    } else if (widget.isSelected) {
      bgColor = AppColors.secondary;
      borderColor = const Color(0xFF023E8A);
      borderWidth = 2.6;
      textColor = Colors.white;
      shadows = [
        BoxShadow(
          color: AppColors.secondary.withValues(alpha: 0.45),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];
    } else {
      bgColor = Colors.white;
      borderColor = const Color(0xFF94A3B8);
      borderWidth = 1.6;
      textColor = AppColors.textPrimary;
      shadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      height: 56,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: shadows,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.seat.isBooked) ...[
                const Icon(Icons.lock_rounded, size: 12, color: Color(0xFFDC2626)),
                const SizedBox(width: 3),
                Text(
                  widget.seat.seatNumber,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ] else if (widget.isSelected) ...[
                const Icon(Icons.check_circle_rounded, size: 13, color: Colors.white),
                const SizedBox(width: 3),
                Text(
                  widget.seat.seatNumber,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ] else ...[
                Text(
                  widget.seat.seatNumber,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ],
          ),
          Text(
            widget.seat.isBooked ? 'Booked' : CurrencyFormatter.format(widget.seat.price),
            style: TextStyle(
              fontSize: 9,
              fontWeight: widget.isSelected ? FontWeight.w800 : FontWeight.w600,
              color: widget.isSelected
                  ? Colors.white
                  : (widget.seat.isBooked ? const Color(0xFFDC2626) : AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
