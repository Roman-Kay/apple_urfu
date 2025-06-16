import 'dart:collection';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/health/weight/weight_bloc.dart';
import 'package:garnetbook/bloc/client/target/target_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/ui/client_category/my_day/bottom_sheets/client_my_day_tracker_slot_finish.dart';
import 'package:garnetbook/ui/client_category/sensors/weight/bottom_sheet/client_sensors_weight_add_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/calculate_imt.dart';
import 'package:garnetbook/widgets/buttons/drop_down.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/error_handler/error_handler_sensors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/graphics/custom_weight_graphic.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:intl/intl.dart';


class ClientSensorsWeightDynamic extends StatefulWidget {
  const ClientSensorsWeightDynamic({super.key, required this.isRequested, required this.selectedDate});

  final RequestedValue isRequested;
  final SelectedDate selectedDate;

  @override
  State<ClientSensorsWeightDynamic> createState() => _ClientSensorsWeightDynamicState();
}

class _ClientSensorsWeightDynamicState extends State<ClientSensorsWeightDynamic> with AutomaticKeepAliveClientMixin{
  Map<DateTime, double> weightList = {};
  Map<DateTime, double> shortedList = {};
  List<String> items = ['Неделя', '10 дней', '30 дней', '60 дней'];
  String dropDownValue = 'Неделя';
  double? idealImt;
  int dayQuantity = 7;
  int? height;
  List<int> targetWeight = [];

