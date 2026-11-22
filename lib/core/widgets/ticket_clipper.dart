import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
  final double punchRadius;
  final double punchPositionFraction; // Vertical position ratio (e.g. 0.68)

  TicketClipper({
    this.punchRadius = 12.0,
    this.punchPositionFraction = 0.70,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    const cornerRadius = 16.0;
    final punchY = size.height * punchPositionFraction;

    // Top-left corner
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Top edge to top-right
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Right edge down to punch
    path.lineTo(size.width, punchY - punchRadius);
    // Right notch
    path.arcToPoint(
      Offset(size.width, punchY + punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    // Right edge to bottom-right
    path.lineTo(size.width, size.height - cornerRadius);
    path.quadraticBezierTo(size.width, size.height, size.width - cornerRadius, size.height);

    // Bottom edge to bottom-left
    path.lineTo(cornerRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

    // Left edge up to punch
    path.lineTo(0, punchY + punchRadius);
    // Left notch
    path.arcToPoint(
      Offset(0, punchY - punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedLinePainter({
    this.color = const Color(0xFFCBD5E1),
    this.strokeWidth = 1.2,
    this.dashWidth = 5.0,
    this.dashSpace = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
