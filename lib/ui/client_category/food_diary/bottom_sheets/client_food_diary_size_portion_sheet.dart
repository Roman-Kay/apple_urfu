import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/data/repository/food_diary_storage.dart';
import 'package:garnetbook/widgets/buttons/portion_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';

class ClientFoodDiarySizePortionSheet extends StatefulWidget {
  const ClientFoodDiarySizePortionSheet({super.key});

  @override
  State<ClientFoodDiarySizePortionSheet> createState() => _ClientFoodDiarySizePortionSheetState();
}

class _ClientFoodDiarySizePortionSheetState extends State<ClientFoodDiarySizePortionSheet> {
  FoodDiaryStorage foodDiaryStorage = FoodDiaryStorage();
  List<String> choosePortion = [];
  TextEditingController portionController = TextEditingController();

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
          color: AppColors.limeColor,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 16.h,
                  children: [
                    for (var portion in foodDiaryStorage.items)
                      '$portion' == '1000'
                          ? Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if(choosePortion.contains(portion)){
                                      choosePortion.remove(portion);
                                    }
                                    else{
                                      choosePortion.add(portion);
                                    }
                                  });
                                },
                                child: PortionButton(
                                  isChoose: choosePortion.contains(portion),
                                  textColor: AppColors.darkGreenColor,
                                  textColorChoose: AppColors.basicwhiteColor,
                                  backgroundColorChoose: AppColors.darkGreenColor,
                                  backgroundColor: AppColors.basicwhiteColor,
                                  borderColor: AppColors.greenColor,
                                  text: "$portion",
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  if(choosePortion.contains(portion)){
                                    choosePortion.remove(portion);
                                  }
                                  else{
                                    choosePortion.add(portion);
                                  }
                                });
                              },
                              child: PortionButton(
                                isChoose: choosePortion.contains(portion),
                                textColor: AppColors.darkGreenColor,
                                textColorChoose: AppColors.basicwhiteColor,
                                backgroundColorChoose: AppColors.darkGreenColor,
                                backgroundColor: AppColors.basicwhiteColor,
                                borderColor: AppColors.greenColor,
                                text: "$portion",
                              ),
                            ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextFieldLabel(
                isSmall: true,
                maxLength: 4,
                hintText: 'Свой вариант',
                hintColor: AppColors.darkGreenColor,
                controller: portionController,
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
                      onTap: () {
                        if(choosePortion.isNotEmpty || portionController.text.isNotEmpty){
                          if(portionController.text.isNotEmpty){
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
                            }
                            else{
                              choosePortion.add(portionController.text);
                            }
                          }

                          int allPortion = 0;
                          choosePortion.forEach((element){
                            int value = int.parse(element);
                            allPortion = allPortion + value;
                          });

                          context.router.maybePop(allPortion);
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 3),
                              content: Text(
                                'Выберите значение',
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
}
