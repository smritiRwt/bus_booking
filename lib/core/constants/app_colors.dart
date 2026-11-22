import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette - Deep Navy Blue & Variations
  static const Color primary = Color(0xFF0D1B2A);
  static const Color primaryLight = Color(0xFF1B263B);
  static const Color primaryDark = Color(0xFF081018);

  // Secondary Palette - Sky Blue
  static const Color secondary = Color(0xFF0077B6);
  static const Color secondaryLight = Color(0xFF38BDF8);
  static const Color secondaryDark = Color(0xFF023E8A);

  // Accent - Vibrant Orange
  static const Color accent = Color(0xFFFF6B35);
  static const Color accentLight = Color(0xFFFF8C5A);
  static const Color accentDark = Color(0xFFE0531E);

  // Neutral Background & Surface
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status & Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Seat Status Colors
  static const Color seatAvailable = Color(0xFFE2E8F0);
  static const Color seatAvailableBorder = Color(0xFFCBD5E1);
  static const Color seatSelected = Color(0xFF0077B6);
  static const Color seatBooked = Color(0xFFEF4444);
  static const Color seatBookedLight = Color(0xFFFCA5A5);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color divider = Color(0xFFE2E8F0);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1B2A), Color(0xFF1B263B), Color(0xFF0077B6)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8C5A), Color(0xFFFF6B35)],
  );

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1B2A), Color(0xFF0077B6)],
  );
}
