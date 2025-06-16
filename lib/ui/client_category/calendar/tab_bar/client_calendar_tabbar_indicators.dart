import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/calendar/calendar_for_day/calendar_for_day_bloc.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/percents/prosent_bar_second.dart';


class ClientCalendarTabBarIndicators extends StatelessWidget {
  final DateTime chosenDate;

  const ClientCalendarTabBarIndicators({
    super.key,
    required this.chosenDate
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarForDayBloc, CalendarForDayState>(
        builder: (context, state) {
          if (state is CalendarForDayLoadedState) {
            if(state.view != null){

              return Container(
                color: AppColors.basicwhiteColor,
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32.h),
                    if (state.view?.water != null)
                      itemIndicator(
                        text: 'Количество выпитой воды',
                        color: AppColors.blueSecondaryColor,
                        nowItem: state.view?.water?.dayVal ?? 0,
                        targetItem: state.view?.water?.dayTarget ?? 2000,
                        name: 'литра',
                        type: '',
                      ),
                    if (state.view?.sensorsStep != null)
                      itemIndicator(
                        text: 'Пройденные шаги',
                        color: AppColors.grey60Color,
                        nowItem: state.view?.sensorsStep?.currentVal ?? 0,
                        targetItem: state.view?.sensorsStep?.targetVal ?? 10000,
                        name: 'шагов',
                        type: '',
                      ),
                    if (state.view?.food != null)
                      itemIndicator(
                        text: 'Потребленные каллории',
                        color: AppColors.greenColor,
                        nowItem: state.view?.food?.dayCalories?.toDouble() ?? 0,
                        targetItem: state.view?.food?.normCalories ?? 2000,
                        name: 'ккал',
                        type: '',
                      ),
                  ],
                ),
              );
            }
            else {
              return Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, top: 22.h),
                  child: Text(
                    'Данные отсутствуют',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                ),
              );
            }
          }
          return Container();
        }
    );
  }

  Widget itemIndicator({
    required String text,
    required Color color,
    required num nowItem,
    required targetItem,
    required String name,
    required String type,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 53.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            height: 1,
            color: color,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 32.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      nowItem.toInt().toString(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: color,
                      ),
                    ),
                    type == '' ? const SizedBox() : SizedBox(width: 2.w),
                    Text(
                      '$type',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: AppColors.blueSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              PercentSecondBar(
                width: 248,
                percent: getLessPercent(targetItem, nowItem.toInt()),
                widthPercentLine: 40,
                backgroundColor: AppColors.grey10Color,
                percentLineColor: color,
              ),
              SizedBox(
                height: 32.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      targetItem.toString(),
                      style: TextStyle(
                        fontSize: type == '' ? 14.sp : 16.sp,
                        fontFamily: 'Inter',
                        fontWeight:
                            type == '' ? FontWeight.w400 : FontWeight.w600,
                        color: color,
                      ),
                    ),
                    type == '' ? const SizedBox() : SizedBox(width: 2.w),
                    Text(
                      '$type',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Осталось до цели:',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                getTargetLess(targetItem, nowItem.toInt()),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  int getLessPercent(int targetVal, int currentVal) {
    if (currentVal > targetVal) {
      return 100;
    } else {
      return (currentVal / targetVal * 100).toInt();
    }
  }

  String getTargetLess(int targetVal, int currentVal) {
    if (currentVal > targetVal) {
      return "0";
    } else {
      return "${targetVal - currentVal}";
    }
  }
}
