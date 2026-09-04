import 'package:flutter/material.dart';

class BarbellLoader extends StatefulWidget {
  @override
  _BarbellLoaderState createState() => _BarbellLoaderState();
}

class _BarbellLoaderState extends State<BarbellLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(100, 40),
          painter: _BarbellPainter(_controller.value),
        );
      },
    );
  }
}

class _BarbellPainter extends CustomPainter {
  final double progress;

  _BarbellPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..color = const Color(0xFF555555)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final platePaint = Paint()
      ..color = const Color(0xFFCCFF00) // Lime
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw barbell (center flexes slightly based on progress)
    final path = Path();
    double flex = (progress < 0.5 ? progress : 1 - progress) * 4;
    path.moveTo(10, size.height / 2);
    path.quadraticBezierTo(size.width / 2, size.height / 2 + flex, size.width - 10, size.height / 2);
    canvas.drawPath(path, barPaint);

    // Plate sliding animation
    double xPos = 20 + (progress * 60); // sliding across
    
    // Static plates
    _drawPlate(canvas, 30, size.height / 2, platePaint);
    _drawPlate(canvas, size.width - 30, size.height / 2, platePaint);
    
    // Sliding plate
    _drawPlate(canvas, xPos, size.height / 2, platePaint);
  }

  void _drawPlate(Canvas canvas, double x, double y, Paint paint) {
    canvas.drawRect(Rect.fromCenter(center: Offset(x, y), width: 6, height: 24), paint);
  }

  @override
  bool shouldRepaint(covariant _BarbellPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
