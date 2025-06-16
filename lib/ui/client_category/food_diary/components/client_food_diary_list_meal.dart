// ignore_for_file: must_be_immutable

import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/calendar/calendar_for_day/calendar_for_day_bloc.dart';
import 'package:garnetbook/bloc/client/calendar/selected_date/selected_date_bloc.dart';
import 'package:garnetbook/bloc/client/food_diary/food_diary_bloc.dart';
import 'package:garnetbook/bloc/client/water_diary/water_diary_bloc.dart';
import 'package:garnetbook/data/models/client/food_diary/food_diary_model.dart';
import 'package:garnetbook/domain/services/client/food_diary/food_diary_service.dart';
import 'package:garnetbook/ui/client_category/food_diary/bottom_sheets/client_food_diary_change_sheet.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/extension/string_externsions.dart';
import 'package:garnetbook/data/repository/food_diary_storage.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/dialogs/delete_dialog.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ItemMeal {
  ItemMeal(
      {required this.food,
      this.isOpen = true,
      required this.id,
      this.dayCalorie,
      this.normCalorie,
      this.calorie,
      this.drink,
      this.time,
      this.water,
      this.comment,
      this.expertComment,
      required this.colors});

  List<FoodView> food;
  List<DrinkView>? drink;
  List<WaterView>? water;
  bool isOpen;
  int id;
  String? comment;
  String? expertComment;
  String? time;
  int? dayCalorie;
  int? normCalorie;
  int? calorie;
  List<int> colors;
}

class ClientFoodDiaryListMeal extends StatefulWidget {
  const ClientFoodDiaryListMeal({super.key, required this.selectedDate});
  final DateTime selectedDate;

  @override
  State<ClientFoodDiaryListMeal> createState() => _ClientFoodDiaryListMealState();
}

