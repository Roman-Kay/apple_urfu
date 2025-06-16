import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:garnetbook/ui/client_category/food_diary/components/client_food_diary_list_meal.dart';
import 'package:garnetbook/ui/client_category/water/bottom_sheets/client_water_add_sheet.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/extension/string_externsions.dart';
import 'package:garnetbook/data/repository/food_diary_storage.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/dialogs/delete_dialog.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class ClientFoodDiaryEditFoodScreen extends StatefulWidget {
  const ClientFoodDiaryEditFoodScreen({Key? key, required this.view, required this.numberOfMeal, required this.selectedDate})
      : super(key: key);

  final ItemMeal view;
  final int numberOfMeal;
  final DateTime selectedDate;

  @override
  State<ClientFoodDiaryEditFoodScreen> createState() => _ClientFoodDiaryEditFoodScreenState();
}

class _ClientFoodDiaryEditFoodScreenState extends State<ClientFoodDiaryEditFoodScreen> {
  final service = FoodDiaryService();
  final waterDiaryService = WaterDiaryService();
  final foodDiaryStorage = FoodDiaryStorage();

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPortion = TextEditingController();
  TextEditingController controllerCalories = TextEditingController();
  TextEditingController controllerTime = TextEditingController();
  TextEditingController controllerXe = TextEditingController();
  TextEditingController controllerComment = TextEditingController();

  List<int> foodColors = [];
  bool XE = false;
  bool validation = false;
  DateTime selectedDate = DateTime.now();
  File? foodPhoto;
  String oldPhoto = "";
  int? foodId;

