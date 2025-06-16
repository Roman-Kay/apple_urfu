import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/utils/colors.dart';

// ignore: must_be_immutable
class CustomMenstruationRadial extends StatelessWidget {
  final int dayOfCicleNow;
  final int daysOfCicle;
  final int startDayOfMenstruation;
  final int endDayOfMenstruation;
  final int startDayOfGood;
  final int endDayOfGood;
  final int startDayOfOvolution;
  final int endDayOfOvolution;
  final int startDayOfSafe;
  final int endDayOfSafe;

  CustomMenstruationRadial({
    Key? key,
    required this.daysOfCicle,
    required this.dayOfCicleNow,
    required this.startDayOfMenstruation,
    required this.endDayOfMenstruation,
    required this.startDayOfGood,
    required this.endDayOfGood,
    required this.startDayOfOvolution,
    required this.endDayOfOvolution,
    required this.startDayOfSafe,
    required this.endDayOfSafe,
  }) : super(key: key);

  final double circleWidth = 58;
  final double paddingCircle = (58 - 38).r / 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          width: paddingCircle * 2 + 324.r,
          height: paddingCircle * 2 + 324.r,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: EdgeInsets.all(paddingCircle),
                child: CustomPaint(
                  painter: ArcPainter(
                    dayOfCicleNow: dayOfCicleNow,
                    daysOfCicle: daysOfCicle,
                    startDayOfMenstruation: startDayOfMenstruation,
                    endDayOfMenstruation: endDayOfMenstruation,
                    startDayOfGood: startDayOfGood,
                    endDayOfGood: endDayOfGood,
                    startDayOfOvolution: startDayOfOvolution,
                    endDayOfOvolution: endDayOfOvolution,
                    startDayOfSafe: startDayOfSafe,
                    endDayOfSafe: endDayOfSafe,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(46.r + paddingCircle),
                child: SvgPicture.asset(
                  'assets/images/days_menstruation.svg',
                ),
              ),
              Orbit(
                dayOfCicleNow: dayOfCicleNow,
                lenthCicleDays: daysOfCicle,
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'до следующих\nмесячных:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Inter',
                        color: AppColors.darkGreenColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${daysOfCicle - dayOfCicleNow}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 48.sp,
                        fontFamily: 'Inter',
                        color: AppColors.darkGreenColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'дней',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Inter',
                        color: AppColors.darkGreenColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final int dayOfCicleNow;
  final int daysOfCicle;
  final int startDayOfMenstruation;
  final int endDayOfMenstruation;
  final int startDayOfGood;
  final int endDayOfGood;
  final int startDayOfOvolution;
  final int endDayOfOvolution;
  final int startDayOfSafe;
  final int endDayOfSafe;

  ArcPainter({
    required this.dayOfCicleNow,
    required this.daysOfCicle,
    required this.startDayOfMenstruation,
    required this.endDayOfMenstruation,
    required this.startDayOfGood,
    required this.endDayOfGood,
    required this.startDayOfOvolution,
    required this.endDayOfOvolution,
    required this.startDayOfSafe,
    required this.endDayOfSafe,
  });

  final double lineWidth = 38.r;
  @override
  void paint(Canvas canvas, Size size) {
    final double strokeCapRoundPadding = (2 * pi * 0.65 / daysOfCicle);

    Rect arcReact = calculateArcsRect(size);

    drawBackArc(canvas, arcReact, strokeCapRoundPadding);

    drawMenstruationDaysArc(canvas, arcReact, strokeCapRoundPadding);

    drawGoodDaysArc(canvas, arcReact, strokeCapRoundPadding);

    drawOvolutionDaysArc(canvas, arcReact, strokeCapRoundPadding);

    drawSafeDaysArc(canvas, arcReact, strokeCapRoundPadding);
  }

  void drawMenstruationDaysArc(Canvas canvas, Rect arcReact, double strokeCapRoundPadding) {
    final int days = (endDayOfMenstruation - startDayOfMenstruation + 1);
    final Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.redBEColor,
        Color(0xFFFFE0E7),
      ],
      stops: [0.1, 0.5],
    );
    final feelPaint = new Paint()..shader = gradient.createShader(arcReact);
    feelPaint.style = PaintingStyle.stroke;
    feelPaint.strokeWidth = lineWidth;
    feelPaint.strokeCap = StrokeCap.round;
    canvas.drawArc(
      arcReact,
      1.5 * pi + (2 * pi * (startDayOfMenstruation - 1) / daysOfCicle) + strokeCapRoundPadding,
      2 * pi * days / daysOfCicle - strokeCapRoundPadding * 2,
      false,
      feelPaint,
    );
  }

