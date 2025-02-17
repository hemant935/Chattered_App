import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({Key? key}) : super(key: key);

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80, // Adjust size as needed
      height: 80, // Adjust size as needed
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomPaint(
            painter: CustomIndicatorPainter(animationValue: _animationController.value),
          );
        },
      ),
    );
  }
}

class CustomIndicatorPainter extends CustomPainter {
  final double animationValue;

  CustomIndicatorPainter({required this.animationValue}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final bluePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.square;

    final darkPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.square;

    // Outer Blue Arc
    final startAngleBlueOuter = animationValue * 2 * math.pi;
    const sweepAngleBlueOuter = math.pi / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngleBlueOuter,
      sweepAngleBlueOuter,
      false,
      bluePaint,
    );

    // Inner Dark Arc - Slightly smaller and offset
    final startAngleDarkInner = startAngleBlueOuter;
    const sweepAngleDarkInner = math.pi / 2;
    final innerRadius = radius * 0.4;  // Reduce the radius to make it smaller
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      startAngleDarkInner,
      sweepAngleDarkInner,
      false,
      darkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomIndicatorPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}