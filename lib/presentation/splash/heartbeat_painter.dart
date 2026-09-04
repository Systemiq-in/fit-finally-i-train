import 'package:flutter/material.dart';

class HeartbeatLoader extends StatefulWidget {
  @override
  _HeartbeatLoaderState createState() => _HeartbeatLoaderState();
}

class _HeartbeatLoaderState extends State<HeartbeatLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
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
          size: const Size(200, 20),
          painter: _HeartbeatPainter(_controller.value),
        );
      },
    );
  }
}

class _HeartbeatPainter extends CustomPainter {
  final double progress;

  _HeartbeatPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF) // Electric Cyan
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height / 2);

    if (progress < 0.4) {
      // Draw heartbeat
      double waveEnd = size.width * (progress / 0.4);
      path.lineTo(waveEnd * 0.4, size.height / 2);
      path.lineTo(waveEnd * 0.45, size.height / 2 - 8);
      path.lineTo(waveEnd * 0.55, size.height / 2 + 8);
      path.lineTo(waveEnd * 0.6, size.height / 2);
      path.lineTo(waveEnd, size.height / 2);
    } else if (progress >= 0.4 && progress < 0.5) {
      // Dumbbell frame
      path.moveTo(size.width / 2 - 20, size.height / 2);
      path.lineTo(size.width / 2 + 20, size.height / 2);
      // Left weight
      canvas.drawRect(Rect.fromCenter(center: Offset(size.width / 2 - 20, size.height / 2), width: 4, height: 12), paint);
      // Right weight
      canvas.drawRect(Rect.fromCenter(center: Offset(size.width / 2 + 20, size.height / 2), width: 4, height: 12), paint);
    } else {
      // Loading bar
      double fillWidth = size.width * ((progress - 0.5) / 0.5);
      path.lineTo(fillWidth, size.height / 2);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeartbeatPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
