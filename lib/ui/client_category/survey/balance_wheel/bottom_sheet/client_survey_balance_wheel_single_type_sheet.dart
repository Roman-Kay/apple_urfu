
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/data/models/survey/balance_wheel/balance_wheel.dart';
import 'package:garnetbook/data/repository/balance_wheel.dart';
import 'package:garnetbook/domain/services/survey/balance_wheel.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ClientSurveyBalanceWheelSingleTypeSheet extends StatefulWidget {
  const ClientSurveyBalanceWheelSingleTypeSheet({super.key, required this.categoryType, required this.date});
  final String categoryType;
  final DateTime date;

  @override
  State<ClientSurveyBalanceWheelSingleTypeSheet> createState() => _ClientSurveyBalanceWheelSingleTypeSheetState();
}

class _ClientSurveyBalanceWheelSingleTypeSheetState extends State<ClientSurveyBalanceWheelSingleTypeSheet> {
  BalanceWheelClass balanceWheel = BalanceWheelClass();
  CategoryItem? item;
  int? selectedGrade;

  Map<int, String> list = {
    1 : "абсолютно не удовлетворен",
    2 : "не удовлетворен",
    3 : "плохо",
    4 : "плохо, есть куда стремиться",
    5 : "пойдёт",
    6 : "нормально",
    7 : "в целом, не плохо",
    8 : "хорошо",
    9 : "прекрасно",
    10 : "идеально!",
  };

  @override
  void initState() {
    check();
    super.initState();
  }

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
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: item?.color ?? AppColors.vivaMagentaColor,
                      borderRadius: BorderRadius.circular(32.r)
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 14.w),
                        item?.image != null ? SvgPicture.asset(item!.image) : Container(),
                        SizedBox(width: 25.w),
                        Text(
                          widget.categoryType.toUpperCase(),
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: AppColors.basicwhiteColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  for(var key in list.keys.toList())
                    rowContainer(key),

                  SizedBox(height: 30.h),
                  WidgetButton(
                    onTap: () async{
                      if(selectedGrade != null){
                        context.loaderOverlay.show();

                        final service = BalanceWheelService();

                        final response = await service.addBalanceWheel(BalanceWheelsCreateRequest(
                          categoryName: widget.categoryType,
                          create: DateFormat("yyyy-MM-dd").format(widget.date),
                          grade: selectedGrade
                        ));

                        if(response.result){
                          context.loaderOverlay.hide();
                          context.router.maybePop(true);
                        }
                        else{
                          context.loaderOverlay.hide();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text(
                                'Произошла ошибка. Попробуйте повторить позже',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          );
                        }
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
                      'сохранить'.toUpperCase(),
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

  check(){
    for(var element in balanceWheel.categoryList){
      if(element.title.toLowerCase() == widget.categoryType.toLowerCase()){
        setState(() {
          item = element;
        });
        break;
      }
    }
  }

  Widget rowContainer(int value){
    return FormForButton(
      borderRadius: BorderRadius.zero,
      onPressed: (){
        setState(() {
          selectedGrade = value;
        });
      },
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int index = 1; index < 9; index++)
                Container(
                  width: 4,
                  height: 20,
                  margin: EdgeInsets.only(right: 4.w),
                  color: index <= value && item != null ? item!.color : item != null ? item!.color.withOpacity(0.2) : Colors.transparent
                ),

              SizedBox(width: 5.w),
              Text(
                "- $value",
                style: TextStyle(
                  color: AppColors.darkGreenColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  fontFamily: "Inter"
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                list[value] ?? "",
                style: TextStyle(
                    color: AppColors.darkGreenColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    fontFamily: "Inter"
                ),
              ),
              Spacer(),
              CircleAvatar(
                radius: 10.r,
                backgroundColor: selectedGrade == value ? AppColors.vivaMagentaColor : AppColors.vivaMagentaColor.withOpacity(0.2),
                child: Center(
                  child: selectedGrade == value ? SvgPicture.asset(
                    'assets/images/checkmark.svg',
                    color: AppColors.basicwhiteColor,
                    height: 14.h,
                  ) : Container(),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          if(value != 10 )
            Container(
              height: 1,
              decoration: BoxDecoration(
                  gradient: AppColors.gradientTurquoise
              ),
            ),
        ],
      ),
    );
  }
}