  List<WaterView> waterList = [];
  List<Drink> drinkList = [];
  List<Drink> oldDrink = [];
  List<WaterView> oldWater = [];

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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        borderColor: validation && controllerName.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.seaColor,
                        labelText: 'Описание',
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
                                  if (validation) {
                                    setState(() {
                                      validation = false;
                                    });
                                  }
                                }
                              });
                            },
                            child: SizedBox(
                              width: 157.w,
                              child: CustomTextFieldLabel(
                                isLast: false,
                                maxLength: 4,
                                controller: controllerPortion,
                                enabled: false,
                                onChanged: (val) {
                                  if (validation) {
                                    setState(() {
                                      validation = false;
                                    });
                                  }
                                },
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
                              maxLength: 4,
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
                                });

                                if (validation) {
                                  setState(() {
                                    validation = false;
                                  });
                                }
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.ru,
                            ),
                            child: SizedBox(
                              width: 157.w,
                              child: CustomTextFieldLabel(
                                isLast: false,
                                controller: controllerTime,
                                enabled: false,
                                borderColor: validation && controllerTime.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.seaColor,
                                backGroudColor: AppColors.lightGreenColor,
                                labelColor: AppColors.vivaMagentaColor,
                                labelText: 'Время приема',
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
                      SizedBox(height: 16.h),
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
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DeleteDialog();
                                          },
                                        ).then((value) {
                                          if (value == true) {
                                            setState(() {
                                              drinkList.removeAt(index);
                                            });
                                          }
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
                            itemCount: waterList.length,
                            physics: NeverScrollableScrollPhysics(),
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
                                      getWaterPhoto(waterList[index].foodName ?? "Вода"),
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
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DeleteDialog();
                                          },
                                        ).then((value) {
                                          if (value == true) {
                                            setState(() {
                                              waterList.removeAt(index);
                                            });
                                          }
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
                      SizedBox(height: 32.h),
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
                              onTap: () async {
                                context.router.maybePop();
                              },
                              color: AppColors.lightGreenColor,
                              child: Text(
                                "отмена".toUpperCase(),
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
                                      imageBase64 = base64Encode(result);

                                      String s = foodPhoto!.path;
                                      var pos = s.lastIndexOf('.');
                                      String resultName = (pos != -1) ? s.substring(pos) : s;
                                      format = resultName.substring(1);

                                      imageName = "user_food_diary";
                                    }
                                  }

                                  List<Drink> selectedDrink = [];
                                  List<Water> selectedWater = [];

                                  if (drinkList.isNotEmpty) {
                                    drinkList.forEach((newDrink) {
                                      selectedDrink.add(Drink(
                                          foodName: newDrink.foodName,
                                          calories: newDrink.calories,
                                          portion: newDrink.portion,
                                          foodPeriod: widget.numberOfMeal,
                                          foodTime: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate),
                                          comment: controllerComment.text.isNotEmpty ? controllerComment.text : null));
                                    });
                                  }

                                  if (waterList.isNotEmpty) {
                                    waterList.forEach((element) {
                                      selectedWater.add(Water(
                                          portion: element.portion,
                                          foodPeriod: widget.numberOfMeal,
                                          calories: element.calories,
                                          foodTime: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate),
                                          foodName: element.foodName ?? "Вода"));
                                    });
                                  }

                                  final response = await service.addFoodDiary(ClientFoodCreateRequest(
                                    waters: selectedWater.isNotEmpty ? selectedWater : null,
                                    drinks: selectedDrink.isNotEmpty ? selectedDrink : null,
                                    foods: controllerName.text.isNotEmpty
                                        ? [
                                            Food(
                                              portion: controllerPortion.text.isNotEmpty ? int.parse(controllerPortion.text) : 0,
                                              photo: foodPhoto != null && foodPhoto?.isAbsolute == true
                                                  ? ImageView(format: format, name: imageName, base64: imageBase64)
                                                  : oldPhoto != ""
                                                      ? ImageView(format: "jpg", name: "user_food_diary", base64: oldPhoto)
                                                      : ImageView(format: "", name: "", base64: ""),
                                              foodName: controllerName.text.capitalize(),
                                              foodTime: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate),
                                              foodPeriod: widget.numberOfMeal,
                                              foodColors: foodColors != [] ? foodColors : [],
                                              calories: controllerCalories.text.isNotEmpty ? int.parse(controllerCalories.text) : 0,
                                              comment: controllerComment.text.isNotEmpty ? controllerComment.text : "",
                                              xe: controllerXe.text.isNotEmpty ? int.parse(controllerXe.text) : 0,
                                              id: foodId,
                                            )
                                          ]
                                        : null,
                                  ));

                                  if (response.result) {
                                    GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.changeFoodDiaryClient);

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
                                "ИЗМЕНИТЬ",
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
                          "Редактировать",
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

  check() {
    setState(() {
      selectedDate = widget.selectedDate;
    });

    if (widget.view.food.isNotEmpty) {
      FoodView foodView = widget.view.food.first;

      if (foodView.id != null) {
        setState(() {
          foodId = foodView.id!;
        });
      }

      if (foodView.comment != null && foodView.comment != "") {
        setState(() {
          controllerComment.text = foodView.comment!;
        });
      }

      if (foodView.foodName != null) {
        setState(() {
          controllerName.text = foodView.foodName!;
        });
      }

      if (foodView.calories != null && foodView.calories != 0) {
        setState(() {
          controllerCalories.text = foodView.calories!.toString();
        });
      }

      if (foodView.foodTime != null) {
        DateTime newDate = DateTime.parse(foodView.foodTime!);
        setState(() {
          selectedDate = newDate;
          controllerTime.text = DateFormat("HH:mm").format(newDate);
        });
      }

      if (foodView.portion != null && foodView.portion != 0) {
        setState(() {
          controllerPortion.text = foodView.portion.toString();
        });
      }

      if (foodView.xe != null && foodView.xe != 0) {
        setState(() {
          controllerXe.text = foodView.xe!.toString();
        });
      }

      if (foodView.foodPhoto != null && foodView.foodPhoto?.fileBase64 != null && foodView.foodPhoto?.fileBase64 != "") {
        setState(() {
          oldPhoto = foodView.foodPhoto!.fileBase64!;
        });
      }

      if (foodView.colors != null && foodView.colors!.isNotEmpty) {
        foodView.colors!.forEach((element) {
          if (element.id != null) {
            setState(() {
              int index = foodDiaryStorage.listOfItemColor.indexWhere((item) => element.id! == item.id);
              foodDiaryStorage.listOfItemColor[index].isChoose = true;

              foodColors.add(element.id!);
            });
          }
        });
      }
    }

    if (widget.view.drink != null && widget.view.drink!.isNotEmpty) {
      DrinkView drinkView = widget.view.drink!.first;

      if (drinkView.comment != null) {
        setState(() {
          controllerComment.text = drinkView.comment!;
        });
      }

      if (drinkView.foodTime != null) {
        DateTime newDate = DateTime.parse(drinkView.foodTime!);
        setState(() {
          selectedDate = newDate;
          controllerTime.text = DateFormat("HH:mm").format(newDate);
        });
      }

      widget.view.drink!.forEach((element) {
        if (element.portion != null && element.foodName != null) {
          setState(() {
            drinkList.add(Drink(
              id: element.id,
              portion: element.portion,
              foodName: element.foodName,
              calories: element.calories,
            ));
            oldDrink.add(Drink(
              id: element.id,
              portion: element.portion,
              foodName: element.foodName,
              calories: element.calories,
            ));
          });
        }
      });
    }

    if (widget.view.water != null && widget.view.water!.isNotEmpty) {
      widget.view.water!.forEach((element) {
        if (element.id != null && element.portion != null) {
          setState(() {
            waterList.add(WaterView(
                id: element.id, foodName: element.foodName ?? "Вода", portion: element.portion!, calories: element.calories ?? 0));

            oldWater.add(WaterView(
                id: element.id, foodName: element.foodName ?? "Вода", portion: element.portion!, calories: element.calories ?? 0));
          });
        }
      });
    }
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
      if (drinkList!.length > 1) {
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
      if (oldPhoto != "") {
        return Stack(
          children: [
            SizedBox(
              height: 200.h,
              width: double.infinity,
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(4.r),
                child: Image.memory(
                  base64Decode(oldPhoto),
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
}