  void drawGoodDaysArc(Canvas canvas, Rect arcReact, double strokeCapRoundPadding) {
    final int days = (endDayOfGood - startDayOfGood + 1);
    final feelPaint = new Paint();
    feelPaint.style = PaintingStyle.stroke;
    feelPaint.strokeWidth = lineWidth;
    feelPaint.strokeCap = StrokeCap.round;
    feelPaint.color = AppColors.pinkLavenderColor;
    canvas.drawArc(
      arcReact,
      1.5 * pi + (2 * pi * (startDayOfGood - 1) / daysOfCicle) + strokeCapRoundPadding,
      2 * pi * days / daysOfCicle - strokeCapRoundPadding * 2,
      false,
      feelPaint,
    );
  }

  void drawOvolutionDaysArc(Canvas canvas, Rect arcReact, double strokeCapRoundPadding) {
    final int days = (endDayOfOvolution - startDayOfOvolution + 1);
    final feelPaint = new Paint();
    feelPaint.style = PaintingStyle.stroke;
    feelPaint.strokeWidth = lineWidth;
    feelPaint.strokeCap = StrokeCap.round;
    feelPaint.color = Color(0xFFAA589B);
    canvas.drawArc(
      arcReact,
      1.5 * pi + (2 * pi * (startDayOfOvolution - 1) / daysOfCicle) + strokeCapRoundPadding,
      2 * pi * days / daysOfCicle - strokeCapRoundPadding * 2,
      false,
      feelPaint,
    );
  }

  void drawSafeDaysArc(Canvas canvas, Rect arcReact, double strokeCapRoundPadding) {
    final int days = (endDayOfSafe - startDayOfSafe + 1);
    final Gradient gradient = AppColors.gradientTurquoise;
    final feelPaint = new Paint()..shader = gradient.createShader(arcReact);
    feelPaint.style = PaintingStyle.stroke;
    feelPaint.strokeWidth = lineWidth;
    feelPaint.strokeCap = StrokeCap.round;
    canvas.drawArc(
      arcReact,
      1.5 * pi + (2 * pi * (startDayOfSafe - 1) / daysOfCicle) + strokeCapRoundPadding,
      2 * pi * days / daysOfCicle - strokeCapRoundPadding * 2,
      false,
      feelPaint,
    );
  }

  void drawBackArc(Canvas canvas, Rect arcReact, double strokeCapRoundPadding) {
    final feelPaint = Paint();
    feelPaint.color = AppColors.grey10Color;
    feelPaint.style = PaintingStyle.stroke;
    feelPaint.strokeWidth = lineWidth;
    canvas.drawArc(
      arcReact,
      pi / 2,
      pi * 2,
      false,
      feelPaint,
    );
  }

  Rect calculateArcsRect(Size size) {
    final offset = (lineWidth / 2);
    final arcReact = Offset(offset, offset) & Size(size.width - offset * 2, size.height - offset * 2);
    return arcReact;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Orbit extends StatefulWidget {
  final int dayOfCicleNow;
  final int lenthCicleDays;
  Orbit({
    Key? key,
    required this.dayOfCicleNow,
    required this.lenthCicleDays,
  }) : super(key: key);
  @override
  _Orbit createState() => _Orbit();
}

class _Orbit extends State<Orbit> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    double prossent = (widget.dayOfCicleNow - 1) / widget.lenthCicleDays;

    controller = AnimationController(vsync: this);

    controller.repeat(min: prossent, max: prossent, period: Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    double prossent = (widget.dayOfCicleNow - 1) / widget.lenthCicleDays;

    return RotationTransition(
      turns: controller,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(58.r),
            color: AppColors.grey10Color,
            boxShadow: [
              BoxShadow(
                blurRadius: 10.r,
                color: AppColors.basicblackColor.withOpacity(0.1),
              ),
            ],
          ),
          height: 58.r,
          width: 58.r,
          child: Padding(
            padding: EdgeInsets.all((3.5).r),
            child: CircleAvatar(
              backgroundColor: AppColors.basicwhiteColor,
              child: Transform.rotate(
                angle: -2 * pi * prossent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'день',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        fontFamily: 'Inter',
                        color: AppColors.darkGreenColor,
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.dayOfCicleNow.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24.sp,
                            height: 1,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
