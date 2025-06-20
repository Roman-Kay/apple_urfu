import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';

class ClientSurveyBalanceWheelInfoSheet extends StatefulWidget {
  const ClientSurveyBalanceWheelInfoSheet({super.key});

  @override
  State<ClientSurveyBalanceWheelInfoSheet> createState() => _ClientSurveyBalanceWheelInfoSheetState();
}

class _ClientSurveyBalanceWheelInfoSheetState extends State<ClientSurveyBalanceWheelInfoSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.basicwhiteColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.limeColor,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    "Колесо баланса - это инструмент, который помогает оценить, насколько вас устраивает положение дел в разных сферах жизни. Вы можете выбирать на чем концентрироваться в данный момент",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Зачем мне оценивать свои сферы жизни?",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      color: AppColors.vivaMagentaColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Что бы получить 3 стратегических преимущества перед собой вчерашним:\n\n1. Ты примерно представил, что же такое 10 из 10 именно для тебя.\n2. Ты понял, что есть куда развиваться и расти, что улучшать прямо сейчас.\n3. Ты увидел какие сферы у тебя отстают от остальных и требую твоего фокуса и внимания",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      color: AppColors.darkGreenColor,
                    ),
                  ),

                  SizedBox(height: 30.h),
                  WidgetButton(
                    onTap: () => context.router.maybePop(),
                    boxShadow: true,
                    color: AppColors.darkGreenColor,
                    child: Text(
                      'понятно'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                        color: AppColors.basicwhiteColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
