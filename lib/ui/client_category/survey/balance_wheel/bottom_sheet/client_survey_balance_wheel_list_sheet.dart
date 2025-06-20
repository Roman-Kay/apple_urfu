import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/data/repository/balance_wheel.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';

class ClientSurveyBalanceWheelListSheet extends StatefulWidget {
  const ClientSurveyBalanceWheelListSheet({super.key});

  @override
  State<ClientSurveyBalanceWheelListSheet> createState() => _ClientSurveyBalanceWheelListSheetState();
}

class _ClientSurveyBalanceWheelListSheetState extends State<ClientSurveyBalanceWheelListSheet> {
  String selectedTitle = "";
  BalanceWheelClass balanceWheel = BalanceWheelClass();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: balanceWheel.categoryList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final value = balanceWheel.categoryList[index];

                    return FormForButton(
                      borderRadius: BorderRadius.zero,
                      onPressed: (){
                        setState(() {
                          selectedTitle = value.title;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(value.image),
                            SizedBox(width: 7.w),
                            Text(
                              value.title.toUpperCase(),
                              style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: value.color
                              ),
                            ),
                            Spacer(),
                            if (selectedTitle == value.title)
                              CircleAvatar(
                                radius: 10.r,
                                backgroundColor: AppColors.vivaMagentaColor,
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/checkmark.svg',
                                    color: AppColors.basicwhiteColor,
                                    height: 14.h,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: WidgetButton(
                    onTap: () async{
                      if(selectedTitle.isNotEmpty){
                        context.router.maybePop(selectedTitle);
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text(
                              'Выберите значения',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    boxShadow: true,
                    color: AppColors.darkGreenColor,
                    child: Text(
                      'выбрать'.toUpperCase(),
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
      ),
    );
  }
}
