import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/client/food_diary/food_diary_service.dart';
import 'package:garnetbook/ui/client_category/food_diary/components/client_food_diary_list_meal.dart';
import 'package:garnetbook/ui/client_category/water/bottom_sheets/client_water_add_sheet.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/extension/string_externsions.dart';
import 'package:garnetbook/data/repository/food_diary_storage.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/dialogs/delete_dialog.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ClientFoodDiaryChangeSheet extends StatefulWidget {
  final ItemMeal itemMeal;
  final int numberOfMeal;
  final int index;
  final DateTime selectedDate;

  const ClientFoodDiaryChangeSheet(
      {super.key, required this.itemMeal, required this.numberOfMeal, required this.index, required this.selectedDate});

  @override
  State<ClientFoodDiaryChangeSheet> createState() => _ClientFoodDiaryChangeSheetState();
}

class _ClientFoodDiaryChangeSheetState extends State<ClientFoodDiaryChangeSheet> {
  final foodDiaryStorage = FoodDiaryStorage();

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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
                    if (widget.itemMeal.food.isNotEmpty)
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.itemMeal.food.length,
                          itemBuilder: (context, index) {
                            final value = widget.itemMeal.food[index];

                            return GestureDetector(
                              onTap: () {
                                if (value.id != null) {
                                  final item = ItemMeal(
                                      food: [value],
                                      id: value.id!,
                                      drink: [],
                                      water: [],
                                      colors: [],
                                      time: value.foodTime,
                                      calorie: value.calories,
                                      comment: value.comment,
                                      dayCalorie: 0,
                                      normCalorie: 0);

                                  context.router
                                      .push(ClientFoodDiaryEditFoodRoute(
                                          view: item, numberOfMeal: widget.numberOfMeal, selectedDate: widget.selectedDate))
                                      .then((value) {
                                    if (value == true) {
                                      context.router.maybePop(true);
                                    }
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                padding: EdgeInsets.only(bottom: 16.h),
                                decoration: BoxDecoration(
                                  color: AppColors.basicwhiteColor,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.limeColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    if (value.foodPhoto != null && value.foodPhoto?.fileBase64 != null && value.foodPhoto?.fileBase64 != "")
                                      Image.memory(
                                        base64Decode(value.foodPhoto!.fileBase64!),
                                        fit: BoxFit.cover,
                                        height: 60.h,
                                        width: 120.h,
                                        alignment: Alignment.center,
                                      )
                                    else
                                      Image.asset(
                                        'assets/images/salad.webp',
                                        fit: BoxFit.cover,
                                        height: 60.h,
                                        width: 120.h,
                                      ),
                                    SizedBox(width: 12.w),
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
                                                  margin: EdgeInsets.only(right: 12.w),
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
                                                  padding: EdgeInsets.only(right: 12.w),
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
                                            ],
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
                                    ),
                                    SizedBox(width: 8.w),
                                    FormForButton(
                                      borderRadius: BorderRadius.circular(20),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DeleteDialog();
                                          },
                                        ).then((val) async {
                                          if (val == true && value.id != null) {
                                            context.loaderOverlay.show();

                                            final service = FoodDiaryService();
                                            bool isError = false;

                                            final response = await service.deleteFoodDiary(value.id!);

                                            if (!response.result) {
                                              isError = true;
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
                                              GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.deleteFoodDiaryClient);

                                              Future.delayed(Duration(milliseconds: 2000), () {
                                                context.loaderOverlay.hide();
                                                context.router.maybePop(true);
                                              });
                                            }
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: SvgPicture.asset(
                                          'assets/images/trash.svg',
                                          width: 20.w,
                                          color: AppColors.vivaMagentaColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    if (widget.itemMeal.drink != null && widget.itemMeal.drink!.isNotEmpty)
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.itemMeal.drink!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (widget.itemMeal.drink![index].id != null) {
                                  int drinkId = getDrinkId(widget.itemMeal.drink![index].foodName!);

                                  context.router
                                      .push(ClientFoodDiaryAddDrinkSecondRoute(
                                          indexChosenDrink: drinkId, view: widget.itemMeal.drink![index]))
                                      .then((value) {
                                    if (value == true) {
                                      context.router.maybePop(true);
                                    }
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                padding: EdgeInsets.only(bottom: 16.h),
                                decoration: BoxDecoration(
                                  color: AppColors.basicwhiteColor,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.limeColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      getDrinkPhoto(widget.itemMeal.drink![index].foodName),
                                      fit: BoxFit.cover,
                                      height: 60.h,
                                      width: 120.h,
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.itemMeal.drink![index].foodName!.capitalize(),
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: AppColors.darkGreenColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4.r),
                                                  color: AppColors.blueSecondaryColor.withOpacity(0.3),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                                  child: Text(
                                                    "${widget.itemMeal.drink![index].portion} мл",
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: AppColors.darkGreenColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 16.w),
                                              if (widget.itemMeal.drink![index].calories != null)
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4.r),
                                                    color: AppColors.limeColor,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                                    child: Text(
                                                      "${widget.itemMeal.drink![index].calories} ккал",
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: AppColors.darkGreenColor,
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    FormForButton(
                                      borderRadius: BorderRadius.circular(20),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DeleteDialog();
                                          },
                                        ).then((value) async {
                                          if (value == true && widget.itemMeal.drink![index].id != null) {
                                            context.loaderOverlay.show();

                                            final service = FoodDiaryService();
                                            bool isError = false;

                                            final response = await service.deleteFoodDiary(widget.itemMeal.drink![index].id!);

                                            if (!response.result) {
                                              isError = true;
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
                                              Future.delayed(Duration(milliseconds: 2000), () {
                                                context.loaderOverlay.hide();
                                                context.router.maybePop(true);
                                              });
                                            }
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: SvgPicture.asset(
                                          'assets/images/trash.svg',
                                          width: 20.w,
                                          color: AppColors.vivaMagentaColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    if (widget.itemMeal.water != null && widget.itemMeal.water!.isNotEmpty)
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.itemMeal.water!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (widget.itemMeal.water![index].id != null && widget.itemMeal.water![index].foodPeriod != null)
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
                                      title: 'Редактировать',
                                      content: ClientWaterAddSheet(
                                        target: 2000,
                                        isFromFoodDiary: true,
                                        water: widget.itemMeal.water![index],
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value == true) {
                                      context.router.maybePop(true);
                                    }
                                  });
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                padding: EdgeInsets.only(bottom: 16.h),
                                decoration: BoxDecoration(
                                  color: AppColors.basicwhiteColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.limeColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      getWaterPhoto(widget.itemMeal.water![index].foodName),
                                      fit: BoxFit.cover,
                                      height: 60.h,
                                      width: 120.w,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.itemMeal.water![index].foodName ?? "Вода",
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
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(4.r),
                                                      color: AppColors.blueSecondaryColor.withOpacity(0.3),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                                      child: Text(
                                                        '${widget.itemMeal.water![index].portion ?? 0} мл',
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: AppColors.darkGreenColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 16.w),
                                                  if (widget.itemMeal.water![index].calories != null &&
                                                      widget.itemMeal.water![index].calories != 0)
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(4.r),
                                                        color: AppColors.limeColor,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                                        child: Text(
                                                          "${widget.itemMeal.water![index].calories} ккал",
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            color: AppColors.darkGreenColor,
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    FormForButton(
                                      borderRadius: BorderRadius.circular(20),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DeleteDialog();
                                          },
                                        ).then((value) async {
                                          if (value == true && widget.itemMeal.water![index].id != null) {
                                            context.loaderOverlay.show();

                                            final service = FoodDiaryService();
                                            bool isError = false;

                                            final response = await service.deleteFoodDiary(widget.itemMeal.water![index].id!);

                                            if (!response.result) {
                                              isError = true;
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
                                              Future.delayed(Duration(milliseconds: 2000), () {
                                                context.loaderOverlay.hide();
                                                context.router.maybePop(true);
                                              });
                                            }
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: SvgPicture.asset(
                                          'assets/images/trash.svg',
                                          width: 20.w,
                                          color: AppColors.vivaMagentaColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int getDrinkId(String foodName) {
    for (int index = 0; index < foodDiaryStorage.listOfItemDrink.length; index++) {
      final element = foodDiaryStorage.listOfItemDrink[index];

      if (element.title == foodName) {
        return index;
      }

      if (element.addsList.isNotEmpty) {
        for (var item in element.addsList) {
          if (item.title == foodName) {
            return index;
          }

          if (item.subList != null && item.subList!.isNotEmpty) {
            for (var subitem in item.subList!) {
              if (subitem.text == foodName) {
                return index;
              }
            }
          }
        }
      }
    }
    return 0;
  }

  String getDrinkPhoto(String? foodName) {
    if (foodName != null) {
      final list = foodDiaryStorage.listOfItemDrink;

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

  String getWaterPhoto(String? name) {
    if (name == null || name == 'Вода') {
      return 'assets/images/drink/water/big_water_add_water.png';
    } else if (name == 'Вода с лимоном') {
      return 'assets/images/drink/water/big_water_add_lemon.png';
    } else if (name == 'Вода с ягодами') {
      return 'assets/images/drink/water/water_add_berries.png';
    } else if (name == 'Вода с имбирем') {
      return 'assets/images/drink/water/water_add_ginger.png';
    } else {
      return 'assets/images/drink/water/big_water_add_minеral.png';
    }
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
}
