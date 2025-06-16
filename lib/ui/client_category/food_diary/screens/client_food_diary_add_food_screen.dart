import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/water_diary/water_diary_bloc.dart';
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:garnetbook/data/models/client/food_diary/food_create_model.dart';
import 'package:garnetbook/data/models/client/food_diary/food_diary_model.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/client/food_diary/food_diary_service.dart';
import 'package:garnetbook/domain/services/client/water_diary/water_diary_service.dart';
import 'package:garnetbook/ui/client_category/food_diary/bottom_sheets/client_food_diary_bread_info_sheet.dart';
import 'package:garnetbook/ui/client_category/food_diary/bottom_sheets/client_food_diary_composition_of_products_sheet.dart';
import 'package:garnetbook/ui/client_category/food_diary/bottom_sheets/client_food_diary_pick_image_sheet.dart';
import 'package:garnetbook/ui/client_category/food_diary/bottom_sheets/client_food_diary_size_portion_sheet.dart';
import 'package:garnetbook/ui/client_category/water/bottom_sheets/client_water_add_sheet.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/extension/string_externsions.dart';
import 'package:garnetbook/data/repository/food_diary_storage.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class ClientAddFoodScreen extends StatefulWidget {
  const ClientAddFoodScreen({super.key, required this.currentFoodPeriod, this.date, required this.selectedDate});

  final int currentFoodPeriod;
  final DateTime? date;
  final DateTime selectedDate;

  @override
  State<ClientAddFoodScreen> createState() => _ClientAddFoodScreenState();
}

class _ClientAddFoodScreenState extends State<ClientAddFoodScreen> {
  final service = FoodDiaryService();
  final waterService = WaterDiaryService();
  final foodDiaryStorage = FoodDiaryStorage();

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPortion = TextEditingController();
  TextEditingController controllerCalories = TextEditingController();
  TextEditingController controllerTime = TextEditingController(text: DateFormat("HH:mm").format(DateTime.now()));
  TextEditingController controllerXe = TextEditingController();
  TextEditingController controllerComment = TextEditingController();

  List<int> foodColors = [];
  bool XE = false;
  File? foodPhoto;
  bool validation = false;
  DateTime selectedDate = DateTime.now();

  List<WaterView> waterList = [];
  List<Drink> drinkList = [];

  check() {
    setState(() {
      selectedDate = widget.selectedDate;

      if (selectedDate.hour == 0 && selectedDate.minute == 0) {
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, DateTime.now().hour, DateTime.now().minute);
      }
    });

