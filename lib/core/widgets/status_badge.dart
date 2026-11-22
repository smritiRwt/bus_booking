import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize = 11.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData? icon;

    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        bgColor = AppColors.successLight;
        textColor = AppColors.success;
        icon = Icons.check_circle_rounded;
        break;
      case 'COMPLETED':
        bgColor = AppColors.infoLight;
        textColor = AppColors.info;
        icon = Icons.task_alt_rounded;
        break;
      case 'CANCELLED':
        bgColor = AppColors.errorLight;
        textColor = AppColors.error;
        icon = Icons.cancel_rounded;
        break;
      case 'AC SLEEPER':
      case 'AC SEATER':
        bgColor = const Color(0xFFE0F2FE);
        textColor = const Color(0xFF0284C7);
        icon = Icons.ac_unit_rounded;
        break;
      case 'NON-AC SLEEPER':
      case 'NON-AC SEATER':
        bgColor = const Color(0xFFF1F5F9);
        textColor = const Color(0xFF475569);
        icon = Icons.directions_bus_rounded;
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        icon = null;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
