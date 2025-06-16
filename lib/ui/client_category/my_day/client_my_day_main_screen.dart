import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/additives/additives_cubit.dart';
import 'package:garnetbook/bloc/client/additives/additives_main/additives_main_cubit.dart';
import 'package:garnetbook/bloc/client/food_diary/food_diary_bloc.dart';
import 'package:garnetbook/bloc/client/health/blood_glucose/blood_glucose_bloc.dart';
import 'package:garnetbook/bloc/client/health/blood_oxygen/blood_oxygen_bloc.dart';
import 'package:garnetbook/bloc/client/health/main/health_main_cubit.dart';
import 'package:garnetbook/bloc/client/health/pressure/pressure_bloc.dart';
import 'package:garnetbook/bloc/client/health/pulse/pulse_bloc.dart';
import 'package:garnetbook/bloc/client/health/sleep/health_sleep_bloc.dart';
import 'package:garnetbook/bloc/client/health/steps/health_step_bloc.dart';
import 'package:garnetbook/bloc/client/health/weight/weight_bloc.dart';
import 'package:garnetbook/bloc/client/health/workout/today_workout/today_workout_cubit.dart';
import 'package:garnetbook/bloc/client/profile/client_profile_bloc.dart';
import 'package:garnetbook/bloc/client/recipes/recipes_all/recipes_all_cubit.dart';
import 'package:garnetbook/bloc/client/recipes/recipes_today/recipes_today_cubit.dart';
import 'package:garnetbook/bloc/client/target/target_bloc.dart';
import 'package:garnetbook/bloc/client/trackers/trackers_cubit.dart';
import 'package:garnetbook/bloc/client/version/version_cubit.dart';
import 'package:garnetbook/bloc/client/water_diary/water_diary_bloc.dart';
import 'package:garnetbook/bloc/user/user_data_cubit.dart';
import 'package:garnetbook/ui/client_category/my_day/components/client_my_day_sensors.dart';
import 'package:garnetbook/ui/client_category/my_day/components/client_my_day_target.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/percents/prossent_bar_small.dart';

@RoutePage()
class ClientMyDayMainScreen extends StatefulWidget {
  ClientMyDayMainScreen({super.key});

  @override
  State<ClientMyDayMainScreen> createState() => _ClientMyDayMainScreenState();
}

class _ClientMyDayMainScreenState extends State<ClientMyDayMainScreen> {
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    check();
    context.read<HealthMainCubit>().check();

    if (BlocProvider.of<UserDataCubit>(context).state is! UserDataLoadedState) {
      context.read<UserDataCubit>().check();
    }
    context.read<ClientProfileCubit>().check();

