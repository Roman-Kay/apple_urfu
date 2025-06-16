import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/food_diary/food_diary_bloc.dart';
import 'package:garnetbook/bloc/client/health/blood_glucose/blood_glucose_bloc.dart';
import 'package:garnetbook/bloc/client/health/blood_oxygen/blood_oxygen_bloc.dart';
import 'package:garnetbook/bloc/client/health/pressure/pressure_bloc.dart';
import 'package:garnetbook/bloc/client/health/pulse/pulse_bloc.dart';
import 'package:garnetbook/bloc/client/health/sleep/health_sleep_bloc.dart';
import 'package:garnetbook/bloc/client/health/steps/health_step_bloc.dart';
import 'package:garnetbook/bloc/client/health/weight/weight_bloc.dart';
import 'package:garnetbook/bloc/client/health/workout/today_workout/today_workout_cubit.dart';
import 'package:garnetbook/bloc/client/water_diary/water_diary_bloc.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/widgets/containers/sensors_containers.dart';

class ClientMyDaySensors extends StatefulWidget {
  ClientMyDaySensors({Key? key}) : super(key: key);

  @override
  State<ClientMyDaySensors> createState() => _ClientMyDaySensorsState();
}

class _ClientMyDaySensorsState extends State<ClientMyDaySensors> {
  String calorie = "2200";

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 22.w,
      runSpacing: 22.h,
      children: [
        BlocBuilder<HealthStepBloc, HealthStepState>(builder: (context, healthState) {
          return SensorsDataContainer(
            onTap: () async {
              context.router.push(ClientSensorsStepsRoute()).then((value) => setState(() {}));
            },
            image: 'assets/images/my_day_steps.webp',
            name: 'Шаги',
            textWidget: Text(
              healthState is HealthStepLoadedState ? healthState.steps.toString() : "0",
              style: TextStyle(
                height: 1,
                fontFamily: 'Inter',
                color: AppColors.basicwhiteColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            title: healthState is HealthStepLoadedState ? "осталось: ${getStepLeft(healthState.steps.toString(), "10000")}" : "осталось: 0",
            needContainer: false,
          );
        }),
        BlocBuilder<WaterDiaryBloc, WaterDiaryState>(builder: (context, state) {
          return SensorsDataContainer(
            onTap: () {
              context.router.push(ClientWaterMainRoute()).then((v){
                context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(DateTime.now()));
              });
            },
            image: 'assets/images/my_day_water.webp',
            name: 'Вода',
            textWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  state is WaterDiaryGetState ? "${state.today?.dayVal ?? "0"}" : "0",
                  style: TextStyle(
                    height: 1,
                    fontFamily: 'Inter',
                    color: AppColors.basicwhiteColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.sp),
                  child: Text(
                    'мл',
                    style: TextStyle(
                      height: 1,
                      fontFamily: 'Inter',
                      color: AppColors.basicwhiteColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            title: state is WaterDiaryGetState ? 'осталось: ${getLostWater(state)}' : "",
            needContainer: false,
          );
        }),
        BlocBuilder<WeightBloc, WeightState>(builder: (context, state) {
          return SensorsDataContainer(
            onTap: () {
              context.router.push(ClientSensorsWeightRoute()).then((value) {
                context.read<WeightBloc>().add(WeightGetEvent(7, DateTime.now()));
              });
            },
            image: 'assets/images/my_day_wiegth.webp',
            name: 'Вес',
            textWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  state is WeightLoadedState && state.currentVal?.healthSensorVal != null
                      ? removeDecimalZeroFormat(state.currentVal!.healthSensorVal!.toDouble())
                      : "0",
                  style: TextStyle(
                    height: 1,
                    fontFamily: 'Inter',
                    color: AppColors.basicwhiteColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.sp),
                  child: Text(
                    'кг',
                    style: TextStyle(
                      height: 1,
                      fontFamily: 'Inter',
                      color: AppColors.basicwhiteColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            title: getWeightTitle(state),
            needContainer: getWeightTitle(state) != "" ? true : false,
          );
        }),
        BlocBuilder<HealthSleepBloc, HealthSleepState>(builder: (context, state) {
          return SensorsDataContainer(
            onTap: () {
              context.router.push(ClientSensorsSleepRoute()).then((value) {
                context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(DateTime.now()));
              });
            },
            image: 'assets/images/my_day_sleep.webp',
            name: 'Сон',
            textWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  state is HealthSleepLoadedState ? state.hours.toString() : "0",
                  style: TextStyle(
                    height: 1,
                    fontFamily: 'Inter',
                    color: AppColors.basicwhiteColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 5.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.sp),
                  child: Text(
                    'ч',
                    style: TextStyle(
                      height: 1,
                      fontFamily: 'Inter',
                      color: AppColors.basicwhiteColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  state is HealthSleepLoadedState ? state.minutes.toString() : "0",
                  style: TextStyle(
                    height: 1,
                    fontFamily: 'Inter',
                    color: AppColors.basicwhiteColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 5.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.sp),
                  child: Text(
                    'мин',
                    style: TextStyle(
                      height: 1,
                      fontFamily: 'Inter',
                      color: AppColors.basicwhiteColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            title: getDate(state, "sleep"),
            needContainer: false,
          );
        }),
        BlocBuilder<PressureBloc, PressureState>(builder: (context, pressureState) {
          return BlocBuilder<PulseBloc, PulseState>(builder: (context, pulseState) {
            return SensorsDataContainer(
              onTap: () {
                context.router.push(ClientSensorsPressureMainRoute()).then((value) {
                  context.read<PressureBloc>().add(PressureGetEvent(DateTime.now(), null));
                  context.read<PulseBloc>().add(PulseGetEvent(DateTime.now()));
                });
              },
              name: 'Давление',
              isNotForFreeVersion: true,
              image: 'assets/images/my_day_pressure.webp',
              textWidget: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getPressure(pressureState),
                    style: TextStyle(
                      height: 1,
                      fontFamily: 'Inter',
                      color: AppColors.basicwhiteColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  SvgPicture.asset(
                    'assets/images/pulse.svg',
                    width: 13.71.w,
                    height: 12.858.h,
                  ),
                  SizedBox(width: 4.w),
                  if (getPulse(pressureState, pulseState) != "")
                    FittedBox(
                      child: Text(
                        getPulse(pressureState, pulseState),
                        style: TextStyle(
                          height: 1,
                          fontFamily: 'Inter',
                          color: AppColors.basicwhiteColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              title: getDate(pressureState, "pressure"),
              needContainer: getDate(pressureState, "pressure") != "" ? true : false,
            );
          });
        }),
        BlocBuilder<BloodGlucoseBloc, BloodGlucoseState>(builder: (context, state) {
          return SensorsDataContainer(
            onTap: () {
              context.router.push(ClientSensorsSugarInBloodRoute()).then((value) {
                context.read<BloodGlucoseBloc>().add(BloodGlucoseGetEvent(DateTime.now(), null));
              });
            },
            image: 'assets/images/my_day_sugar.webp',
            name: 'Сахар в крови',
            isNotForFreeVersion: true,
            textWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  getBloodGlucose(state),
                  style: TextStyle(
                    height: 1,
                    fontFamily: 'Inter',
                    color: AppColors.basicwhiteColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.sp),
                  child: Text(
                    'ммоль/л',
                    style: TextStyle(
                      height: 1,
                      fontFamily: 'Inter',
                      color: AppColors.basicwhiteColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            title: getDate(state, "blood_glucose"),
            needContainer: getDate(state, "blood_glucose") != "" ? true : false,
          );
        }),
        BlocBuilder<TodayWorkoutCubit, TodayWorkoutState>(builder: (context, state) {
          return SensorsDataContainer(
            onTap: () {
              context.router.push(ClientSensorsActivityRoute()).then((value) {
                context.read<TodayWorkoutCubit>().check();
              });
            },
            image: 'assets/images/my_day_activity.webp',
            name: 'Активность',
            isNotForFreeVersion: true,
            textWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  state is TodayWorkoutLoadedState ? state.calories.toString() : "0",
                  style: TextStyle(
                    height: 1,
                    fontFamily: 'Inter',
                    color: AppColors.basicwhiteColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.sp),
                  child: Text(
                    'ккал',
                    style: TextStyle(
                      height: 1,
                      fontFamily: 'Inter',
                      color: AppColors.basicwhiteColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            title: getDate(state, "workout"),
            needContainer: false,
          );
        }),
        BlocBuilder<BloodOxygenBloc, BloodOxygenState>(builder: (context, state) {
          return SensorsDataContainer(
            onTap: () {
              context.router.push(ClientSensorsOxygenInBloodRoute()).then((value) {
                context.read<BloodOxygenBloc>().add(BloodOxygenGetEvent(DateTime.now(), null));
              });
            },
            image: 'assets/images/my_day_SpO2.webp',
            name: 'Сатурация O2',
            isNotForFreeVersion: true,
            textWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  state is BloodOxygenLoadedState && state.currentVal?.healthSensorVal != null
                      ? state.currentVal!.healthSensorVal!.toInt().toString()
                      : "0",
                  style: TextStyle(
                    height: 1,
                    fontFamily: 'Inter',
                    color: AppColors.basicwhiteColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.sp),
                  child: Text(
                    '%',
                    style: TextStyle(
                      height: 1,
                      fontFamily: 'Inter',
                      color: AppColors.basicwhiteColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            title: 'норма: 95% - 100%',
            needContainer: false,
          );
        }),
      ],
    );
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  String getPressure(state) {
    if (state is PressureLoadedState) {
      if (state.currentVal != null && state.currentVal?.healthSensorVal != null) {
        String newTest = state.currentVal!.healthSensorVal.toString();

        List values = newTest.split(".");

        int diastolic = int.parse(setDecimalDigits(values.first));
        int systolic = int.parse(setDecimalDigits(values.last));

        return "$systolic/$diastolic";
      }
    }
    return "0";
  }

  String getPulse(pressureState, state) {
    if (state is PulseLoadedState && pressureState is PressureLoadedState) {
      if (pressureState.currentVal != null && pressureState.currentVal?.dateSensor != null) {
        if (state.list != null && state.list!.isNotEmpty) {
          bool isExist = state.list!.any((element) => element.dateSensor == pressureState.currentVal!.dateSensor);

          if (isExist) {
            for (var element in state.list!) {
              if (element.dateSensor == pressureState.currentVal!.dateSensor) {
                if (element.healthSensorVal?.toInt() != null) {
                  return element.healthSensorVal!.toInt().toString();
                }
              }
            }
          }
        }
      }
    }
    return "";
  }

  String setDecimalDigits(String number) {
    String firstChar = number[0];

    if (number.length == 1) {
      if (firstChar == "1" || firstChar == "2") {
        return number + "00";
      }
      return number + "0";
    }

    if ((firstChar == "1" || firstChar == "2") && number.length == 2) {
      return number + "0";
    }
    return number;
  }

  String getLessCalories(state) {
    if (calorie != "" && state is FoodDiaryGetState) {
      int dailyCalorie = int.parse(calorie);
      int myCalorie = state.dayCalorie;
      int leftCalorie = dailyCalorie - myCalorie;
      if (leftCalorie.isNegative) {
        return "осталось: 0";
      } else {
        return "осталось: ${leftCalorie.toString()}";
      }
    }
    return "";
  }

  String getWeightTitle(state) {
    if (state is WeightLoadedState) {
      if (state.targetView?.pointB != null &&
          state.currentVal?.healthSensorVal != null &&
          state.targetView?.target?.name != null &&
          state.targetView?.completed != true) {
        int point = state.targetView!.pointB!.toInt();
        int userWeight = state.currentVal!.healthSensorVal!.toInt();
        String target = state.targetView!.target!.name!;

        if (target == "Сбросить вес") {
          var weight = userWeight - point;
          if (!weight.isNegative) {
            return 'осталось сбросить: $weight кг';
          }
          return 'осталось сбросить: 0 кг';
        } else if (target == "Набрать вес") {
          var weight = point - userWeight;
          if (!weight.isNegative) {
            return 'осталось набрать: $weight кг';
          }
          return 'осталось набрать: 0 кг';
        }
      }
    }
    return "";
  }

  String getStepLeft(String? steps, String? goalStep) {
    if (steps != null && goalStep != null && goalStep != "" && steps != "") {
      int goal = int.parse(goalStep);
      int step = int.parse(steps);
      if (step < goal) {
        return "${goal - step}";
      }
      return "0";
    }
    return "0";
  }

  String getLostWater(state) {
    if (state is WaterDiaryGetState) {
      int dayVal = state.today?.dayVal ?? 0;
      int dayTarget = state.dayTarget;
      if (dayVal > dayTarget) {
        return "0";
      }
      return (dayTarget - dayVal).toString();
    }
    return "2000";
  }

  String getDate(state, type) {
    if (state is BloodGlucoseLoadedState && state.currentVal?.dateSensor != null && type == "blood_glucose") {
      String time = DateFormatting().formatTime(state.currentVal?.dateSensor);
      DateTime tempDate = DateTime.parse(state.currentVal!.dateSensor!);

      if (tempDate.difference(DateTime.now()).inDays == 0) {
        return "измерение: сегодня, $time";
      }
      String newDate = DateFormatting().formatDateRU(state.currentVal?.dateSensor);
      return "измерение: $newDate, $time";
    } else if (type == "workout" && state is TodayWorkoutLoadedState) {
      if (state.date != null) {
        String time = DateFormatting().formatTime(state.date);
        return "измерение: сегодня, $time";
      }
    } else if (type == "sleep" && state is HealthSleepLoadedState) {
      if (state.date != null) {
        String time = DateFormatting().formatTime(state.date);
        return "измерение: сегодня, $time";
      }
    } else if (type == "pressure" && state is PressureLoadedState) {
      if (state.currentVal?.dateSensor != null) {
        String time = DateFormatting().formatTime(state.currentVal?.dateSensor);
        DateTime tempDate = DateTime.parse(state.currentVal!.dateSensor!);

        if (tempDate.difference(DateTime.now()).inDays == 0) {
          return "измерение: сегодня, $time";
        }
        String newDate = DateFormatting().formatDateRU(state.currentVal?.dateSensor);
        return "измерение: $newDate, $time";
      }
    }
    return "";
  }

  String getBloodGlucose(state) {
    if (state is BloodGlucoseLoadedState && state.currentVal?.healthSensorVal != null) {
      double doubleGlucose = state.currentVal!.healthSensorVal!.toDouble();
      return removeDecimalZeroFormat(doubleGlucose);
    }
    return "0";
  }
}
