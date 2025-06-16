import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:intl/intl.dart';

class CustomWeightGraphic extends StatefulWidget {
  final ClientTargetsView? view;
  final Map<DateTime, double> weightList;

  const CustomWeightGraphic({
    super.key,
    required this.weightList,
    this.view,
  });

  @override
  State<CustomWeightGraphic> createState() => _CustomBloodGlucoseGraphicState();
}

class _CustomBloodGlucoseGraphicState extends State<CustomWeightGraphic> {
  List<double> weightListValue = [];
  List<DateTime> weightListDate = [];
  bool animate = true;

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 238.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: Stack(
                children: [
                  Row(
                    children: [
                      for (var i = 0; i <= widget.weightList.length - 1; i++)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
                            child: Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradientThird,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Center(
                                      child: Text(
                                        DateFormat("dd.MM").format(weightListDate[i]),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.h,
                                          height: 1,
                                          fontFamily: 'Inter',
                                          color: AppColors.darkGreenColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 1,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFFDFF9F8),
                                          Color(0xFFD5F4E5),
                                          Color(0xFFAEE5E2),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 600),
                                  constraints: BoxConstraints(minHeight: 25.h, maxHeight: 180.h),
                                  width: 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: AppColors.darkGreenColor,
                                  ),
                                  height: animate
                                      ? (180.h * weightListValue[i]) / weightListValue.reduce(max)
                                      : 0,
                                  child: SizedBox(
                                    height: 25.h,
                                    width: double.maxFinite,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Center(
                                        child: Text(
                                          removeDecimalZeroFormat(weightListValue[i]),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.h,
                                            height: 1,
                                            fontFamily: 'Inter',
                                            color: AppColors.basicwhiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Image.asset(
              'assets/images/glucose_bottom_div.webp',
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  check(){
    widget.weightList.forEach((key, val){
      if(weightListDate.length != 7){
        weightListDate.add(key);
      }

      if(weightListValue.length != 7){
        weightListValue.add(val);
      }
    });

    weightListDate = weightListDate.reversed.toList();
    weightListValue = weightListValue.reversed.toList();

    setState(() {});
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  Color getColorColumn(ClientTargetsView? view, List<double> list, int i) {
    if (view != null && view.pointB != null) {
      if (i == 0) {
        return AppColors.greenLightColor;
      } else
      // если настоящие значение веса ближе к поставленной цели веса чем предыдушая (по модулю), то тогда зеленый цвет
      if ((list[i] - view.pointB!).abs() < (list[i - 1] - view.pointB!).abs()) {
        return AppColors.greenLightColor;
      } else
      // если настоящие значение веса равно нашей цели то зеленый цвет (для удержания веса, ну и в целом когда цель выполнена)
      if (list[i] == view.pointB!) {
        return AppColors.greenLightColor;
      } else
      // если настоящие значение веса равно прошлому весу (вес стоит на месте)
      if (list[i] == view.pointB!) {
        return AppColors.orangeColor;
      } else
      // если настоящие значение веса дальше к поставленной цели веса чем предыдушая (по модулю), то тогда красный цвет
      if ((list[i] - view.pointB!).abs() < (list[i - 1] - view.pointB!).abs()) {
        return AppColors.redColor;
      }
    }
    return AppColors.greenLightColor;
  }
}