    context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(DateTime.now()));
    context.read<TargetBloc>().add(TargetCheckEvent());
    context.read<AdditivesCubit>().check();

    context.read<HealthStepBloc>().add(HealthStepGetEvent());

    context.read<WeightBloc>().add(WeightGetEvent(7, DateTime.now()));
    context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(DateTime.now()));

    context.read<PressureBloc>().add(PressureGetEvent(DateTime.now(), null));
    context.read<PulseBloc>().add(PulseGetEvent(DateTime.now()));
    context.read<BloodGlucoseBloc>().add(BloodGlucoseGetEvent(DateTime.now(), null));
    context.read<BloodOxygenBloc>().add(BloodOxygenGetEvent(DateTime.now(), null));
    context.read<TodayWorkoutCubit>().check();

    context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(DateTime.now()));

    context.read<AdditivesMainCubit>().check();
    context.read<TrackersCubit>().check();

    context.read<RecipesTodayCubit>().check();
    context.read<RecipesAllCubit>().check();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.basicwhiteColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.gradientTurquoiseReverse),
        child: SafeArea(
          child: BlocBuilder<TargetBloc, TargetState>(builder: (context, targetState) {
            if (targetState is TargetLoadingState) {
              return SizedBox(height: MediaQuery.of(context).size.height / 1.2, child: ProgressIndicatorWidget());
            }
            return BlocBuilder<VersionCubit, bool>(
              builder: (context, isFreeVersion) {
                return RefreshIndicator(
                  color: AppColors.darkGreenColor,
                  onRefresh: () {
                    context.read<ClientProfileCubit>().check();
                    context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(DateTime.now()));
                    context.read<TargetBloc>().add(TargetCheckEvent());
                    context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(DateTime.now()));
                    context.read<TrackersCubit>().check();
                    context.read<AdditivesMainCubit>().check();
                    context.read<HealthStepBloc>().add(HealthStepGetEvent());
                    context.read<WeightBloc>().add(WeightGetEvent(7, DateTime.now()));
                    context.read<BloodGlucoseBloc>().add(BloodGlucoseGetEvent(DateTime.now(), null));
                    context.read<BloodOxygenBloc>().add(BloodOxygenGetEvent(DateTime.now(), null));
                    context.read<TodayWorkoutCubit>().check();
                    context.read<PressureBloc>().add(PressureGetEvent(DateTime.now(), null));
                    context.read<PulseBloc>().add(PulseGetEvent(DateTime.now()));
                    context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(DateTime.now()));
                    context.read<RecipesTodayCubit>().check();
                    context.read<RecipesAllCubit>().check();
                    return Future.delayed(const Duration(seconds: 1));
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ClientMyDayTarget(),
                        SizedBox(height: 15.h),
                        ClientMyDaySensors(),
                        SizedBox(height: 20.h),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: FormForButton(
                                borderRadius: BorderRadius.circular(8),
                                onPressed: isFreeVersion
                                    ? null
                                    : () {
                                        context.router.push(ClientFoodDiaryMainRoute()).then((val) {
                                          context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(DateTime.now()));
                                        });
                                      },
                                child: Container(
                                  height: 144.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradientTurquoise,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.basicblackColor.withOpacity(0.1),
                                        blurRadius: 10.r,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    clipBehavior: Clip.hardEdge,
                                    child: Stack(
                                      children: [
                                        ImageFiltered(
                                          imageFilter: ImageFilter.blur(sigmaX: isFreeVersion ? 6 : 0, sigmaY: isFreeVersion ? 6 : 0),
                                          child: Image.asset(
                                            'assets/images/food_diary/food_diary_my_day.png',
                                            fit: BoxFit.cover,
                                            height: 144.h,
                                            width: double.infinity,
                                          ),
                                        ),
                                        Container(
                                          height: 144.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.basicblackColor.withOpacity(0.8),
                                                AppColors.basicblackColor.withOpacity(0),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: isFreeVersion ? 0.5 : 1,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                                            child: BlocBuilder<FoodDiaryBloc, FoodDiaryState>(builder: (context, foodState) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Дневник питания',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: AppColors.basicwhiteColor,
                                                      fontSize: 18.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    'Осталось',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: AppColors.basicwhiteColor,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        getLostCalories(foodState, targetState).toString(),
                                                        style: TextStyle(
                                                          height: 1,
                                                          fontFamily: 'Inter',
                                                          color: AppColors.basicwhiteColor,
                                                          fontSize: 36.sp,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      SizedBox(
                                                        height: 32.sp,
                                                        child: Align(
                                                          alignment: Alignment.bottomCenter,
                                                          child: Text(
                                                            ' ккал',
                                                            style: TextStyle(
                                                              fontFamily: 'Inter',
                                                              color: AppColors.basicwhiteColor,
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 6.h),
                                                  ProssentBarSmall(
                                                    width: 325.w,
                                                    hiegth: 16.h,
                                                    backColor: AppColors.basicwhiteColor.withOpacity(0.7),
                                                    prossentGradeint: LinearGradient(
                                                      colors: [
                                                        AppColors.basicwhiteColor,
                                                        AppColors.darkGreenColor,
                                                      ],
                                                    ),
                                                    prossentWidth: 325.w *
                                                        (foodState is FoodDiaryGetState ? foodState.dayCalorie : 0) /
                                                        (targetState is TargetLoadedState
                                                            ? targetState.view != null &&
                                                                    targetState.view != [] &&
                                                                    targetState.view!.isNotEmpty
                                                                ? targetState.view?.first.calories ?? 2000
                                                                : 2000
                                                            : 2000),
                                                  ),
                                                ],
                                              );
                                            }),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  check() async {
    final cachedImageManager = CachedImageBase64Manager.instance();
    await cachedImageManager.clearCache();
  }

  int getLostCalories(foodState, targetState) {
    if (foodState is FoodDiaryGetState && targetState is TargetLoadedState) {
      if (targetState.view != null && targetState.view!.isNotEmpty && targetState.view?.first.calories != null) {
        if (foodState.dayCalorie > targetState.view!.first.calories!) {
          return 0;
        } else {
          return targetState.view!.first.calories! - foodState.dayCalorie;
        }
      } else {
        if (foodState.dayCalorie > 2000) {
          return 0;
        }
        return 2000 - foodState.dayCalorie;
      }
    }
    return 0;
  }
}
