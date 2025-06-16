import 'dart:io';
import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/blood_oxygen/blood_oxygen_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/blood_oxygen/bottom_sheet/client_blood_oxygen_add_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/error_handler/error_handler_sensors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/percents/oxygen_prosent_container.dart';
import 'package:health/health.dart';

class ClientSensorsTabBarOxygenCheck extends StatefulWidget {
  const ClientSensorsTabBarOxygenCheck({
    Key? key,
    required this.selectedDate,
    required this.isRequested,
  }) : super(key: key);

  final SelectedDate selectedDate;
  final RequestedValue isRequested;

  @override
  State<ClientSensorsTabBarOxygenCheck> createState() => _ClientSensorsTabBarOxygenCheckState();
}

class _ClientSensorsTabBarOxygenCheckState extends State<ClientSensorsTabBarOxygenCheck> with AutomaticKeepAliveClientMixin {
  Health health = Health();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        BlocBuilder<BloodOxygenBloc, BloodOxygenState>(builder: (context, state) {
          if (state is BloodOxygenLoadedState) {
            getRequested();

            return ListenableBuilder(
                listenable: widget.selectedDate,
                builder: (context, child) {

                  return RefreshIndicator(
                    color: AppColors.darkGreenColor,
                    onRefresh: () {
                      context.read<BloodOxygenBloc>().add(BloodOxygenGetEvent(widget.selectedDate.date, widget.isRequested));
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView(
                      children: [
                        SizedBox(height: 24.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: SizedBox(
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
                                        'Текущее измерение',
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
                                              getValue(state.currentVal),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 64.sp,
                                                height: 1,
                                                color: AppColors.basicwhiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      SizedBox(
                                        height: 45.sp,
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            '%',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18.sp,
                                              color: AppColors.basicwhiteColor,
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
                        ),
                        SizedBox(height: 48.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: SizedBox(
                            height: 140.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      height: 130.h,
                                      color: AppColors.basicwhiteColor.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    child: OxygenPercentContainer(
                                      percent: getPercentValue(state.currentVal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
          else if (state is BloodOxygenNotConnectedState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              child: ErrorHandler(
                addValueFunction: () => addNewVal(),
              ),
            );
          }
          else if (state is BloodOxygenErrorState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.6,
              child: Center(
                  child: ErrorWithReload(
                      isWhite: true,
                      callback: () {
                        context.read<BloodOxygenBloc>().add(BloodOxygenGetEvent(widget.selectedDate.date, widget.isRequested));
                      })),
            );
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.6,
            child: Center(
              child: ProgressIndicatorWidget(isWhite: true),
            ),
          );
        }),
        BlocBuilder<BloodOxygenBloc, BloodOxygenState>(builder: (context, state) {
          if (state is BloodOxygenLoadedState) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w).copyWith(bottom: 16.h),
                child: WidgetButton(
                  onTap: () => addNewVal(),
                  boxShadow: true,
                  color: AppColors.darkGreenColor,
                  text: 'ИЗМЕРИТЬ',
                ),
              ),
            );
          }
          if(state is BloodOxygenNotConnectedState){
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
                          context.read<BloodOxygenBloc>().add(BloodOxygenConnectedEvent(widget.selectedDate.date, widget.isRequested));
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

  getRequested() async {
    final requested = Platform.isAndroid
        ? await health.hasPermissions([HealthDataType.BLOOD_OXYGEN], permissions: [HealthDataAccess.READ_WRITE])
        : await health.requestAuthorization([HealthDataType.BLOOD_OXYGEN], permissions: [HealthDataAccess.READ_WRITE]);

    if (Platform.isAndroid) {
      if (requested == true) {
        widget.isRequested.select(true);
      } else {
        widget.isRequested.select(false);
      }
    }
  }

  addNewVal(){
    showModalBottomSheet(
      useSafeArea: true,
      backgroundColor: AppColors.basicwhiteColor,
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
        content: ClientBloodOxygenAddSheet(date: widget.selectedDate.date),
      ),
    ).then((val) {
      if (val == true) {
        context.read<BloodOxygenBloc>().add(BloodOxygenUpdateEvent(widget.selectedDate.date, widget.isRequested));
      }
    });
  }

  int getPercentValue(ClientSensorsView? view) {
    if (view != null && view.healthSensorVal != null) {
      return view.healthSensorVal!.toInt();
    }
    return 0;
  }

  String getValue(ClientSensorsView? view) {
    if (view != null && view.healthSensorVal != null) {
      return view.healthSensorVal!.toInt().toString();
    }
    return "0";
  }
}
