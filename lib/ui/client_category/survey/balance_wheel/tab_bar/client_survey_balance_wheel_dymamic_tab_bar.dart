
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/survey/balance_wheel/balance_wheel_bloc.dart';
import 'package:garnetbook/data/models/survey/balance_wheel/balance_wheel.dart';
import 'package:garnetbook/data/repository/balance_wheel.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/calendar/calendar_row.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/graphics/custom_balance_wheel_graphic.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';

class ClientSurveyBalanceWheelDymamicTabBar extends StatefulWidget {
  const ClientSurveyBalanceWheelDymamicTabBar({super.key, required this.selectedDate, required this.isInit});

  final SelectedDate selectedDate;
  final SelectedBool isInit;

  @override
  State<ClientSurveyBalanceWheelDymamicTabBar> createState() => _ClientSurveyBalanceWheelDymamicTabBarState();
}

class _ClientSurveyBalanceWheelDymamicTabBarState extends State<ClientSurveyBalanceWheelDymamicTabBar> with AutomaticKeepAliveClientMixin{
  List<CategoryItem> list = [];
  BalanceWheelClass balanceWheel = BalanceWheelClass();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<BalanceWheelBloc, BalanceWheelState>(builder: (context, state) {
      if (state is BalanceWheelLoadedState) {
        getList(state.view);

        return RefreshIndicator(
          color: AppColors.darkGreenColor,
          onRefresh: () {
            context.read<BalanceWheelBloc>().add(BalanceWheelGetEvent(widget.selectedDate.date));
            return Future.delayed(const Duration(seconds: 1));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: ListView(
              children: [
                SizedBox(height: 24.h),
                CalendarRow(
                  selectedDate: widget.selectedDate.date,
                  onPressedDateCon: () {
                    DatePickerBdaya.showDatePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime(2023, 0, 0),
                      maxTime: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      ),
                      onConfirm: (newDate) {
                        widget.selectedDate.select(newDate);
                        context.read<BalanceWheelBloc>().add(BalanceWheelGetEvent(widget.selectedDate.date));
                      },
                      currentTime: widget.selectedDate.date,
                      locale: LocaleType.ru,
                    );
                  },
                  onPressedLeft: () {
                    widget.selectedDate.select(widget.selectedDate.date.subtract(Duration(days: 1)));
                    context.read<BalanceWheelBloc>().add(BalanceWheelGetEvent(widget.selectedDate.date));
                  },
                  onPressedRight: () {
                    if (widget.selectedDate.date.add(Duration(days: 1)).isAfter(DateTime.now())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text(
                            'Невозможно узнать будущие показатели',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      );
                    } else {
                      widget.selectedDate.select(widget.selectedDate.date.add(Duration(days: 1)));
                      context.read<BalanceWheelBloc>().add(BalanceWheelGetEvent(widget.selectedDate.date));
                    }
                  },
                ),

                if (list.any((val) => val.value != 0))
                  Column(
                    children: [
                      SizedBox(height: 12.h),
                      CustomBalanceWheelGraphic(list: list),
                      SizedBox(height: 16.h),
                      ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: list.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final value = list[index];

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
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
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    color: value.color,
                                  ),
                                  child: Center(
                                    child: Text(
                                      value.value.toString(),
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.basicwhiteColor
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  )
                else
                  SizedBox(
                    height: 450.h,
                    child: Center(
                      child: Text(
                        "Данные отсутствуют",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.h,
                          fontFamily: 'Inter',
                          color: AppColors.darkGreenColor,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      }
      else if (state is BalanceWheelErrorState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.8,
          child: Center(
            child: ErrorWithReload(
              callback: () {
                context.read<BalanceWheelBloc>().add(BalanceWheelGetEvent(widget.selectedDate.date));
              },
            ),
          ),
        );
      }
      else if(state is BalanceWheelLoadingState){
        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.8,
          child: Center(
            child: ProgressIndicatorWidget(),
          ),
        );
      }
      return Container();
    });
  }


  getList(Map<String, List<BalanceWheel>>? view){
    list = [
      CategoryItem(title: "карьера", image: "assets/images/balance_wheel/carier.svg", color: Color(0xFFBE3455), value: 0),
      CategoryItem(title: "здоровье", image: "assets/images/balance_wheel/health.svg", color: Color(0xFF00817D), value: 0),
      CategoryItem(title: "друзья", image: "assets/images/balance_wheel/friends.svg", color: Color(0xFFFF9F00), value: 0),
      CategoryItem(title: "семья", image: "assets/images/balance_wheel/family.svg", color: Color(0xFF15ABEE), value: 0),
      CategoryItem(title: "отдых", image: "assets/images/balance_wheel/rest.svg", color: Color(0xFF688602), value: 0),
      CategoryItem(title: "саморазвитие", image: "assets/images/balance_wheel/education.svg", color: Color(0xFF5AA8A5), value: 0),
      CategoryItem(title: "деньги", image: "assets/images/balance_wheel/money.svg", color: Color(0xFFAA589B), value: 0),
      CategoryItem(title: "хобби", image: "assets/images/balance_wheel/hobbie.svg", color: Color(0xFFC5763B), value: 0),
    ];

    Map<String, List<BalanceWheel>> newMap = {};


    if(view != null && view.isNotEmpty){
      view.forEach((key, val){
        if(val.isNotEmpty){
          val.forEach((element){
            if(element.categoryName != null && element.grade != null && element.create != null){
              newMap.update(key, (value) => value..add(element), ifAbsent: () => [element]);
            }
          });
        }
      });
    }

    if(newMap.isNotEmpty){
      newMap.forEach((key, val){
        val.sort((a, b){
          DateTime aDate = DateTime.parse(a.create!);
          DateTime bDate = DateTime.parse(b.create!);
          return bDate.compareTo(aDate);
        });
      });

      newMap.forEach((key, val){
        list.forEach((element){
          if(element.title.toLowerCase() == key.toLowerCase()){
            element.value = val.first.grade ?? 0;
          }
        });
      });
    }
  }
}
