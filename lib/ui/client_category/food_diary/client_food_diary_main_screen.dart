import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/diets/diets_list_bloc.dart';
import 'package:garnetbook/bloc/client/food_diary/food_diary_bloc.dart';
import 'package:garnetbook/bloc/client/target/target_bloc.dart';
import 'package:garnetbook/bloc/client/water_diary/water_diary_bloc.dart';
import 'package:garnetbook/data/models/client/food_diary/food_diary_model.dart';
import 'package:garnetbook/data/repository/food_diary_storage.dart';
import 'package:garnetbook/ui/client_category/food_diary/components/client_food_diary_list_meal.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/calendar/calendar_row.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';

@RoutePage()
class ClientFoodDiaryMainScreen extends StatefulWidget {
  const ClientFoodDiaryMainScreen({super.key});

  @override
  State<ClientFoodDiaryMainScreen> createState() => _ClientFoodDiaryMainScreenState();
}

class _ClientFoodDiaryMainScreenState extends State<ClientFoodDiaryMainScreen> {
  DateTime selectedDate = DateUtils.dateOnly(DateTime.now());
  final foodDiaryStorage = FoodDiaryStorage();

  Map<int, bool> fitonutrientList = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
    6: false,
  };

  @override
  void initState() {
    if (BlocProvider.of<FoodDiaryBloc>(context).state is FoodDiaryGetState) {
    } else {
      context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(selectedDate));
    }

    if (BlocProvider.of<WaterDiaryBloc>(context).state is WaterDiaryGetState) {
    } else {
      context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(DateTime.now()));
    }

    context.read<DietListBloc>().add(DietsListGetEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.gradientTurquoiseReverse,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                color: AppColors.darkGreenColor,
                onRefresh: () {
                  context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(selectedDate));
                  return Future.delayed(const Duration(seconds: 1));
                },
                child: BlocBuilder<DietListBloc, DietsListState>(
                  builder: (context, dietState) {
                    return ListView(
                      children: [
                        SizedBox(height: 56.h + 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: CalendarRow(
                            selectedDate: selectedDate,
                            onPressedDateCon: () {
                              DatePickerBdaya.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(DateTime.now().year - 1, 0, 0),
                                maxTime: DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                ),
                                onConfirm: (newDate) {
                                  setState(() {
                                    selectedDate = newDate;
                                  });
                                  context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(selectedDate));
                                },
                                currentTime: selectedDate,
                                locale: LocaleType.ru,
                              );
                            },
                            onPressedLeft: () {
                              setState(() {
                                selectedDate = selectedDate.subtract(Duration(days: 1));
                              });
                              context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(selectedDate));
                            },
                            onPressedRight: () {
                              if (selectedDate.add(Duration(days: 1)).isAfter(DateTime.now())) {
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
                                setState(() {
                                  selectedDate = selectedDate.add(Duration(days: 1));
                                });
                                context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(selectedDate));
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: dietState is DietsListLoadedState && dietState.view != null && dietState.view!.isNotEmpty,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w).copyWith(top: 20.h, bottom: 10.h),
                            child: FormForButton(
                              borderRadius: BorderRadius.circular(8.r),
                              onPressed: (){
                                context.router.push(ClientFoodDiaryDietMainRoute());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: AppColors.basicwhiteColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 24.w,
                                      height: 24.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.vivaMagentaColor,
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "!",
                                          style: TextStyle(
                                            color: AppColors.basicwhiteColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.sp
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Вам назначен новый рацион!",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.darkGreenColor,
                                              fontFamily: "Inter"
                                            ),
                                          ),
                                          Text(
                                            dietState is DietsListLoadedState && dietState.view != null && dietState.view!.isNotEmpty
                                                ? dietState.view?.first.nameDiet ?? "" : "",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.vivaMagentaColor,
                                                fontFamily: "Inter"
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    SvgPicture.asset(
                                      'assets/images/chevron-next.svg',
                                      width: 20.w,
                                      height: 20.h,
                                      color: AppColors.vivaMagentaColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        BlocBuilder<FoodDiaryBloc, FoodDiaryState>(builder: (context, state) {
                          if (state is FoodDiaryGetState) {
                            getCircle(state.food);

                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 24.h),
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: AppColors.multigradientColor,
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Ваша норма:',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 12.sp,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.darkGreenColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      BlocBuilder<TargetBloc, TargetState>(builder: (context, targetState) {
                                                        return Text(
                                                          getCalories(state, targetState),
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w800,
                                                            fontSize: 24.sp,
                                                            height: 1.h,
                                                            fontFamily: 'Inter',
                                                            color: AppColors.darkGreenColor,
                                                          ),
                                                        );
                                                      }),
                                                      Text(
                                                        ' ккал'.toUpperCase(),
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 12.sp,
                                                          fontFamily: 'Inter',
                                                          color: AppColors.darkGreenColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 16.h),
                                                  Text(
                                                    'Потреблено:',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 12.sp,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.darkGreenColor,
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        state.dayCalorie.toString(),
                                                        style: TextStyle(
                                                          height: 1,
                                                          fontWeight: FontWeight.w800,
                                                          fontSize: 24.sp,
                                                          fontFamily: 'Inter',
                                                          color: AppColors.darkGreenColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        ' ккал'.toUpperCase(),
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 12.sp,
                                                          fontFamily: 'Inter',
                                                          color: AppColors.darkGreenColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              CircleAvatar(
                                                radius: 60.h,
                                                child: Stack(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/food_diary/food_diary_chart.png',
                                                      height: double.infinity,
                                                    ),
                                                    for (var i in List.generate(6, (i) => i))
                                                      if (fitonutrientList.values.toList()[i] == false)
                                                        Transform.rotate(
                                                          angle: pi / 3 * i,
                                                          child: Align(
                                                            alignment: Alignment.topCenter,
                                                            child: Image.asset(
                                                              'assets/images/food_diary/food_diary_black_figure.png',
                                                              height: 60.h,
                                                            ),
                                                          ),
                                                        ),
                                                    Center(
                                                      child: Container(
                                                        height: 60.h,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          gradient: AppColors.gradientTurquoise,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                ClientFoodDiaryListMeal(selectedDate: selectedDate),
                                SizedBox(height: 40.h),
                              ],
                            );
                          } else if (state is FoodDiaryErrorState) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 1.6,
                              child: ErrorWithReload(
                                callback: () {
                                  context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(selectedDate));
                                },
                              ),
                            );
                          } else if (state is FoodDiaryLoadingState) {
                            return SizedBox(height: MediaQuery.of(context).size.height / 1.6, child: ProgressIndicatorWidget());
                          }
                          return Container();
                        }),
                      ],
                    );
                  }
                ),
              ),
              Container(
                width: double.infinity,
                height: 56.h,
                color: AppColors.basicwhiteColor,
                child: Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientTurquoise,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => context.router.maybePop(),
                          icon: Image.asset(
                            AppImeges.arrow_back_png,
                            color: AppColors.darkGreenColor,
                            height: 25.h,
                            width: 25.w,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Дневник питания',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getCircle(List<ClientFoodView>? list) {
    if (list != null && list.isNotEmpty) {
      list.forEach((item) {
        if (item.foods != null && item.foods!.isNotEmpty) {
          item.foods!.forEach((element) {
            if (element.foodPeriod != null &&
                element.id != null &&
                element.foodTime != null &&
                element.colors != null &&
                element.colors!.isNotEmpty) {
              element.colors!.forEach((color) {
                if (color.id != null) {
                  if (foodDiaryStorage.listOfItemColor.any((data) => data.id == color.id)) {
                    fitonutrientList[color.id!] = true;
                    print(fitonutrientList.values);
                  }
                }
              });
            }
          });
        }
      });
    }
  }

  String getCalories(state, targetState) {
    if (targetState is TargetLoadedState && state is FoodDiaryGetState) {
      if (targetState.view != null && targetState.view!.isNotEmpty) {
        int dailyCalorie = targetState.view?.first.calories ?? 0;

        return dailyCalorie.toString();
      }
    }
    return "2000";
  }
}
