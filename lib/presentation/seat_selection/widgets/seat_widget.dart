import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
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
    Color textColor;

    if (seat.isBooked) {
      bgColor = AppColors.seatBooked.withOpacity(0.15);
      borderColor = AppColors.seatBooked.withOpacity(0.4);
      textColor = AppColors.seatBooked;
    } else if (isSelected) {
      bgColor = AppColors.seatSelected;
      borderColor = AppColors.seatSelected;
      textColor = Colors.white;
    } else {
      bgColor = AppColors.seatAvailable;
      borderColor = AppColors.seatAvailableBorder;
      textColor = AppColors.textPrimary;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 64,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Pillow indicator at top of berth
            Container(
              width: 24,
              height: 4,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.6) : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (seat.isBooked)
                  const Icon(Icons.close_rounded, size: 14, color: AppColors.seatBooked)
                else if (isSelected)
                  const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                else
                  Text(
                    seat.seatNumber,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
              ],
            ),
            Text(
              CurrencyFormatter.format(seat.price),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
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
    Color textColor;

    if (seat.isBooked) {
      bgColor = AppColors.seatBooked.withOpacity(0.15);
      borderColor = AppColors.seatBooked.withOpacity(0.4);
      textColor = AppColors.seatBooked;
    } else if (isSelected) {
      bgColor = AppColors.seatSelected;
      borderColor = AppColors.seatSelected;
      textColor = Colors.white;
    } else {
      bgColor = AppColors.seatAvailable;
      borderColor = AppColors.seatAvailableBorder;
      textColor = AppColors.textPrimary;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 52,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (seat.isBooked)
                  const Icon(Icons.close_rounded, size: 14, color: AppColors.seatBooked)
                else if (isSelected)
                  const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                else
                  Text(
                    seat.seatNumber,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
              ],
            ),
            Text(
              CurrencyFormatter.format(seat.price),
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
