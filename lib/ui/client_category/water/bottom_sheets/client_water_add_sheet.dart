import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/data/models/client/food_diary/food_create_model.dart';
import 'package:garnetbook/data/models/client/food_diary/food_diary_model.dart';
import 'package:garnetbook/data/models/client/water_diary/water_update_model.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/client/food_diary/food_diary_service.dart';
import 'package:garnetbook/domain/services/client/water_diary/water_diary_service.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/data/repository/food_diary_storage.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/portion_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ClientWaterAddSheet extends StatefulWidget {
  const ClientWaterAddSheet({super.key, required this.target, required this.isFromFoodDiary, this.water});

  final int target;
  final bool isFromFoodDiary;
  final WaterView? water;

  @override
  State<ClientWaterAddSheet> createState() => _ClientWaterAddSheetState();
}

class _ClientWaterAddSheetState extends State<ClientWaterAddSheet> {
  FoodDiaryStorage foodDiaryStorage = FoodDiaryStorage();
  List<String> choosePortion = [];
  TextEditingController portionController = TextEditingController();
  String chooseOption = "";

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  void dispose() {
    portionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          decoration: BoxDecoration(gradient: AppColors.gradientSecond),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  addsContainer(
                    'assets/images/drink/water/water_add_lemon.png',
                    () {
                      setState(() {
                        chooseOption = chooseOption == 'с лимоном' ? '' : 'с лимоном';
                      });
                    },
                    chooseOption,
                    'с лимоном',
                  ),
                  const Spacer(),
                  addsContainer(
                    'assets/images/drink/water/water_add_berries.png',
                    () {
                      setState(() {
                        chooseOption = chooseOption == 'с ягодами' ? '' : 'с ягодами';
                      });
                    },
                    chooseOption,
                    'с ягодами',
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  addsContainer(
                    'assets/images/drink/water/water_add_ginger.png',
                    () {
                      setState(() {
                        chooseOption = chooseOption == 'с имбирем' ? '' : 'с имбирем';
                      });
                    },
                    chooseOption,
                    'с имбирем',
                  ),
                  const Spacer(),
                  addsContainer(
                    'assets/images/drink/water/water_add_mineral.png',
                    () {
                      setState(() {
                        chooseOption = chooseOption == 'минеральная' ? '' : 'минеральная';
                      });
                    },
                    chooseOption,
                    'минеральная',
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Укажите объем, мл',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.darkGreenColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                height: 1,
                color: AppColors.blueSecondaryColor,
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 16.h,
                  children: [
                    for (var portion in foodDiaryStorage.items)
                      "$portion" == '1000'
                          ? Center(
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  if (choosePortion.contains(portion)) {
                                    choosePortion.remove(portion);
                                  } else {
                                    choosePortion.add(portion);
                                  }
                                }),
                                child: PortionButton(
                                  isChoose: choosePortion.contains(portion),
                                  textColor: AppColors.basicwhiteColor,
                                  textColorChoose: AppColors.basicwhiteColor,
                                  backgroundColor: AppColors.darkWithOpacitygreenColor,
                                  backgroundColorChoose: AppColors.darkGreenColor,
                                  borderColor: AppColors.darkGreenColor,
                                  text: "$portion",
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => setState(() {
                                if (choosePortion.contains(portion)) {
                                  choosePortion.remove(portion);
                                } else {
                                  choosePortion.add(portion);
                                }
                              }),
                              child: PortionButton(
                                isChoose: choosePortion.contains(portion),
                                textColor: AppColors.basicwhiteColor,
                                textColorChoose: AppColors.basicwhiteColor,
                                backgroundColor: AppColors.darkWithOpacitygreenColor,
                                backgroundColorChoose: AppColors.darkGreenColor,
                                borderColor: AppColors.darkGreenColor,
                                text: "$portion",
                              ),
                            ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextFieldLabel(
                isSmall: true,
                hintText: 'Свой вариант',
                hintColor: AppColors.darkGreenColor,
                controller: portionController,
                borderColor: AppColors.darkGreenColor,
                maxLength: 5,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: WidgetButton(
                      onTap: () => context.router.maybePop(),
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
                        if (choosePortion.isNotEmpty || portionController.text.isNotEmpty) {
                          if (portionController.text.isNotEmpty) {
                            if (portionController.text == "0" || !RegExp(r'^[0-9]*$').hasMatch(portionController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text(
                                    'Введите корректное значение',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              );
                              return;
                            } else {
                              choosePortion.add(portionController.text);
                            }
                          }

                          int userPortion = 0;
                          choosePortion.forEach((element) {
                            userPortion = userPortion + int.parse(element);
                          });

                          if (widget.isFromFoodDiary) {
                            int calorie = 0;

                            if (chooseOption == "с ягодами" || chooseOption == "с имбирем") {
                              calorie = (3 * userPortion) ~/ 250;
                            }

                            final value = WaterView(
                                foodName: chooseOption.isNotEmpty ? "Вода $chooseOption" : "Вода", calories: calorie, portion: userPortion);

                            if (widget.water != null) {
                              FocusScope.of(context).unfocus();
                              context.loaderOverlay.show();

                              final response = await FoodDiaryService().addFoodDiary(ClientFoodCreateRequest(
                                waters: [
                                  Water(
                                      foodName: chooseOption.isNotEmpty ? "Вода $chooseOption" : "Вода",
                                      calories: calorie,
                                      portion: userPortion,
                                      foodPeriod: widget.water?.foodPeriod,
                                      id: widget.water?.id)
                                ],
                                drinks: null,
                                foods: null,
                              ));

                              if (response.result) {
                                GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.addWaterClient);

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
                              context.router.maybePop(value);
                            }
                          } else {
                            FocusScope.of(context).unfocus();
                            context.loaderOverlay.show();
                            final service = WaterDiaryService();

                            final response =
                                await service.addWaterDiary(ClientWaterUpdateRequest(val: userPortion, dayNorm: widget.target));

                            if (response.result) {
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
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 3),
                              content: Text(
                                'Введите значение',
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
                      boxShadow: true,
                      child: Text(
                        'ДОБАВИТЬ',
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
      ],
    );
  }

  check() {
    if (widget.water != null) {
      if (widget.water?.portion != null) {
        if (foodDiaryStorage.items.contains(widget.water!.portion!.toString())) {
          setState(() {
            choosePortion.add(widget.water!.portion!.toString());
          });
        } else {
          setState(() {
            portionController.text = widget.water!.portion!.toString();
          });
        }
      }

      if (widget.water?.foodName != null) {
        if (widget.water!.foodName!.length > 5) {
          String result = widget.water!.foodName!.substring(5);

          setState(() {
            chooseOption = result;
          });
        }
      }
    }
  }

  Widget addsContainer(
    final String image,
    void Function()? onPressed,
    final String choossOption,
    final String text,
  ) {
    return AnimatedOpacity(
      opacity: choossOption == text || choossOption == '' ? 1 : 0.5,
      duration: Duration(milliseconds: 200),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(8.r),
        child: Stack(
          children: [
            Image.asset(
              image,
              width: 160.w,
              height: 36.h,
              fit: BoxFit.cover,
            ),
            Container(
              width: 160.w,
              height: 36.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.basicblackColor.withOpacity(0.6),
                    AppColors.basicblackColor.withOpacity(0),
                  ],
                ),
              ),
              child: FormForButton(
                borderRadius: BorderRadius.circular(8.r),
                onPressed: onPressed,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          text.toUpperCase(),
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: AppColors.basicwhiteColor,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 12.r,
                        backgroundColor: choossOption == text ? AppColors.vivaMagentaColor : AppColors.basicwhiteColor,
                        child: choossOption == text
                            ? Padding(
                                padding: const EdgeInsets.all(4),
                                child: SvgPicture.asset(
                                  'assets/images/checkmark.svg',
                                  color: AppColors.basicwhiteColor,
                                ),
                              )
                            : const SizedBox(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
