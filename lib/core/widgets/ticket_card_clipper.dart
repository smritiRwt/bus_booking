import 'package:flutter/material.dart';

class TicketCardClipper extends CustomClipper<Path> {
  final double punchRadius;
  final double notchPositionRatio; // 0.0 to 1.0 vertical position of the notches

  TicketCardClipper({
    this.punchRadius = 12.0,
    this.notchPositionRatio = 0.65,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final r = punchRadius;
    final notchY = size.height * notchPositionRatio;

    // Top-left
    path.moveTo(0, 0);
    // Top edge
    path.lineTo(size.width, 0);
    // Right edge down to notch
    path.lineTo(size.width, notchY - r);
    // Right notch inward
    path.arcToPoint(
      Offset(size.width, notchY + r),
      radius: Radius.circular(r),
      clockwise: false,
    );
    // Right edge to bottom
    path.lineTo(size.width, size.height);
    // Bottom edge
    path.lineTo(0, size.height);
    // Left edge up to notch
    path.lineTo(0, notchY + r);
    // Left notch inward
    path.arcToPoint(
      Offset(0, notchY - r),
      radius: Radius.circular(r),
      clockwise: false,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant TicketCardClipper oldClipper) {
    return oldClipper.punchRadius != punchRadius ||
        oldClipper.notchPositionRatio != notchPositionRatio;
  }
}

class DashedDividerPainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DashedDividerPainter({
    this.color = const Color(0xFFCBD5E1),
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant DashedDividerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