class _ClientFoodDiaryListMealState extends State<ClientFoodDiaryListMeal> {
  Map<int, ItemMeal> foodDiaryList = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodDiaryBloc, FoodDiaryState>(builder: (context, state) {
      if (state is FoodDiaryGetState) {
        getList(state.food);

        if (foodDiaryList.isNotEmpty) {
          return Column(
            children: [
              ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: foodDiaryList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return FoodDiaryItem(
                    selectedDate: widget.selectedDate,
                    index: index,
                    itemMeal: foodDiaryList.values.toList()[index],
                    numberOfMeal: foodDiaryList.keys.toList()[index],
                  );
                },
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: WidgetButton(
                  colorBorder: AppColors.darkGreenColor,
                  onTap: () {
                    context.router
                        .push(ClientAddFoodRoute(currentFoodPeriod: foodDiaryList.keys.last, selectedDate: widget.selectedDate))
                        .then((value) {
                      if (value == true) {
                        context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(widget.selectedDate));
                        context.read<CalendarForDayBloc>().add(CalendarForDayGetEvent(DateFormat("yyyy-MM-dd").format(DateTime.now())));
                        context.read<SelectedDateBloc>().add(SelectedDateGetEvent(DateTime.now()));
                        context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(DateTime.now()));
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/plus.svg',
                        height: 18.h,
                        color: AppColors.darkGreenColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Добавить приём пищи".toUpperCase(),
                        style: TextStyle(
                          color: AppColors.darkGreenColor,
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: WidgetButton(
                  colorBorder: AppColors.darkGreenColor,
                  onTap: () {
                    context.router.push(ClientAddFoodRoute(currentFoodPeriod: 0, selectedDate: widget.selectedDate)).then((value) {
                      if (value == true) {
                        context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(widget.selectedDate));
                        context.read<CalendarForDayBloc>().add(CalendarForDayGetEvent(DateFormat("yyyy-MM-dd").format(DateTime.now())));
                        context.read<SelectedDateBloc>().add(SelectedDateGetEvent(DateTime.now()));
                        context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(DateTime.now()));
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/plus.svg',
                        height: 18.h,
                        color: AppColors.darkGreenColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Добавить приём пищи".toUpperCase(),
                        style: TextStyle(
                          color: AppColors.darkGreenColor,
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Center(
                  child: Text(
                    "Данные отсутствуют",
                    style: TextStyle(
                      color: AppColors.darkGreenColor,
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }
      return Container();
    });
  }

  getList(List<ClientFoodView>? list) {
    foodDiaryList.clear();

    if (list != null && list.isNotEmpty) {
      list.forEach((item) {
        if (item.foods != null && item.foods!.isNotEmpty) {
          item.foods!.forEach((element) {
            if (element.foodPeriod != null && element.id != null && element.foodTime != null) {
              if (foodDiaryList.isNotEmpty) {
                if (foodDiaryList.containsKey(element.foodPeriod)) {
                  foodDiaryList.forEach((key, value) {
                    if (key == element.foodPeriod) {
                      value.food.add(element);

                      if (element.calories != null) {
                        value.calorie = (value.calorie ?? 0) + element.calories!;
                      }

                      if (element.colors != null && element.colors!.isNotEmpty) {
                        element.colors!.forEach((color) {
                          if (color.id != null && !value.colors.contains(color.id)) {
                            value.colors.add(color.id!);
                          }
                        });
                      }
                    }
                  });
                } else {
                  List<int> tempColors = [];

                  if (element.colors != null && element.colors!.isNotEmpty) {
                    element.colors!.forEach((color) {
                      if (color.id != null && !tempColors.contains(color.id)) {
                        tempColors.add(color.id!);
                      }
                    });
                  }

                  foodDiaryList.putIfAbsent(
                      element.foodPeriod!,
                      () => ItemMeal(
                          food: [element],
                          id: element.id!,
                          drink: [],
                          water: [],
                          colors: tempColors,
                          time: element.foodTime,
                          calorie: element.calories ?? 0,
                          comment: element.comment,
                          expertComment: element.expertComment,
                          dayCalorie: item.dayCalories,
                          normCalorie: item.normCalories));
                }
              } else {
                List<int> tempColors = [];

                if (element.colors != null && element.colors!.isNotEmpty) {
                  element.colors!.forEach((color) {
                    if (color.id != null && !tempColors.contains(color.id)) {
                      tempColors.add(color.id!);
                    }
                  });
                }

                foodDiaryList.putIfAbsent(
                    element.foodPeriod!,
                    () => ItemMeal(
                        food: [element],
                        id: element.id!,
                        drink: [],
                        water: [],
                        colors: tempColors,
                        time: element.foodTime,
                        calorie: element.calories,
                        comment: element.comment,
                        expertComment: element.expertComment,
                        dayCalorie: item.dayCalories,
                        normCalorie: item.normCalories));
              }
            }
          });
        }

        if (item.drinks != null && item.drinks!.isNotEmpty) {
          item.drinks!.forEach((element) {
            if (element.foodPeriod != null) {
              if (foodDiaryList.isNotEmpty) {
                if (foodDiaryList.containsKey(element.foodPeriod)) {
                  foodDiaryList.forEach((key, value) {
                    if (key == element.foodPeriod) {
                      value.drink?.add(element);

                      if (element.calories != null) {
                        value.calorie = (value.calorie ?? 0) + element.calories!;
                      }
                    }
                  });
                } else {
                  foodDiaryList.putIfAbsent(
                    element.foodPeriod!,
                    () => ItemMeal(
                      food: [],
                      id: element.id!,
                      drink: [element],
                      water: [],
                      colors: [],
                      time: element.foodTime,
                      calorie: element.calories ?? 0,
                      comment: element.comment,
                      expertComment: element.expertComment,
                      dayCalorie: item.dayCalories,
                      normCalorie: item.normCalories,
                    ),
                  );
                }
              } else {
                foodDiaryList.putIfAbsent(
                  element.foodPeriod!,
                  () => ItemMeal(
                    food: [],
                    id: element.id!,
                    drink: [element],
                    water: [],
                    colors: [],
                    time: element.foodTime,
                    calorie: element.calories,
                    comment: element.comment,
                    expertComment: element.expertComment,
                    dayCalorie: item.dayCalories,
                    normCalorie: item.normCalories,
                  ),
                );
              }
            }
          });
        }

        if (item.waters != null && item.waters!.isNotEmpty) {
          item.waters!.forEach((element) {
            if (element.foodPeriod != null) {
              if (foodDiaryList.isNotEmpty) {
                if (foodDiaryList.containsKey(element.foodPeriod)) {
                  foodDiaryList.forEach((key, value) {
                    if (key == element.foodPeriod) {
                      value.water?.add(element);

                      if (element.calories != null) {
                        value.calorie = (value.calorie ?? 0) + element.calories!;
                      }
                    }
                  });
                }
              }
            }
          });
        }
      });
    }

    if (foodDiaryList.isNotEmpty) {
      foodDiaryList = SplayTreeMap<int, ItemMeal>.from(foodDiaryList, (a, b) => a.compareTo(b));
    }
  }
}

class FoodDiaryItem extends StatefulWidget {
  FoodDiaryItem({Key? key, required this.itemMeal, required this.numberOfMeal, required this.index, required this.selectedDate})
      : super(key: key);

  ItemMeal itemMeal;
  int numberOfMeal;
  int index;
  DateTime selectedDate;

  @override
  State<FoodDiaryItem> createState() => _FoodDiaryItemState();
}

class _FoodDiaryItemState extends State<FoodDiaryItem> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final storage = FoodDiaryStorage();
  DateTime? time;

  TextEditingController commentController = TextEditingController();
  String commentTextPushed = '';
  bool showButton = false;
  int? commentId;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: 1,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();
    check();
    getTime();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterDiaryBloc, WaterDiaryState>(builder: (context, state) {
      return Padding(
        padding: EdgeInsets.only(
          top: 16.h,
          left: 14.w,
          right: 14.w,
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.itemMeal.isOpen = !widget.itemMeal.isOpen;
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: AnimatedSize(
              duration: Duration(milliseconds: 150),
              curve: Curves.fastOutSlowIn,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.basicwhiteColor.withOpacity(0.8),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      height: 64.h,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/food_diary/eat_${((widget.index + 1) % 4) == 0 ? 4 : (widget.index + 1) % 4}.png'),
                            Container(
                              height: 64.h,
                              width: double.infinity,
                              color: AppColors.basicblackColor.withOpacity(0.5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    getTitle(widget.itemMeal.time),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                      fontFamily: 'Inter',
                                      color: AppColors.basicwhiteColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (widget.itemMeal.calorie != null && widget.itemMeal.calorie != 0)
                                    Row(
                                      children: [
                                        Text(
                                          '${widget.itemMeal.calorie}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24.sp,
                                            fontFamily: 'Inter',
                                            color: AppColors.basicwhiteColor,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'кал',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.sp,
                                            fontFamily: 'Inter',
                                            color: AppColors.basicwhiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(width: 8.w),
                                  Transform.flip(
                                    flipY: widget.itemMeal.isOpen,
                                    child: Transform.rotate(
                                      angle: pi / 2,
                                      child: SvgPicture.asset(
                                        'assets/images/arrow_black.svg',
                                        color: AppColors.basicwhiteColor,
                                        height: 24.h,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: widget.itemMeal.isOpen
                          ? null
                          : FadeTransition(
                              opacity: _animation,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: widget.itemMeal.food.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, item) {
                                        final value = widget.itemMeal.food[item];

                                        return Column(
                                          children: [
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                if (value.foodPhoto != null &&
                                                    value.foodPhoto?.fileBase64 != null &&
                                                    value.foodPhoto?.fileBase64 != "")
                                                  ClipRRect(
                                                    clipBehavior: Clip.hardEdge,
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(8.r),
                                                      bottomRight: Radius.circular(8.r),
                                                    ),
                                                    child: Image.memory(
                                                      base64Decode(value.foodPhoto!.fileBase64!),
                                                      fit: BoxFit.cover,
                                                      height: 63.h,
                                                      width: 120.h,
                                                      alignment: Alignment.center,
                                                    ),
                                                  )
                                                else
                                                  ClipRRect(
                                                    clipBehavior: Clip.hardEdge,
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(8.r),
                                                      bottomRight: Radius.circular(8.r),
                                                    ),
                                                    child: Image.asset(
                                                      'assets/images/salad.webp',
                                                      fit: BoxFit.cover,
                                                      height: 63.h,
                                                      width: 120.h,
                                                    ),
                                                  ),
                                                SizedBox(width: 16.w),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        value.foodName != null ? value.foodName!.capitalize() : "",
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: AppColors.darkGreenColor,
                                                          fontSize: 18.sp,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      Row(
                                                        children: [
                                                          if (value.calories != null && value.calories != 0)
                                                            Container(
                                                              margin: EdgeInsets.only(right: 16.w),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(4.r),
                                                                color: AppColors.lightGreenColor,
                                                              ),
                                                              child: Text(
                                                                '${value.calories} ккал',
                                                                style: TextStyle(
                                                                  fontFamily: 'Inter',
                                                                  color: AppColors.darkGreenColor,
                                                                  fontSize: 14.sp,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              ),
                                                            ),
                                                          if (value.portion != null && value.portion != 0)
                                                            Padding(
                                                              padding: EdgeInsets.only(right: 15.w),
                                                              child: Text(
                                                                getPortion(value.portion, false),
                                                                style: TextStyle(
                                                                  fontFamily: 'Inter',
                                                                  color: AppColors.darkGreenColor,
                                                                  fontSize: 14.sp,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              ),
                                                            ),
                                                          if (value.xe != null && value.xe != 0)
                                                            Text(
                                                              "${value.xe.toString()} XE",
                                                              style: TextStyle(
                                                                fontFamily: 'Inter',
                                                                color: AppColors.darkGreenColor,
                                                                fontSize: 14.sp,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            Container(
                                              width: double.infinity,
                                              height: 1,
                                              color: Color(0xFFDFF9F8),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    SizedBox(height: 8.h),
                                    if (widget.itemMeal.drink != null && widget.itemMeal.drink!.isNotEmpty)
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: widget.itemMeal.drink!.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, item) {
                                          final drink = widget.itemMeal.drink![item];
                                          return Column(
                                            children: [
                                              SizedBox(height: 8.h),
                                              Row(
                                                children: [
                                                  if (drink.foodName != null)
                                                    ClipRRect(
                                                      clipBehavior: Clip.hardEdge,
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(8.r),
                                                        bottomRight: Radius.circular(8.r),
                                                      ),
                                                      child: Image.asset(
                                                        getFoodPhoto(drink.foodName!),
                                                        fit: BoxFit.cover,
                                                        height: 63.h,
                                                        width: 120.h,
                                                      ),
                                                    ),
                                                  SizedBox(width: 16.w),
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          drink.foodName != null ? drink.foodName!.capitalize() : "",
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            color: AppColors.darkGreenColor,
                                                            fontSize: 18.sp,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4.h),
                                                        Row(
                                                          children: [
                                                            if (drink.calories != null)
                                                              Container(
                                                                margin: EdgeInsets.only(right: 16.w),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(4.r),
                                                                  color: AppColors.lightGreenColor,
                                                                ),
                                                                child: Text(
                                                                  '${drink.calories} ккал',
                                                                  style: TextStyle(
                                                                    fontFamily: 'Inter',
                                                                    color: AppColors.darkGreenColor,
                                                                    fontSize: 14.sp,
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            if (drink.portion != null)
                                                              Padding(
                                                                padding: EdgeInsets.only(right: 15.w),
                                                                child: Text(
                                                                  getPortion(drink.portion, true),
                                                                  style: TextStyle(
                                                                    fontFamily: 'Inter',
                                                                    color: AppColors.darkGreenColor,
                                                                    fontSize: 14.sp,
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 6.w),
                                                ],
                                              ),
                                              SizedBox(height: 8.h),
                                              Container(
                                                width: double.infinity,
                                                height: 1,
                                                color: Color(0xFFDFF9F8),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    if (widget.itemMeal.water != null && widget.itemMeal.water!.isNotEmpty)
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: widget.itemMeal.water!.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, item) {
                                          final value = widget.itemMeal.water![item];
                                          return Column(
                                            children: [
                                              SizedBox(height: 8.h),
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    clipBehavior: Clip.hardEdge,
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(8.r),
                                                      bottomRight: Radius.circular(8.r),
                                                    ),
                                                    child: Image.asset(
                                                      getWaterPhoto(value.foodName ?? "Вода"),
                                                      fit: BoxFit.cover,
                                                      height: 63.h,
                                                      width: 120.h,
                                                    ),
                                                  ),
                                                  SizedBox(width: 16.w),
                                                  Flexible(
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(height: 8.h),
                                                            Text(
                                                              value.foodName ?? 'Вода',
                                                              style: TextStyle(
                                                                fontFamily: 'Inter',
                                                                color: AppColors.darkGreenColor,
                                                                fontSize: 18.sp,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            SizedBox(height: 6.h),
                                                            Row(
                                                              children: [
                                                                if (value.portion != null)
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(4.r),
                                                                      color: AppColors.blueSecondaryColor.withOpacity(0.3),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                                                      child: Text(
                                                                        '${value.portion} мл',
                                                                        style: TextStyle(
                                                                          fontFamily: 'Inter',
                                                                          color: AppColors.darkGreenColor,
                                                                          fontSize: 14.sp,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if (value.calories != null && value.calories != 0)
                                                                  Container(
                                                                    margin: EdgeInsets.only(left: 16.w),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(4.r),
                                                                      color: AppColors.lightGreenColor,
                                                                    ),
                                                                    child: Text(
                                                                      '${value.calories} ккал',
                                                                      style: TextStyle(
                                                                        fontFamily: 'Inter',
                                                                        color: AppColors.darkGreenColor,
                                                                        fontSize: 14.sp,
                                                                        fontWeight: FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 6.h),
                                                            if (state is WaterDiaryGetState)
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Осталось: ',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Inter',
                                                                      color: AppColors.seaColor,
                                                                      fontSize: 10.sp,
                                                                      fontWeight: FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 5.w),
                                                                  Text(
                                                                    "${getLostWater(state)} литра",
                                                                    style: TextStyle(
                                                                      fontFamily: 'Inter',
                                                                      color: AppColors.darkGreenColor,
                                                                      fontSize: 10.sp,
                                                                      fontWeight: FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            SizedBox(height: 4.h)
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.h),
                                              Container(
                                                width: double.infinity,
                                                height: 1,
                                                color: Color(0xFFDFF9F8),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    if (widget.itemMeal.colors.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 15.h),
                                            Row(
                                              children: [
                                                Text(
                                                  'Радуга\nфитонутриентов',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp,
                                                    fontFamily: 'Inter',
                                                    color: AppColors.darkGreenColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                                                    final double maxWidth = constraints.maxWidth;

                                                    double lastItemWidth = (widget.itemMeal.colors.length - 1) * 44.w + 56.r;
                                                    return Stack(
                                                      alignment: Alignment.centerRight,
                                                      children: [
                                                        for (var item in widget.itemMeal.colors)
                                                          Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                right:
                                                                    // индекс элемента
                                                                    widget.itemMeal.colors.indexOf(item) *
                                                                        // если lastItemWidth больше чем места то уменьшаем отспут справа
                                                                        // берем место которое не хватает и разделеям это на каждый отспуп у элемента
                                                                        (44.w -
                                                                            (maxWidth < lastItemWidth
                                                                                ? (lastItemWidth - maxWidth) /
                                                                                    (widget.itemMeal.colors.length - 1)
                                                                                : 0)),
                                                              ),
                                                              child: Container(
                                                                height: 56.r,
                                                                width: 56.r,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(56),
                                                                  color: AppColors.basicwhiteColor,
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(2),
                                                                  child: ClipRRect(
                                                                    clipBehavior: Clip.hardEdge,
                                                                    borderRadius: BorderRadius.circular(56),
                                                                    child: Image.asset(
                                                                      getColorsImage(item),
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                      ],
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (widget.itemMeal.comment != null) SizedBox(height: 18.h),
                                    if (widget.itemMeal.comment != null)
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: CustomTextFieldLabel(
                                          controller: TextEditingController(text: widget.itemMeal.comment),
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 15,
                                          enabled: false,
                                          backGroudColor: AppColors.lightGreenColor,
                                          labelColor: AppColors.vivaMagentaColor,
                                          hintColor: AppColors.darkGreenColor,
                                          labelText: 'Аппетит, стул, энергия',
                                          hintText: 'Введите текст',
                                        ),
                                      ),
                                    if (widget.itemMeal.expertComment != null) SizedBox(height: 18.h),
                                    if (widget.itemMeal.expertComment != null)
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: CustomTextFieldLabel(
                                          controller: TextEditingController(text: getExpertCommentText(widget.itemMeal.expertComment)),
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 15,
                                          enabled: false,
                                          backGroudColor: AppColors.lightGreenColor,
                                          labelColor: AppColors.vivaMagentaColor,
                                          hintColor: AppColors.darkGreenColor,
                                          labelText: getExpertCommentTitle(widget.itemMeal.expertComment),
                                        ),
                                      ),
                                    SizedBox(height: 24.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              width: double.infinity,
                                              height: 49.h,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4.r),
                                                border: Border.all(width: 1, color: AppColors.vivaMagentaColor),
                                              ),
                                              child: FormForButton(
                                                borderRadius: BorderRadius.circular(8.r),
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return DeleteDialog();
                                                    },
                                                  ).then((value) {
                                                    if (value == true) {
                                                      context.loaderOverlay.show();

                                                      final service = FoodDiaryService();
                                                      bool isError = false;

                                                      if (widget.itemMeal.food.isNotEmpty) {
                                                        widget.itemMeal.food.forEach((element) async {
                                                          if (element.id != null) {
                                                            final response = await service.deleteFoodDiary(element.id!);

                                                            if (!response.result) {
                                                              isError = true;
                                                            }
                                                          }
                                                        });
                                                      }

                                                      if (widget.itemMeal.drink != null && widget.itemMeal.drink!.isNotEmpty) {
                                                        widget.itemMeal.drink!.forEach((element) async {
                                                          if (element.id != null) {
                                                            final response = await service.deleteFoodDiary(element.id!);

                                                            if (!response.result) {
                                                              isError = true;
                                                            }
                                                          }
                                                        });
                                                      }

                                                      if (widget.itemMeal.water != null && widget.itemMeal.water!.isNotEmpty) {
                                                        widget.itemMeal.water!.forEach((element) async {
                                                          if (element.id != null) {
                                                            final response = await service.deleteFoodDiary(element.id!);

                                                            if (!response.result) {
                                                              isError = true;
                                                            }
                                                          }
                                                        });
                                                      }

                                                      if (isError) {
                                                        context.loaderOverlay.hide();
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            duration: Duration(seconds: 3),
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
                                                      } else {
                                                        Future.delayed(Duration(milliseconds: 3000), () {
                                                          context.loaderOverlay.hide();
                                                          context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(widget.selectedDate));
                                                          context
                                                              .read<CalendarForDayBloc>()
                                                              .add(CalendarForDayGetEvent(DateFormat("yyyy-MM-dd").format(DateTime.now())));
                                                          context.read<SelectedDateBloc>().add(SelectedDateGetEvent(DateTime.now()));
                                                        });
                                                      }
                                                    }
                                                  });
                                                },
                                                child: Center(
                                                  child: Text(
                                                    "Удалить".toUpperCase(),
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: AppColors.vivaMagentaColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          Expanded(
                                            child: Container(
                                              width: double.infinity,
                                              height: 49.h,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4.r),
                                                border: Border.all(width: 1, color: AppColors.darkGreenColor),
                                              ),
                                              child: FormForButton(
                                                borderRadius: BorderRadius.circular(8.r),
                                                onPressed: () {
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
                                                      title: 'Прием пищи №${widget.numberOfMeal}',
                                                      icon: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(right: 10.w),
                                                          child: IconButton(
                                                            icon: Icon(Icons.add, color: AppColors.darkGreenColor),
                                                            onPressed: () {
                                                              context.router
                                                                  .push(ClientAddFoodRoute(
                                                                      date: time,
                                                                      currentFoodPeriod: widget.numberOfMeal - 1,
                                                                      selectedDate: widget.selectedDate))
                                                                  .then((value) {
                                                                if (value == true) {
                                                                  context.router.maybePop();
                                                                  context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(widget.selectedDate));
                                                                  context.read<CalendarForDayBloc>().add(CalendarForDayGetEvent(
                                                                      DateFormat("yyyy-MM-dd").format(DateTime.now())));
                                                                  context
                                                                      .read<SelectedDateBloc>()
                                                                      .add(SelectedDateGetEvent(DateTime.now()));
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      content: ClientFoodDiaryChangeSheet(
                                                        index: widget.index,
                                                        selectedDate: widget.selectedDate,
                                                        itemMeal: widget.itemMeal,
                                                        numberOfMeal: widget.numberOfMeal,
                                                      ),
                                                    ),
                                                  ).then((value) {
                                                    if (value == true) {
                                                      context.read<FoodDiaryBloc>().add(FoodDiaryGetEvent(widget.selectedDate));
                                                      context
                                                          .read<CalendarForDayBloc>()
                                                          .add(CalendarForDayGetEvent(DateFormat("yyyy-MM-dd").format(DateTime.now())));
                                                      context.read<SelectedDateBloc>().add(SelectedDateGetEvent(DateTime.now()));
                                                    }
                                                  });
                                                },
                                                child: Center(
                                                  child: Text(
                                                    "изменить".toUpperCase(),
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: AppColors.darkGreenColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 18.h),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  String getExpertCommentTitle(String? comment) {
    if (comment != null && comment.contains(";")) {
      String newString = comment.substring(0, comment.indexOf(";"));
      return "Комментарий специалиста - $newString";
    }
    return "Комментарий специалиста";
  }

  String getExpertCommentText(String? comment) {
    if (comment != null && comment.contains(";")) {
      String newString = comment.substring(comment.indexOf(";"));
      String newString2 = newString.substring(2);
      return newString2;
    }
    return "";
  }

  String getWaterPhoto(String? name) {
    if (name == null || name == 'Вода') {
      return 'assets/images/drink/water/big_water_add_water.webp';
    } else if (name == 'Вода с лимоном') {
      return 'assets/images/drink/water/big_water_add_lemon.webp';
    } else if (name == 'Вода с ягодами') {
      return 'assets/images/drink/water/water_add_berries.webp';
    } else if (name == 'Вода с имбирем') {
      return 'assets/images/drink/water/water_add_ginger.webp';
    } else {
      return 'assets/images/drink/water/big_water_add_minеral.webp';
    }
  }

  String getColorsImage(int id) {
    if (id == 1) {
      return "assets/images/red.webp";
    } else if (id == 2) {
      return "assets/images/orange.webp";
    } else if (id == 3) {
      return "assets/images/green.webp";
    } else if (id == 4) {
      return "assets/images/blue_purple.webp";
    } else if (id == 5) {
      return "assets/images/brown.webp";
    } else if (id == 6) {
      return "assets/images/white.webp";
    }
    return "assets/images/red.webp";
  }

  int calculatePercent(int? dayVal, int? dayTarget) {
    if (dayVal != null) {
      if (dayTarget != null && dayTarget != 0) {
        int value = (dayVal * 100) ~/ dayTarget;
        if (value > 0) {
          return value;
        } else {
          return 0;
        }
      } else {
        int value = (dayVal * 100) ~/ 2000;
        if (value > 0) {
          return value;
        } else {
          return 0;
        }
      }
    } else {
      return 0;
    }
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

  String getFoodPhoto(String? foodName) {
    if (foodName != null) {
      final list = storage.listOfItemDrink;

      ItemDrink? itemDrink;

      list.forEach((element) {
        if (element.title == foodName) {
          itemDrink = element;
        } else {
          element.addsList.forEach((item) {
            if (item.subList != null && item.subList!.isNotEmpty) {
              item.subList!.forEach((sublist) {
                if (sublist.text == foodName && item.image != null) {
                  itemDrink = ItemDrink(image: item.image!, title: sublist.text, calorie: sublist.calorie.toDouble(), addsList: []);
                }
              });
            }

            if (item.title == foodName) {
              itemDrink = element;
            }
          });
        }
      });

      return itemDrink != null ? itemDrink!.image : 'assets/images/salad.webp';
    }
    return 'assets/images/salad.webp';
  }

  String getPortion(int? portion, bool? isDrink) {
    if (portion != null && isDrink != null) {
      if (isDrink) {
        return "$portion мл";
      } else {
        return "$portion гр";
      }
    }
    return "";
  }

  getTitle(String? foodTime) {
    if (foodTime != null) {
      DateTime newDate = DateTime.parse(foodTime);
      String newFormat = DateFormat("HH:mm").format(newDate);

      return 'Приём пищи  $newFormat ';
    }
    return 'Приём пищи';
  }

  check() {
    if (widget.itemMeal.comment != null) {
      setState(() {
        commentController = TextEditingController(text: widget.itemMeal.comment!);
      });
    }
  }

  getTime() {
    if (widget.itemMeal.food.isNotEmpty) {
      widget.itemMeal.food.forEach((element) {
        if (element.foodTime != null) {
          DateTime date = DateTime.parse(element.foodTime!);
          setState(() {
            time = date;
          });
        }
      });
    }

    if (widget.itemMeal.drink != null && widget.itemMeal.drink!.isNotEmpty && time == null) {
      widget.itemMeal.drink!.forEach((element) {
        if (element.foodTime != null) {
          DateTime date = DateTime.parse(element.foodTime!);
          setState(() {
            time = date;
          });
        }
      });
    }
  }
}
