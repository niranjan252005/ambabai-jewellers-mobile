import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showBackground;
  final Color? backgroundColor;

  const CustomLogo({
    super.key,
    this.size = 24,
    this.color,
    this.showBackground = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? const Color(0xFFD4AF37);
    
    Widget logo = CustomPaint(
      size: Size(size, size),
      painter: JewelryLogoPainter(color: logoColor),
    );

    if (showBackground) {
      logo = Container(
        width: size + 16,
        height: size + 16,
        decoration: BoxDecoration(
          color: backgroundColor ?? logoColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular((size + 16) / 2),
        ),
        child: Center(child: logo),
      );
    }

    return logo;
  }
}

class JewelryLogoPainter extends CustomPainter {
  final Color color;

  JewelryLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Draw diamond shape (your custom jewelry symbol)
    final path = Path();
    
    // Top point
    path.moveTo(center.dx, center.dy - radius);
    
    // Top right
    path.lineTo(center.dx + radius * 0.6, center.dy - radius * 0.3);
    
    // Bottom right
    path.lineTo(center.dx + radius * 0.4, center.dy + radius);
    
    // Bottom left
    path.lineTo(center.dx - radius * 0.4, center.dy + radius);
    
    // Top left
    path.lineTo(center.dx - radius * 0.6, center.dy - radius * 0.3);
    
    // Close path
    path.close();

    // Fill the diamond
    canvas.drawPath(path, paint);

    // Draw inner lines for facets
    final facetPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02;

    // Vertical center line
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      facetPaint,
    );

    // Left facet line
    canvas.drawLine(
      Offset(center.dx - radius * 0.6, center.dy - radius * 0.3),
      Offset(center.dx, center.dy + radius * 0.2),
      facetPaint,
    );

    // Right facet line
    canvas.drawLine(
      Offset(center.dx + radius * 0.6, center.dy - radius * 0.3),
      Offset(center.dx, center.dy + radius * 0.2),
      facetPaint,
    );

    // Add a small sparkle effect
    final sparklePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Top sparkle
    canvas.drawCircle(
      Offset(center.dx - radius * 0.2, center.dy - radius * 0.5),
      size.width * 0.03,
      sparklePaint,
    );

    // Side sparkle
    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.1),
      size.width * 0.02,
      sparklePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Alternative text-based logo for simple usage - SAJ Logo
class TextLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;

  const TextLogo({
    super.key,
    this.fontSize = 24,
    this.color,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'SAJ', // श्री अंबाबाई ज्वेलर्स
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? const Color(0xFFD4AF37),
        fontWeight: fontWeight,
        fontFamily: 'serif',
        letterSpacing: 1.2,
      ),
    );
  }
}

// Brand name widget - Ambabai Jewellers
class BrandName extends StatelessWidget {
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;

  const BrandName({
    super.key,
    this.fontSize = 20,
    this.color,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Ambabai Jewellers', // श्री अंबाबाई ज्वेलर्स
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? const Color(0xFF2C2C2C),
        fontWeight: fontWeight,
        letterSpacing: 0.5,
      ),
    );
  }
}