import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';

// ignore: must_be_immutable
class RadialPercentWidget extends StatelessWidget {
  final Widget child;
  final double percent;
  final Color endLineColor;
  final Color? end2LineColor;

  final Color linePercentColor;
  final Color lineColor;
  Color? freePaintColor;
  Color? backGroundColor;
  Color? boxShadowColor;

  RadialPercentWidget({
    Key? key,
    required this.child,
    required this.percent,
    required this.endLineColor,
    this.end2LineColor,
    required this.linePercentColor,
    required this.lineColor,
    this.freePaintColor,
    this.backGroundColor,
    this.boxShadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320.w,
      height: 320.w,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(320.w),
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: boxShadowColor ?? AppColors.blueSecondaryColor.withOpacity(0.5),
                    spreadRadius: 20,
                    blurRadius: 50,
                  ),
                ],
              ),
              // backgroundColor: AppColors.basicwhiteColor,
              child: Center(child: child),
            ),
          ),
          CustomPaint(
              painter: MyPainter(
            freePaintColor: freePaintColor ?? AppColors.basicwhiteColor,
            percent: percent,
            endLineColor: endLineColor,
            linePercentColor: linePercentColor,
            lineColor: lineColor,
            end2LineColor: end2LineColor ?? AppColors.basicwhiteColor,
          )),
          Center(
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(180.w),
                color: backGroundColor ?? AppColors.basicwhiteColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey50Color.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              // backgroundColor: AppColors.basicwhiteColor,
              child: Center(child: child),
            ),
          )
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double percent;
  final Color endLineColor;
  final Color linePercentColor;
  final Color lineColor;
  final Color freePaintColor;
  final Color end2LineColor;

  MyPainter({
    required this.percent,
    required this.endLineColor,
    required this.linePercentColor,
    required this.lineColor,
    required this.freePaintColor,
    required this.end2LineColor,
  });

  final double lineWidth = 25.w;
  @override
  void paint(Canvas canvas, Size size) {
    Rect arcReact = calculateArcsRect(size);

    Rect edgeLastReact = calculateEdge(size, 0);

    Rect edgeWhiteReact = calculateEdge(size, (5.w + 5.w));

    drawBackground(canvas, size);

    drawFreeArc(canvas, arcReact);

    drawFilledArc(canvas, arcReact);

    drawLastCircleEdge(canvas, edgeLastReact);

    drawWhiteCircleEdge(canvas, edgeWhiteReact);
  }

  void drawFilledArc(Canvas canvas, Rect arcReact) {
    final feelPaint = Paint();
    feelPaint.color = linePercentColor;
    feelPaint.style = PaintingStyle.stroke;
    feelPaint.strokeWidth = lineWidth;
    feelPaint.strokeCap = StrokeCap.round;
    canvas.drawArc(arcReact, pi / 2, pi * 2 * (percent == 0 ? 0.001 : percent), false, feelPaint);
  }

  void drawFreeArc(Canvas canvas, Rect arcReact) {
    final freePaint = Paint();
    freePaint.color = freePaintColor;
    freePaint.style = PaintingStyle.stroke;
    freePaint.strokeWidth = lineWidth;
    canvas.drawArc(
      arcReact,
      pi * 2 * percent + (pi / 2),
      pi * 2 * (1.0 - percent),
      false,
      freePaint,
    );
  }

  void drawBackground(Canvas canvas, Size size) {
    final backgroundPaint = Paint();
    backgroundPaint.color = lineColor;
    backgroundPaint.style = PaintingStyle.fill;
    canvas.drawOval(Offset.zero & size, backgroundPaint);
  }

  void drawLastCircleEdge(Canvas canvas, Rect edgeReact) {
    final feelPaint = Paint();
    feelPaint.color = endLineColor;
    feelPaint.style = PaintingStyle.stroke;
    feelPaint.strokeWidth = 5.w;
    feelPaint.strokeCap = StrokeCap.round;
    canvas.drawArc(
      edgeReact,
      pi / 2,
      pi * 2,
      false,
      feelPaint,
    );
  }

  void drawWhiteCircleEdge(Canvas canvas, Rect edgeReact) {
    final feelPaint = Paint();
    feelPaint.color = end2LineColor;
    feelPaint.style = PaintingStyle.stroke;
    feelPaint.strokeWidth = (2).w;
    feelPaint.strokeCap = StrokeCap.round;
    canvas.drawArc(
      edgeReact,
      pi / 2,
      pi * 2,
      false,
      feelPaint,
    );
  }

  Rect calculateArcsRect(Size size) {
    final linesMargin = 28.w;
    final offset = lineWidth / 2 + linesMargin;
    final arcReact = Offset(offset, offset) & Size(size.width - offset * 2, size.height - offset * 2);
    return arcReact;
  }

  Rect calculateEdge(Size size, double margin) {
    final offset = 0.0 + margin;
    final arcReact = Offset(offset, offset) & Size(size.width - offset * 2, size.height - offset * 2);
    return arcReact;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
