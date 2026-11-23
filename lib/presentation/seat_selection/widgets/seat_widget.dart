import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/bouncing_widget.dart';
import '../../../domain/entities/seat.dart';

class SeatWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (seat.isSleeper) {
      return _buildSleeperBerth();
    }
    return _buildSeaterChair();
  }

  Widget _buildSleeperBerth() {
    Color bgColor;
    Color borderColor;
    double borderWidth;
    Color textColor;
    List<BoxShadow>? shadows;

    if (seat.isBooked) {
      bgColor = const Color(0xFFFEE2E2); // Light pastel rose
      borderColor = const Color(0xFFFCA5A5);
      borderWidth = 1.2;
      textColor = const Color(0xFFDC2626);
      shadows = null;
    } else if (isSelected) {
      bgColor = AppColors.seatSelected;
      borderColor = AppColors.seatSelectedBorder;
      borderWidth = 2.4;
      textColor = Colors.white;
      shadows = [
        BoxShadow(
          color: AppColors.seatSelected.withValues(alpha: 0.35),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ];
    } else {
      bgColor = Colors.white;
      borderColor = AppColors.seatAvailableBorder;
      borderWidth = 1.4;
      textColor = AppColors.textPrimary;
      shadows = [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.03),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];
    }

    return BouncingWidget(
      onTap: seat.isBooked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
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
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : (seat.isBooked
                          ? const Color(0xFFFCA5A5)
                          : const Color(0xFFCBD5E1)),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            // Center info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (seat.isBooked) ...[
                  const Icon(
                    Icons.lock_rounded,
                    size: 12,
                    color: Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    seat.seatNumber,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ] else if (isSelected) ...[
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    seat.seatNumber,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                ] else ...[
                  Text(
                    seat.seatNumber,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ],
            ),
            // Bottom price indicator
            Text(
              CurrencyFormatter.format(seat.price),
              style: TextStyle(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (seat.isBooked
                          ? const Color(0xFFDC2626)
                          : AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeaterChair() {
    Color bgColor;
    Color borderColor;
    double borderWidth;
    Color textColor;
    List<BoxShadow>? shadows;

    if (seat.isBooked) {
      bgColor = const Color(0xFFFEE2E2); // Light pastel rose
      borderColor = const Color(0xFFFCA5A5);
      borderWidth = 1.2;
      textColor = const Color(0xFFDC2626);
      shadows = null;
    } else if (isSelected) {
      bgColor = AppColors.seatSelected;
      borderColor = AppColors.seatSelectedBorder;
      borderWidth = 2.4;
      textColor = Colors.white;
      shadows = [
        BoxShadow(
          color: AppColors.seatSelected.withValues(alpha: 0.35),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ];
    } else {
      bgColor = Colors.white;
      borderColor = AppColors.seatAvailableBorder;
      borderWidth = 1.4;
      textColor = AppColors.textPrimary;
      shadows = [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.03),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];
    }

    return BouncingWidget(
      onTap: seat.isBooked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: 52,
        height: 54,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: shadows,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Headrest indicator
            Container(
              width: 22,
              height: 4,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : (seat.isBooked
                          ? const Color(0xFFFCA5A5)
                          : const Color(0xFFCBD5E1)),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Center info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (seat.isBooked) ...[
                  const Icon(
                    Icons.lock_rounded,
                    size: 12,
                    color: Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    seat.seatNumber,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ] else if (isSelected) ...[
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    seat.seatNumber,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                ] else ...[
                  Text(
                    seat.seatNumber,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ],
            ),
            // Bottom price indicator
            Text(
              CurrencyFormatter.format(seat.price),
              style: TextStyle(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (seat.isBooked
                          ? const Color(0xFFDC2626)
                          : AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
