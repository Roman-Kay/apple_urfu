import 'dart:math';
import 'package:flutter/material.dart';

class CustomRadialLitePersentWidget extends StatelessWidget {
  final double percent;
  final Color linePercentColor;
  final Color lineColor;
  final double size;
  final Widget child;
  final double lineWidth;

  const CustomRadialLitePersentWidget({
    super.key,
    required this.percent,
    required this.lineColor,
    required this.linePercentColor,
    required this.size,
    required this.child,
    this.lineWidth = 9,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: MyPainter(
              percent: percent,
              linePercentColor: linePercentColor,
              lineColor: lineColor,
              lineWidth: lineWidth,
            ),
          ),
          child
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double percent;
  final Color linePercentColor;
  final Color lineColor;
  final double lineWidth;

  MyPainter({
    required this.percent,
    required this.linePercentColor,
    required this.lineColor,
    required this.lineWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Rect arcReact = calculateArcsRect(size);
    drawFreeArc(canvas, arcReact);
    drawFilledArc(canvas, arcReact);
  }

  void drawFilledArc(Canvas canvas, Rect arcReact) {
    final feelPaint = Paint();
    feelPaint.color = linePercentColor;
    feelPaint.style = PaintingStyle.stroke;
    feelPaint.strokeWidth = lineWidth;
    feelPaint.strokeCap = StrokeCap.round;
    canvas.drawArc(
      arcReact,
      -pi / 2,
      pi * 2 * (percent == 0 ? 0.00 : percent),
      false,
      feelPaint,
    );
  }

  void drawFreeArc(Canvas canvas, Rect arcReact) {
    final freePaint = Paint();
    freePaint.color = lineColor;
    freePaint.style = PaintingStyle.stroke;
    freePaint.strokeWidth = lineWidth;
    canvas.drawArc(
      arcReact,
      pi * 2 * percent + (pi / 2),
      pi * 2,
      false,
      freePaint,
    );
  }

  Rect calculateArcsRect(Size size) {
    final offset = lineWidth / 2;
    final arcReact = Offset(offset, offset) & Size(size.width - offset * 2, size.height - offset * 2);
    return arcReact;
  }

  Rect calculateEdge(Size size) {
    final offset = 0.0;
    final arcReact = Offset(offset, offset) & Size(size.width - offset * 2, size.height - offset * 2);
    return arcReact;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
