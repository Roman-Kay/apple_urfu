import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';

class ClientFoodDiaryCompositionOfProductsSheet extends StatelessWidget {
  final List listOfProducts;

  const ClientFoodDiaryCompositionOfProductsSheet({
    super.key,
    required this.listOfProducts,
  });

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 16.w,
                runSpacing: 8.h,
                children: [
                  for (var product in listOfProducts)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.r),
                        ),
                        border: Border.all(
                          color: AppColors.seaColor,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                        child: Text(
                          product,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkGreenColor,
                          ),
                        ),
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