  bool isRequested = false;

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TargetBloc, TargetState>(builder: (context, targetState) {
      if (targetState is TargetLoadedState) {
        getTargetWeight(targetState.view);
      }

        return Stack(
          children: [
            BlocBuilder<WeightBloc, WeightState>(builder: (context, state) {
              if (state is WeightLoadedState) {
                getList(state.list);

                return ListenableBuilder(
                    listenable: widget.selectedDate,
                    builder: (context, child) {

                      return RefreshIndicator(
                        color: AppColors.darkGreenColor,
                        onRefresh: () {
                          context.read<WeightBloc>().add(WeightGetEvent(7, widget.selectedDate.date));
                          return Future.delayed(const Duration(seconds: 1));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: ListView(
                            children: [
                              SizedBox(height: 24.h),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.basicwhiteColor.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.basicblackColor.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: Offset.zero,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.basicwhiteColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8.r),
                                                border: Border.all(color: AppColors.darkGreenColor)
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                            child: Text(
                                              "${DateFormat('d MMMM', 'ru_RU').format(widget.selectedDate.date.subtract(Duration(days: dayQuantity == 7 ? 6 : dayQuantity)))} - ${DateFormat('d MMMM', 'ru_RU').format(widget.selectedDate.date)}",
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'Inter',
                                                color: AppColors.darkGreenColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 12.w),
                                          decoration: BoxDecoration(
                                            color: AppColors.basicwhiteColor.withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                                          child: DropDown(
                                            colorText: AppColors.darkGreenColor,
                                            colorBack: AppColors.basicwhiteColor,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropDownValue = newValue!;

                                                if (newValue == 'Неделя') {
                                                  dayQuantity = 7;
                                                } else if (newValue == '10 дней') {
                                                  dayQuantity = 10;
                                                } else if (newValue == '30 дней') {
                                                  dayQuantity = 30;
                                                } else if (newValue == '60 дней') {
                                                  dayQuantity = 60;
                                                }
                                              });

                                              DateTime newDate = DateUtils.dateOnly(widget.selectedDate.date);

                                              context.read<WeightBloc>().add(WeightGetEvent(dayQuantity, newDate));
                                            },
                                            dropdownvalue: dropDownValue,
                                            items: items,
                                          ),
                                        ),
                                      ],
                                    ),

                                    if (weightList.isNotEmpty)
                                      Column(
                                        children: [
                                          SizedBox(height: 16.h),
                                          CustomWeightGraphic(
                                            weightList: shortedList,
                                            view: state.targetView,
                                          ),
                                          SizedBox(height: 20.h),
                                          ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: weightList.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              final value = weightList.values.toList()[index];
                                              final date = weightList.keys.toList()[index];

                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          SizedBox(width: 4.w),
                                                          Text(
                                                            getDay(date),
                                                            style: TextStyle(
                                                              fontFamily: 'Inter',
                                                              color: AppColors.basicwhiteColor,
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w600,
                                                              height: 1.h,
                                                            ),
                                                          ),
                                                          SizedBox(width: 4.w),
                                                          Text(
                                                            getMonthWithDayWeek(date).toLowerCase(),
                                                            style: TextStyle(
                                                              fontFamily: 'Inter',
                                                              color: AppColors.basicwhiteColor,
                                                              fontSize: 14.sp,
                                                              height: 1.h,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      removeDecimalZeroFormat(value),
                                                                      style: TextStyle(
                                                                        color: AppColors.basicwhiteColor,
                                                                        fontFamily: 'Inter',
                                                                        fontSize: 18.sp,
                                                                        fontWeight: FontWeight.w600,
                                                                        height: 1.2,
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 5.w),
                                                                    Text(
                                                                      'кг',
                                                                      style: TextStyle(
                                                                        color: AppColors.basicwhiteColor,
                                                                        fontFamily: 'Inter',
                                                                        fontSize: 14.sp,
                                                                        height: 1.2,
                                                                        fontWeight: FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                            SizedBox(width: 15.w),
                                                            gerTrandingIcon(value),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Container(
                                                    height: 1,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      gradient: AppColors.secondbackgroundgradientColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 18.h),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    else
                                      SizedBox(
                                        height: 250.h,
                                        child: Center(
                                          child: Text(
                                            "Данные отсутствуют",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.h,
                                              fontFamily: 'Inter',
                                              color: AppColors.basicwhiteColor,
                                            ),
                                          ),
                                        ),
                                      ),

                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30.h),
                            ],
                          ),
                        ),
                      );
                    });
              }
              else if (state is WeightNotConnectedState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: ErrorHandler(
                    addValueFunction: () => addNewValue(state),
                  ),
                );
              }
              else if (state is WeightErrorState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: Center(
                    child: ErrorWithReload(
                      isWhite: true,
                      callback: () {
                        context.read<WeightBloc>().add(WeightGetEvent(dayQuantity, widget.selectedDate.date));
                      },
                    ),
                  ),
                );
              }
              else if (state is WeightLoadingState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: Center(
                    child: ProgressIndicatorWidget(isWhite: true,),
                  ),
                );
              }
              return Container();
            }),
            BlocBuilder<WeightBloc, WeightState>(builder: (context, state) {
              if (state is WeightNotConnectedState) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: WidgetButton(
                            onTap: (){
                              context.read<WeightBloc>().add(WeightConnectedEvent(dayQuantity, widget.selectedDate.date));
                            },
                            color: AppColors.darkGreenColor,
                            text: 'повторить'.toUpperCase(),
                          ),
                        ),
                        SizedBox(width: 30.h),
                        Expanded(
                          child: WidgetButton(
                            onTap: () => context.router.maybePop(),
                            color: AppColors.seaColor,
                            textColor: AppColors.darkGreenColor,
                            text: 'на главную'.toUpperCase(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            }),
          ],
        );
      }
    );
  }

  addNewValue(state) async{
    showModalBottomSheet(
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (context) => ModalSheet(
        color: AppColors.darkGreenColor,
        title: setAddRestriction(state.currentVal?.dateSensor) ? 'Изменить вес' : 'Добавить вес',
        content: ClientSensorsWeightAddScreen(
          date: widget.selectedDate.date,
          view: state.currentVal,
        ),
      ),
    ).then((val) {
      if (val != null) {
        if (targetWeight.isNotEmpty) {
          bool isFinishTarget = false;

          for (var element in targetWeight) {
            if (element == val) {
              isFinishTarget = true;
              break;
            }
          }

          if (isFinishTarget) {
            showModalBottomSheet(
              useSafeArea: true,
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) => Padding(
                padding: const EdgeInsets.only(top: 50),
                child: ModalSheet(
                    title: "Поздравляем!",
                    content: ClientMyDayTrackerSlotsFinish(
                      isTracker: false,
                      clientTrackerId: null,
                    )),
              ),
            );
            context.read<TargetBloc>().add(TargetCheckEvent());
          }
        }

        context.read<WeightBloc>().add(WeightUpdateEvent(dayQuantity, widget.selectedDate.date));
      }
    });
  }

  bool setAddRestriction(String? date) {
    if (date != null) {
      DateTime testDate = DateTime.parse(date);

      if (testDate.day == DateTime.now().day && testDate.month == DateTime.now().month && testDate.year == DateTime.now().year) {
        return true;
      }
      return false;
    }
    return false;
  }


  getTargetWeight(List<ClientTargetsView>? view) {
    if (view != null && view.isNotEmpty) {
      view.forEach((element) {
        if (element.target?.name == "Сбросить вес" || element.target?.name == "Набрать вес") {
          if (element.pointB != null && !targetWeight.contains(element.pointB)) {
            targetWeight.add(element.pointB!);
          }
        }
      });
    }
  }


  check() async{
    final storage = SharedPreferenceData.getInstance();
    final userHeight = await storage.getItem(SharedPreferenceData.userHeightKey);
    final userGender = await storage.getItem(SharedPreferenceData.userGenderKey);
    final bday = await storage.getItem(SharedPreferenceData.userBdayKey);

    if(userHeight != ""){
      setState(() {
        height = int.parse(userHeight);
      });
    }

    if(bday != "" && userGender != ""){
      final imtCalculation = ImtCalculation();
      int gender = userGender == "male" ? 1 : 2;

      int age = imtCalculation.calculateAge(bday);
      idealImt = imtCalculation.getIdealImt(age, gender);
      setState(() {});
    }

  }

  SvgPicture gerTrandingIcon(double? weight) {
    if (weight != null && idealImt != null && height != null) {
      double userImt = weight / (height! / 100);
      double difference = (idealImt! - userImt).abs();

      if (difference <= 3) {
        return SvgPicture.asset(
          'assets/images/trending_down.svg',
          height: 24.h,
        );
      } else if (difference >= 8) {
        return SvgPicture.asset(
          'assets/images/trending_up.svg',
          height: 24.h,
        );
      } else {
        return SvgPicture.asset(
          'assets/images/trending_down.svg',
          height: 24.h,
          color: AppColors.orangeColor,
        );
      }
    }
    return SvgPicture.asset(
      'assets/images/trending_down.svg',
      height: 24.h,
      color: AppColors.orangeColor,
    );
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  String getDay(DateTime? date) {
    if (date != null) {
      return DateFormat('dd.MM.yy').format(date).substring(0, 2);
    }
    return "";
  }

  String getMonthWithDayWeek(DateTime? date) {
    if (date != null) {
      String week = DateFormat('EE', 'ru_RU').format(date);
      String month = CalendarStorage.nameMonthByNumber[date.month].toString();
      String newWeek = week.characters.first.toUpperCase();
      String myWeek = week.substring(1);

      return '$month, $newWeek$myWeek';
    }
    return "";
  }

  getList(List<ClientSensorsView>? list) {
    weightList.clear();
    shortedList.clear();

    if (list != null && list.isNotEmpty) {
      list.forEach((element) {
        if (element.dateSensor != null && element.healthSensorVal != null && element.healthSensorVal != 0) {
          DateTime date = DateUtils.dateOnly(DateTime.parse(element.dateSensor!));
          weightList.update(date, (value) => element.healthSensorVal!.toDouble(), ifAbsent: () => element.healthSensorVal!.toDouble());
        }
      });
    }

    if (weightList.isNotEmpty) {
      weightList = SplayTreeMap<DateTime, double>.from(weightList, (a, b) => b.compareTo(a));

      weightList.forEach((key, val){
        if(shortedList.length != 7){
          shortedList.putIfAbsent(key, ()=> val);
        }
      });
    }
  }
}
