import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';

class ProblemItem {
  final Color color;
  final String text;
  final String title;

  ProblemItem({
    required this.color,
    required this.text,
    required this.title,
  });
}

class ClientSensorsPressureTypeProblemSheet extends StatefulWidget {
  ClientSensorsPressureTypeProblemSheet({super.key});

  @override
  State<ClientSensorsPressureTypeProblemSheet> createState() => _ClientSensorsPressureTypeProblemSheetState();
}

class _ClientSensorsPressureTypeProblemSheetState extends State<ClientSensorsPressureTypeProblemSheet> {
  List<ProblemItem> listofProblemItems = [
    ProblemItem(
      color: AppColors.blueSecondaryColor,
      text: 'Оптимальное',
      title: 'СИС < 120 или ДИА < 80',
    ),
    ProblemItem(
      color: AppColors.greenLightColor,
      text: 'Нормальное',
      title: 'СИС < 130 и ДИА < 85',
    ),
    ProblemItem(
      color: AppColors.orangeColor,
      text: 'Высокое нормальное',
      title: 'СИС 130-139 и ДИА 85-89',
    ),
    ProblemItem(
      color: AppColors.tints3Color,
      text: 'I степень (мягкая АГ)',
      title: 'СИС 140-159 или ДИА 90-99',
    ),
    ProblemItem(
      color: Color(0xFFCD5B6F),
      text: 'II степень (умеренная АГ)',
      title: 'СИС 160-179 или ДИА 100-109',
    ),
    ProblemItem(
      color: AppColors.redColor,
      text: 'III степень (тяжелая АГ)',
      title: 'СИС >= 180 или ДИА >= 110',
    ),
    ProblemItem(
      color: AppColors.grey50Color,
      text: 'Изолированная\nсистолическая гипертезия',
      title: 'СИС >= 140 или ДИА < 90',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.limeColor,
        ),
        SafeArea(
          child: Column(
            children: [
              ListView.builder(
                itemCount: listofProblemItems.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  ProblemItem problemItem = listofProblemItems[index];
                  return ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 64.h),
                    child: Row(
                      children: [
                        SizedBox(width: 14.w),
                        CircleAvatar(
                          radius: 8.r,
                          backgroundColor: problemItem.color,
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              problemItem.text,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                fontFamily: 'Inter',
                                color: AppColors.darkGreenColor,
                              ),
                            ),
                            Text(
                              problemItem.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                color: AppColors.grey50Color,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          'assets/images/arrow_black.svg',
                          color: AppColors.grey50Color,
                          width: 24.w,
                          height: 24.h,
                        ),
                        SizedBox(width: 14.w),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: WidgetButton(
                  onTap: () => context.router.maybePop(),
                  boxShadow: true,
                  color: AppColors.darkGreenColor,
                  child: Text(
                    'закрыть'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: AppColors.basicwhiteColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }
}
