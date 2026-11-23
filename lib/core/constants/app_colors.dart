import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette - Clean Modern Royal Blue & Indigo
  static const Color primary = Color(0xFF1E3A8A); // Rich Royal Navy
  static const Color primaryLight = Color(0xFF2563EB); // Electric Royal Blue
  static const Color primaryDark = Color(0xFF172554); // Deep Navy

  // Secondary Palette - Vibrant Sky Blue & Azure
  static const Color secondary = Color(0xFF0284C7); // Vibrant Sky Blue
  static const Color secondaryLight = Color(0xFF38BDF8); // Light Sky
  static const Color secondaryDark = Color(0xFF0369A1); // Deep Sky

  // Accent - Sunset Orange & Amber
  static const Color accent = Color(0xFFFF6B35);
  static const Color accentLight = Color(0xFFFF8C5A);
  static const Color accentDark = Color(0xFFE0531E);

  // Neutral Background & Surface - Clean Light Mode
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color cardColor = Color(0xFFFFFFFF); // Pure White

  // Text Colors - High Contrast Modern Slate
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textTertiary = Color(0xFF94A3B8); // Slate 400
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status & Feedback Colors - Pastel Light & Crisp Accents
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Seat Status Colors - Light Modern Palette
  static const Color seatAvailable = Color(0xFFFFFFFF);
  static const Color seatAvailableBorder = Color(0xFFCBD5E1);
  static const Color seatSelected = Color(0xFF2563EB);
  static const Color seatSelectedBorder = Color(0xFF1D4ED8);
  static const Color seatBooked = Color(0xFFFEE2E2);
  static const Color seatBookedBorder = Color(0xFFFCA5A5);
  static const Color seatBookedLight = Color(0xFFFCA5A5);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color divider = Color(0xFFE2E8F0);

  // Gradients - Vibrant, Light & Daylight
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF0284C7)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8C5A), Color(0xFFFF6B35)],
  );

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF0284C7)],
  );

  static const LinearGradient daylightSkyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFBAE6FD), Color(0xFFE0F2FE)],
  );

  static const LinearGradient goldenPromoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
  );
}
