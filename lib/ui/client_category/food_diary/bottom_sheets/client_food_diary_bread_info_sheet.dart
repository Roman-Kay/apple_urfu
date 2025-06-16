import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';

class ClientFoodDiaryBreadInfoSheet extends StatefulWidget {
  const ClientFoodDiaryBreadInfoSheet({super.key});

  @override
  State<ClientFoodDiaryBreadInfoSheet> createState() => _ClientFoodDiaryBreadInfoSheetState();
}


class _ClientFoodDiaryBreadInfoSheetState extends State<ClientFoodDiaryBreadInfoSheet> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.limeColor,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Column(
                children: [
                  Text(
                    'Хлебная единица (ХЕ) — это унифицированная мера  исчисления, созданная для удобства подсчета количества углеводов в  продуктах питания. За эталон хлебной единицы принято количество  углеводов в куске хлеба толщиной 1 см (весом 20-25 грамм), вне  зависимости от муки, из которой он приготовлен.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Считается, что одна ХЕ содержит от 10 до 12 граммов углеводов.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Особенно такие расчеты необходимы для больных сахарным диабетом, ведь им  крайне необходимо контролировать свое питание, обращать внимание на  коррекцию и нормализацию уровня глюкозы в крови. При проблемах с сахаром  питание должно быть сбалансированным, регулярным, дробным и  полноценным.',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              WidgetButton(
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
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }
}