    if (widget.date != null) {
      setState(() {
        controllerTime.text = DateFormat("HH:mm").format(widget.date!);
      });
    }
  }

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerCalories.dispose();
    controllerPortion.dispose();
    controllerXe.dispose();
    controllerComment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.basicwhiteColor,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Column(
                    children: [
                      SizedBox(height: 56.h + 20.h),
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.grey20Color,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: FormForButton(
                          borderColor: null,
                          borderRadius: BorderRadius.circular(4.r),
                          onPressed: () async {
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
                                title: 'Добавить фотографию еды',
                                content: ClientFoodDiaryPickImageSheet(),
                              ),
                            ).then((value) async {
                              FocusManager.instance.primaryFocus?.unfocus();

                              if (value != null) {
                                setState(() {
                                  foodPhoto = value;
                                });
                              }
                            });
                          },
                          child: SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: getFoodPhoto(),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      CustomTextFieldLabel(
                        isLast: false,
                        controller: controllerName,
                        multiLines: true,
                        maxLines: 3,
                        maxLength: 80,
                        backGroudColor: AppColors.lightGreenColor,
                        labelColor: AppColors.vivaMagentaColor,
                        labelText: 'Описание',
                        borderColor: AppColors.seaColor,
                        onChanged: (val) {
                          if (validation) {
                            setState(() {
                              validation = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
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
                                  title: 'Размер порции',
                                  content: ClientFoodDiarySizePortionSheet(),
                                ),
                              ).then((value) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (value != null) {
                                  setState(() {
                                    controllerPortion.text = value.toString();
                                  });
                                }
                              });
                            },
                            child: SizedBox(
                              width: 157.w,
                              child: CustomTextFieldLabel(
                                isLast: false,
                                controller: controllerPortion,
                                enabled: false,
                                onChanged: (val) {
                                  if (validation) {
                                    setState(() {
                                      validation = false;
                                    });
                                  }
                                },
                                maxLength: 4,
                                suffixText: MediaQuery.of(context).textScaleFactor > 1.1 ? ' гр  ' : ' гр     ',
                                backGroudColor: AppColors.lightGreenColor,
                                labelColor: AppColors.vivaMagentaColor,
                                labelText: 'Порция',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 157.w,
                            child: CustomTextFieldLabel(
                              isLast: true,
                              keyboardType: TextInputType.number,
                              multiLines: false,
                              suffixText: MediaQuery.of(context).textScaleFactor > 1.1 ? ' ккал' : ' ккал     ',
                              listMaskTextInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))],
                              onChanged: (val) {
                                if (validation) {
                                  setState(() {
                                    validation = false;
                                  });
                                }
                              },
                              maxLength: 4,
                              controller: controllerCalories,
                              backGroudColor: AppColors.lightGreenColor,
                              labelColor: AppColors.vivaMagentaColor,
                              labelText: 'Калорийность',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => DatePickerBdaya.showTimePicker(
                              showSecondsColumn: false,
                              context,
                              showTitleActions: true,
                              onConfirm: (dateVal) {
                                setState(() {
                                  controllerTime.text = DateFormat("HH:mm").format(dateVal);
                                  selectedDate = dateVal;

                                  if (validation) {
                                    validation = false;
                                  }
                                });
                              },
                              currentTime: selectedDate.hour == 0 && selectedDate.minute == 0
                                  ? DateTime(
                                      selectedDate.year, selectedDate.month, selectedDate.day, DateTime.now().hour, DateTime.now().minute)
                                  : selectedDate,
                              locale: LocaleType.ru,
                            ),
                            child: SizedBox(
                              width: 157.w,
                              child: CustomTextFieldLabel(
                                isLast: false,
                                controller: controllerTime,
                                enabled: false,
                                backGroudColor: AppColors.lightGreenColor,
                                labelColor: AppColors.vivaMagentaColor,
                                labelText: 'Время приема',
                                borderColor: validation && controllerTime.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.seaColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 157.w,
                            child: CustomTextFieldLabel(
                              isLast: true,
                              keyboardType: TextInputType.number,
                              multiLines: false,
                              controller: controllerXe,
                              backGroudColor: AppColors.lightGreenColor,
                              labelColor: AppColors.vivaMagentaColor,
                              labelText: 'ХЕ',
                              maxLength: 3,
                              onChanged: (v) {
                                if (validation) {
                                  setState(() {
                                    validation = false;
                                  });
                                }
                              },
                              listMaskTextInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))],
                              icon: GestureDetector(
                                onTap: () {
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
                                      title: 'Хлебные еденицы',
                                      content: ClientFoodDiaryBreadInfoSheet(),
                                    ),
                                  ).then((v) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    color: AppColors.vivaMagentaColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: SvgPicture.asset(
                                      'assets/images/info.svg',
                                      height: 16.h,
                                      width: 16.w,
                                      color: AppColors.basicwhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Опишите ваши ощущения',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextFieldLabel(
                        controller: controllerComment,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        maxLength: 150,
                        backGroudColor: AppColors.lightGreenColor,
                        labelColor: AppColors.vivaMagentaColor,
                        hintColor: AppColors.darkGreenColor,
                        labelText: 'Аппетит, стул, энергия',
                        hintText: 'Введите текст',
                        onChanged: (v) {
                          if (validation) {
                            setState(() {
                              validation = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
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
                                  title: 'Добавить воду',
                                  content: ClientWaterAddSheet(
                                    target: 2000,
                                    isFromFoodDiary: true,
                                  ),
                                ),
                              ).then((value) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (value != null) {
                                  setState(() {
                                    waterList.add(value as WaterView);
                                  });
                                }
                              });
                            },
                            child: Image.asset(
                              'assets/images/drink/add_water.png',
                              width: 160.w,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              context.router.push(ClientFoodDiaryAddDrinkRoute()).then((value) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (value != null) {
                                  setState(() {
                                    drinkList.add(value as Drink);
                                  });
                                }
                              });
                            },
                            child: Image.asset(
                              'assets/images/drink/add_drink.png',
                              width: 160.w,
                            ),
                          ),
                        ],
                      ),
                      if (drinkList.isNotEmpty || waterList.isNotEmpty) SizedBox(height: 16.h),
                      if (drinkList.isNotEmpty || waterList.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            getWaterDrinksTitle(),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      SizedBox(height: 16.h),
                      if (drinkList.isNotEmpty)
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: drinkList.length,
                            itemBuilder: (context, index) {
                              return Container(
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
                                      getDrinkPhoto(drinkList[index].foodName),
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
                                            drinkList[index].foodName!.capitalize(),
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
                                                    "${drinkList[index].portion} мл",
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
                                              if (drinkList[index].calories != null)
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4.r),
                                                    color: AppColors.limeColor,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                                    child: Text(
                                                      "${drinkList[index].calories} ккал",
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
                                        setState(() {
                                          drinkList.removeAt(index);
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: SvgPicture.asset(
                                          'assets/images/trash.svg',
                                          width: 20.w,
                                          color: AppColors.darkGreenColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      if (waterList.isNotEmpty)
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: waterList.length,
                            itemBuilder: (context, index) {
                              return Container(
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
                                      getWaterPhoto(waterList[index].foodName),
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
                                                waterList[index].foodName ?? "Вода",
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
                                                        '${waterList[index].portion ?? 0} мл',
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
                                                  if (waterList[index].calories != null && waterList[index].calories != 0)
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(4.r),
                                                        color: AppColors.limeColor,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                                        child: Text(
                                                          "${waterList[index].calories} ккал",
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
                                        setState(() {
                                          waterList.removeAt(index);
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: SvgPicture.asset(
                                          'assets/images/trash.svg',
                                          width: 20.w,
                                          color: AppColors.darkGreenColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      SizedBox(height: 16.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Радуга фитонутриентов',
                          style: TextStyle(
                            color: AppColors.darkGreenColor,
                            fontSize: 18.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: AppColors.seaColor,
                      ),
                      ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: foodDiaryStorage.listOfItemColor.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final ItemColor itemColor = foodDiaryStorage.listOfItemColor[index];

                          return Padding(
                            padding: EdgeInsets.only(top: 16.h),
                            child: Container(
                              height: 56.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: FormForButton(
                                borderRadius: BorderRadius.circular(8.r),
                                onPressed: () {
                                  setState(() {
                                    itemColor.isChoose = !itemColor.isChoose;
                                  });

                                  if (!foodColors.contains(foodDiaryStorage.listOfItemColor[index].id)) {
                                    foodColors.add(foodDiaryStorage.listOfItemColor[index].id);
                                  } else {
                                    foodColors.remove(foodDiaryStorage.listOfItemColor[index].id);
                                  }
                                  if (validation) {
                                    validation = false;
                                  }
                                },
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Image.asset(
                                        fit: BoxFit.cover,
                                        'assets/images/${itemColor.imageName}.webp',
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            AppColors.basicblackColor.withOpacity(0.8),
                                            AppColors.basicblackColor.withOpacity(0),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
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
                                                  color: AppColors.basicwhiteColor,
                                                  image: 'assets/images/${itemColor.imageName}.webp',
                                                  title: '${itemColor.text} (состав продуктов)',
                                                  content: ClientFoodDiaryCompositionOfProductsSheet(
                                                    listOfProducts: itemColor.listOfProducts,
                                                  ),
                                                ),
                                              ).then((v) {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              'assets/images/info.svg',
                                              height: 24.h,
                                              width: 24.w,
                                              color: AppColors.basicwhiteColor,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  itemColor.text,
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Inter',
                                                    color: AppColors.basicwhiteColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          CircleAvatar(
                                            radius: 12.r,
                                            backgroundColor: AppColors.lightGreenColor,
                                            child: itemColor.isChoose
                                                ? SvgPicture.asset(
                                                    'assets/images/checkmark.svg',
                                                    height: 16.h,
                                                    width: 16.w,
                                                    color: Colors.black,
                                                  )
                                                : null,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        children: [
                          Expanded(
                            child: WidgetButton(
                              onTap: () {
                                context.router.maybePop();
                              },
                              color: AppColors.lightGreenColor,
                              child: Text(
                                'ОТМЕНА',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 24.w),
                          Expanded(
                            child: WidgetButton(
                              onTap: () async {
                                FocusScope.of(context).unfocus();

                                if ((controllerTime.text.isNotEmpty && drinkList.isNotEmpty) ||
                                    (controllerTime.text.isNotEmpty && controllerName.text.isNotEmpty)) {

                                  context.loaderOverlay.show();

                                  String format = "";
                                  String imageName = "";
                                  String imageBase64 = "";

                                  if (foodPhoto != null && foodPhoto?.isAbsolute == true) {
                                    Uint8List? result = await FlutterImageCompress.compressWithFile(
                                      foodPhoto!.absolute.path,
                                      minHeight: 1080,
                                      minWidth: 1080,
                                      quality: 96,
                                      format: CompressFormat.webp,
                                    );

                                    if (result != null) {
                                      imageBase64 = base64.encode(result);

                                      String s = foodPhoto!.path;
                                      var pos = s.lastIndexOf('.');
                                      String resultName = (pos != -1) ? s.substring(pos) : s;
                                      format = resultName.substring(1);

                                      imageName = "user_food_diary";
                                    }
                                  }

                                  List<Drink> selectedDrinks = [];
                                  List<Water> selectedWaters = [];

                                  if (drinkList.isNotEmpty) {
                                    drinkList.forEach((element) {
                                      selectedDrinks.add(Drink(
                                          portion: element.portion,
                                          calories: element.calories,
                                          foodPeriod: widget.currentFoodPeriod + 1,
                                          foodName: element.foodName,
                                          foodTime: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate),
                                          comment: controllerComment.text.isNotEmpty ? controllerComment.text : null));
                                    });
                                  }

                                  if (waterList.isNotEmpty) {
                                    waterList.forEach((element) {
                                      selectedWaters.add(Water(
                                        foodName: element.foodName ?? "Вода",
                                        calories: element.calories,
                                        portion: element.portion,
                                        foodPeriod: widget.currentFoodPeriod + 1,
                                        foodTime: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate),
                                      ));
                                    });
                                  }

                                  final response = await service.addFoodDiary(ClientFoodCreateRequest(
                                    foods: controllerName.text.isNotEmpty
                                        ? [
                                            Food(
                                              comment: controllerComment.text.isNotEmpty ? controllerComment.text : null,
                                              calories: controllerCalories.text.isNotEmpty ? int.parse(controllerCalories.text) : null,
                                              foodColors: foodColors != [] ? foodColors : null,
                                              foodName: controllerName.text.isNotEmpty ? controllerName.text.capitalize() : null,
                                              foodTime: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate),
                                              foodPeriod: widget.currentFoodPeriod + 1,
                                              photo: foodPhoto != null && foodPhoto?.isAbsolute == true
                                                  ? ImageView(format: format, name: imageName, base64: imageBase64)
                                                  : null,
                                              xe: controllerXe.text.isNotEmpty ? int.parse(controllerXe.text) : null,
                                              portion: controllerPortion.text.isNotEmpty ? int.parse(controllerPortion.text) : null,
                                            )
                                          ]
                                        : null,
                                    drinks: selectedDrinks.isNotEmpty ? selectedDrinks : null,
                                    waters: selectedWaters.isNotEmpty ? selectedWaters : null,
                                  ));

                                  if (response.result) {
                                    GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.addFoodDiaryClient);

                                    context.loaderOverlay.hide();
                                    context.router.maybePop(true);
                                  } else {
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
                                  }
                                } else {
                                  setState(() {
                                    validation = true;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                        'Добавьте еду(описание) или напиток; время приема',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              color: AppColors.darkGreenColor,
                              child: Text(
                                'добавить'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                  color: AppColors.basicwhiteColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
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
                          'Добавить прием пищи',
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
    } else if (name == 'Вода с ягодама') {
      return 'assets/images/drink/water/water_add_berries.png';
    } else if (name == 'Вода с имбирем') {
      return 'assets/images/drink/water/water_add_ginger.png';
    } else {
      return 'assets/images/drink/water/big_water_add_minеral.png';
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

  String getWaterDrinksTitle() {
    if (waterList.isNotEmpty && drinkList.isNotEmpty) {
      if (drinkList.length > 1) {
        return "Вы добавили воду и напитки:";
      } else {
        return "Вы добавили воду и напиток:";
      }
    } else if (waterList.isNotEmpty) {
      return "Вы добавили воду:";
    } else if (drinkList.isNotEmpty) {
      if (drinkList.length > 1) {
        return "Вы добавили напитки:";
      } else {
        return "Вы добавили напиток:";
      }
    }
    return "";
  }

  Widget getFoodPhoto() {
    if (foodPhoto != null && foodPhoto?.isAbsolute == true) {
      return Stack(
        children: [
          SizedBox(
            height: 200.h,
            width: double.infinity,
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(4.r),
              child: Image(
                image: Image.file(foodPhoto!).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r), color: AppColors.vivaMagentaColor),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: SvgPicture.asset('assets/images/edit.svg'),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
          decoration: BoxDecoration(
              color: AppColors.lightGreenColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.seaColor,
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/picture_diary.svg',
                height: 80.h,
              ),
              Text(
                'Добавить фотографию',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.vivaMagentaColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ));
    }
  }
}
