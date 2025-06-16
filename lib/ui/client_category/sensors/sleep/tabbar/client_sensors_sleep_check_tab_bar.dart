import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_health_fit/flutter_health_fit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/sleep/health_sleep_bloc.dart';
import 'package:garnetbook/bloc/client/health/sleep/week_sleep/week_sleep_bloc.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/sleep/bottom_sheet/client_sensors_sleep_add_period_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/calendar/calendar_row.dart';
import 'package:garnetbook/widgets/error_handler/error_handler_sensors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:intl/intl.dart';

class ClientSensorsCheckTabbar extends StatefulWidget {
  const ClientSensorsCheckTabbar({super.key, required this.isRequested, required this.selectedDate});

  final RequestedValue isRequested;
  final SelectedDate selectedDate;

  @override
  State<ClientSensorsCheckTabbar> createState() => _ClientSensorsCheckTabbarState();
}

class _ClientSensorsCheckTabbarState extends State<ClientSensorsCheckTabbar> with AutomaticKeepAliveClientMixin {
  final flutterHealthFit = FlutterHealthFit();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        ListenableBuilder(
            listenable: widget.selectedDate,
            builder: (context, child) {
              return BlocBuilder<HealthSleepBloc, HealthSleepState>(builder: (context, state) {
                if (state is HealthSleepLoadedState) {
                  getRequested();

                  return RefreshIndicator(
                    color: AppColors.darkGreenColor,
                    onRefresh: () {
                      context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(widget.selectedDate.date));
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: ListView(
                        children: [
                          SizedBox(height: 24.h),
                          ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(8.r),
                            child: SizedBox(
                              height: 68.h,
                              child: Stack(
                                children: [
                                  Container(
                                    color: AppColors.basicwhiteColor.withOpacity(0.1),
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                                      child: CalendarRow(
                                        selectedDate: widget.selectedDate.date,
                                        color: AppColors.basicwhiteColor,
                                        onPressedDateCon: () {
                                          DatePickerBdaya.showDatePicker(
                                            context,
                                            showTitleActions: true,
                                            minTime: DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
                                            maxTime: DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day,
                                            ),
                                            onConfirm: (date) {
                                              widget.selectedDate.select(date);
                                              context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(widget.selectedDate.date));
                                              context.read<WeekSleepBloc>().add(WeekSleepGetEvent(date: widget.selectedDate.date, dayQuantity: 7));
                                            },
                                            currentTime: widget.selectedDate.date,
                                            locale: LocaleType.ru,
                                          );
                                        },
                                        onPressedLeft: () {
                                          widget.selectedDate.select(widget.selectedDate.date.subtract(Duration(days: 1)));

                                          context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(widget.selectedDate.date));
                                          context.read<WeekSleepBloc>().add(WeekSleepGetEvent(date: widget.selectedDate.date, dayQuantity: 7));
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
                                            context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(widget.selectedDate.date));
                                            context.read<WeekSleepBloc>().add(WeekSleepGetEvent(date: widget.selectedDate.date, dayQuantity: 7));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          SizedBox(
                            height: 109.h,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      height: 109.h,
                                      color: AppColors.basicwhiteColor.withValues(alpha: 0.2),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 16.w),
                                      Text(
                                        'Время сна',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                          color: AppColors.basicwhiteColor,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              setSleepTime(state.hours, state.minutes),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 64.sp,
                                                color: AppColors.basicwhiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                else if (state is HealthSleepNotConnectedState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: ErrorHandler(
                      addValueFunction: (){
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
                            title: 'Ввести показатели',
                            content: ClientSensorsSleepChangeSheet(date: widget.selectedDate.date, clientSensorId: null),
                          ),
                        ).then((value) {
                          if (value == true) {
                            context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(widget.selectedDate.date));
                            context.read<WeekSleepBloc>().add(WeekSleepGetEvent(date: widget.selectedDate.date, dayQuantity: 7));
                          }
                        });
                      },
                    ),
                  );
                }
                else if (state is HealthSleepLoadingState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.8,
                    child: Center(
                      child: ProgressIndicatorWidget(
                        isWhite: true,
                      ),
                    ),
                  );
                }
                else if (state is HealthSleepErrorState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.8,
                    child: ErrorWithReload(
                      isWhite: true,
                      callback: () {
                        context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(widget.selectedDate.date));
                      },
                    ),
                  );
                }
                return Container();
              });
            }),
        BlocBuilder<HealthSleepBloc, HealthSleepState>(builder: (context, state) {
          if (state is HealthSleepLoadedState ) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: ColoredBox(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  child: WidgetButton(
                    onTap: () {
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
                          title: 'Ввести показатели',
                          content: ClientSensorsSleepChangeSheet(date: widget.selectedDate.date, clientSensorId: state.clientSensorId),
                        ),
                      ).then((value) {
                        if (value == true) {
                          context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(widget.selectedDate.date));
                          context.read<WeekSleepBloc>().add(WeekSleepGetEvent(date: widget.selectedDate.date, dayQuantity: 7));
                        }
                      });
                    },
                    color: AppColors.darkGreenColor,
                    text: 'Изменить'.toUpperCase(),
                  ),
                ),
              ),
            );
          }
          else if(state is HealthSleepNotConnectedState){
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
                          context.read<HealthSleepBloc>().add(HealthConnectedEvent(DateTime.now()));
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

  setSleepTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}';
  }

  getRequested() async {
    final isAuth = await flutterHealthFit.isAuthorized();
    if (!isAuth) {
      widget.isRequested.select(false);
    } else {
      widget.isRequested.select(true);
    }
  }
}
