import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/ui/client_category/food_diary/bottom_sheets/client_food_diary_adds_option_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/data/repository/food_diary_storage.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';


class ItemAdds {
  bool isOpen;
  String title;
  List<ItemDrinkAddsItem> addsList;
  double? calorie;
  int quantity;

  ItemAdds({
    this.isOpen = false,
    required this.quantity,
    required this.title,
    required this.addsList,
    this.calorie,
  });
}

class ClientFoodDiaryAddsSheet extends StatefulWidget {
  const ClientFoodDiaryAddsSheet({
    super.key,
    required this.foodId,
    required this.addsList,
    required this.showMilk,
    this.itemAdds
  });

  final int foodId;
  final List<ItemAdds> addsList;
  final bool showMilk;
  final List<ItemDrinkAddsItem>? itemAdds;

  @override
  State<ClientFoodDiaryAddsSheet> createState() => _ClientFoodDiaryAddsSheetState();
}

class _ClientFoodDiaryAddsSheetState extends State<ClientFoodDiaryAddsSheet> {
  final foodDiaryStorage = FoodDiaryStorage();
  List<ItemAdds> addsList = [];

  int sugarQuantity = 0;
  int honeyQuantity = 0;
  int steviaQuantity = 0;

  int milkQuantity = 0;
  int starchQuantity = 0; //крахмал

  bool isMilkOpen = false;
  String milkTitle = "Нажмите, чтобы выбрать";
  bool isStarchOpen = false;
  String starchTitle = "Нажмите, чтобы выбрать";

  @override
  void initState() {
    check();
    super.initState();
  }

  check(){
    if(widget.itemAdds != null && widget.itemAdds!.isNotEmpty){
      widget.itemAdds?.forEach((element){
        if(element.title == "Мед"){
          setState(() {
            honeyQuantity = element.quantity;
          });
        }
        else if(element.title == "Сахар"){
          setState(() {
            sugarQuantity = element.quantity;
          });
        }
        else if(element.title == "Стевия"){
          setState(() {
            steviaQuantity = element.quantity;
          });
        }
        else if(foodDiaryStorage.addsDrinksList.elementAt(6).addsList.any((item) => item.title == element.title)){
          setState(() {
            starchQuantity = element.quantity;
            starchTitle = element.title;
          });
        }
        else if(foodDiaryStorage.addsDrinksList.elementAt(0).addsList.any((item) => item.title == element.title)){
          setState(() {
            milkQuantity = element.quantity;
            milkTitle = element.title;
          });
        }
        else if(widget.foodId == 7){

          foodDiaryStorage.addsDrinksList.forEach((item){
            item.addsList.forEach((adds){
              if(adds.title == element.title){
                addsList.add(ItemAdds(
                    quantity: element.quantity,
                    title: element.title,
                    addsList: item.addsList
                ));
              }
            });
          });
        }
      });
    }
    if(widget.foodId == 7){
      setState(() {
        addsList = [...addsList, ...widget.addsList];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          decoration: BoxDecoration(
            gradient: AppColors.multigradientColor,
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                      width: 180.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: AppColors.darkGreenColor,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Сахар - ч.л.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          fontFamily: 'Inter',
                          color: sugarQuantity != 0 ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    changeNum('minus', () {
                      if(sugarQuantity != 0){
                        setState(() {
                          sugarQuantity--;
                        });
                      }
                    }),
                    SizedBox(
                      width: 48.r,
                      child: Center(
                        child: Text(
                          sugarQuantity.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            color: sugarQuantity != 0 ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                          ),
                        ),
                      ),
                    ),
                    changeNum('plus', () {
                      setState(() {
                        sugarQuantity++;
                      });
                    }),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                      width: 180.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: AppColors.darkGreenColor,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Мед - ч.л.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          fontFamily: 'Inter',
                          color: honeyQuantity != 0 ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    changeNum('minus', () {
                      if(honeyQuantity != 0){
                        setState(() {
                          honeyQuantity--;
                        });
                      }
                    }),
                    SizedBox(
                      width: 48.r,
                      child: Center(
                        child: Text(
                          honeyQuantity.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            color: honeyQuantity != 0 ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                          ),
                        ),
                      ),
                    ),
                    changeNum('plus', () {
                      setState(() {
                        honeyQuantity++;
                      });
                    }),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                      width: 180.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: AppColors.darkGreenColor,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Стевия - 1 табл.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          fontFamily: 'Inter',
                          color: steviaQuantity != 0 ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    changeNum('minus', () {
                      if(steviaQuantity != 0){
                        setState(() {
                          steviaQuantity--;
                        });
                      }
                    }),
                    SizedBox(
                      width: 48.r,
                      child: Center(
                        child: Text(
                          steviaQuantity.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            color: steviaQuantity != 0 ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                          ),
                        ),
                      ),
                    ),
                    changeNum('plus', () {
                      setState(() {
                        steviaQuantity++;
                      });
                    }),
                  ],
                ),
                SizedBox(height: 20.h),
                if ((widget.foodId == 0 || widget.foodId == 1 || widget.foodId == 13 || widget.foodId == 3) && !widget.showMilk)
                  Column(
                    children: [
                      Row(
                        children: [
                          FormForButton(
                            borderRadius: BorderRadius.circular(8.r),
                            onPressed: () {
                              setState(() {
                                isMilkOpen = !isMilkOpen;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                              width: 180.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.darkGreenColor,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      milkTitle,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                        fontFamily: 'Inter',
                                        color: milkQuantity != 0 ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ),
                                  Transform.rotate(
                                    angle: pi / 2,
                                    child: SvgPicture.asset(
                                      'assets/images/arrow_black.svg',
                                      color: AppColors.darkGreenColor,
                                      height: 24.h,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          changeNum('minus', () {
                            if (milkQuantity != 0 && milkTitle != "Нажмите, чтобы выбрать") {
                              setState(() {
                                milkQuantity--;
                              });
                            }
                          }),
                          SizedBox(
                            width: 48.r,
                            child: Center(
                              child: Text(
                                milkQuantity.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  fontFamily: 'Inter',
                                  color: milkQuantity != 0 ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                ),
                              ),
                            ),
                          ),
                          changeNum('plus', () {
                            setState(() {
                              if (milkTitle != "Нажмите, чтобы выбрать") {
                                milkQuantity++;
                              }
                            });
                          }),
                        ],
                      ),
                      Visibility(
                        visible: isMilkOpen,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.seaColor,
                                  ),
                                  color: AppColors.basicwhiteColor,
                                ),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight: 250,
                                      minHeight: 50,
                                      maxWidth: 375.w - 28.w),
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: foodDiaryStorage.addsDrinksList.elementAt(0).addsList.length,
                                    itemBuilder: (context, i) {
                                      final value = foodDiaryStorage.addsDrinksList.elementAt(0).addsList[i];

                                      return FormForButton(
                                        borderRadius: BorderRadius.only(
                                          topRight: i == 0 ? Radius.circular(10) : Radius.zero,
                                          topLeft: i == 0 ? Radius.circular(10) : Radius.zero,
                                          bottomRight: i + 1 == foodDiaryStorage.addsDrinksList.elementAt(0).addsList.length ? Radius.circular(10) : Radius.zero,
                                          bottomLeft: i + 1 == foodDiaryStorage.addsDrinksList.elementAt(0).addsList.length ? Radius.circular(10) : Radius.zero,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            milkTitle = value.title;
                                            milkQuantity = 0;
                                            isMilkOpen = false;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            SizedBox(height: 12.h),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      "${value.title} - ${value.measure}",
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: milkTitle == value.title ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  if(milkTitle == value.title)
                                                    CircleAvatar(
                                                      radius: 10.r,
                                                      backgroundColor: AppColors.vivaMagentaColor,
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          'assets/images/checkmark.svg',
                                                          color: AppColors.basicwhiteColor,
                                                          height: 14.h,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 12.h),
                                            if(i + 1 != foodDiaryStorage.addsDrinksList.elementAt(0).addsList.length)
                                              Container(
                                                color: AppColors.seaColor,
                                                height: 1,
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h)
                    ],
                  ),
                if (widget.foodId == 12)
                  Column(
                    children: [
                      Row(
                        children: [
                          FormForButton(
                            borderRadius: BorderRadius.circular(8.r),
                            onPressed: () {
                              setState(() {
                                isStarchOpen = !isStarchOpen;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                              width: 180.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.darkGreenColor,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      starchTitle,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                        fontFamily: 'Inter',
                                        color: starchQuantity != 0 ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ),
                                  Transform.rotate(
                                    angle: pi / 2,
                                    child: SvgPicture.asset(
                                      'assets/images/arrow_black.svg',
                                      color: AppColors.darkGreenColor,
                                      height: 24.h,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          changeNum('minus', () {
                            if (starchQuantity != 0 && starchTitle != "Нажмите, чтобы выбрать") {
                              setState(() {
                                starchQuantity--;
                              });
                            }
                          }),
                          SizedBox(
                            width: 48.r,
                            child: Center(
                              child: Text(
                                starchQuantity.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  fontFamily: 'Inter',
                                  color: starchQuantity != 0 ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                ),
                              ),
                            ),
                          ),
                          changeNum('plus', () {
                            setState(() {
                              if (starchTitle != "Нажмите, чтобы выбрать") {
                                starchQuantity++;
                              }
                            });
                          }),
                        ],
                      ),
                      Visibility(
                        visible: isStarchOpen,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.seaColor,
                                  ),
                                  color: AppColors.basicwhiteColor,
                                ),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight: 250,
                                      minHeight: 50,
                                      maxWidth: 375.w - 28.w),
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: foodDiaryStorage.addsDrinksList.elementAt(6).addsList.length,
                                    itemBuilder: (context, i) {
                                      final value = foodDiaryStorage.addsDrinksList.elementAt(6).addsList[i];

                                      return FormForButton(
                                        borderRadius: BorderRadius.only(
                                          topRight: i == 0 ? Radius.circular(10) : Radius.zero,
                                          topLeft: i == 0 ? Radius.circular(10) : Radius.zero,
                                          bottomRight: i + 1 == foodDiaryStorage.addsDrinksList.elementAt(6).addsList.length ? Radius.circular(10) : Radius.zero,
                                          bottomLeft: i + 1 == foodDiaryStorage.addsDrinksList.elementAt(6).addsList.length ? Radius.circular(10) : Radius.zero,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            starchTitle = value.title;
                                            milkQuantity = 0;
                                            isStarchOpen = false;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            SizedBox(height: 12.h),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      "${value.title} - ${value.measure}",
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: starchTitle == value.title ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  if(starchTitle == value.title)
                                                    CircleAvatar(
                                                      radius: 10.r,
                                                      backgroundColor: AppColors.vivaMagentaColor,
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          'assets/images/checkmark.svg',
                                                          color: AppColors.basicwhiteColor,
                                                          height: 14.h,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 12.h),
                                            if(i + 1 != foodDiaryStorage.addsDrinksList.elementAt(6).addsList.length)
                                              Container(
                                                color: AppColors.seaColor,
                                                height: 1,
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h)
                    ],
                  ),

                if (widget.foodId == 7)
                  Column(
                    children: [
                      ListView.builder(
                        itemCount: addsList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          ItemAdds value = addsList[index];

                          return Column(
                            children: [
                              Row(
                                children: [
                                  FormForButton(
                                    borderRadius: BorderRadius.circular(8.r),
                                    onPressed: () {
                                      setState(() {
                                        value.isOpen = !value.isOpen;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                                      width: 180.w,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: AppColors.darkGreenColor,
                                        ),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              value.title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp,
                                                fontFamily: 'Inter',
                                                color: value.quantity != 0 ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                              ),
                                            ),
                                          ),
                                          Transform.rotate(
                                            angle: pi / 2,
                                            child: SvgPicture.asset(
                                              'assets/images/arrow_black.svg',
                                              color: AppColors.darkGreenColor,
                                              height: 24.h,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  changeNum('minus', () {
                                    if(value.quantity != 0 && value.title != "Нажмите, чтобы выбрать"){
                                      setState(() {
                                        value.quantity--;
                                      });
                                    }
                                  }),
                                  SizedBox(
                                    width: 48.r,
                                    child: Center(
                                      child: Text(
                                        value.quantity.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                          fontFamily: 'Inter',
                                          color: value.quantity != 0 ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  changeNum('plus', () {
                                    setState(() {
                                      if(value.title != "Нажмите, чтобы выбрать"){
                                        value.quantity++;
                                      }
                                    });
                                  }),
                                ],
                              ),
                              Visibility(
                                visible: value.isOpen,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10),
                                      elevation: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 1,
                                            color: AppColors.seaColor,
                                          ),
                                          color: AppColors.basicwhiteColor,
                                        ),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight: 250,
                                              minHeight: 50,
                                              maxWidth: 375.w - 28.w),
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: value.addsList.length,
                                            itemBuilder: (context, i) {

                                              return FormForButton(
                                                borderRadius: BorderRadius.only(
                                                  topRight: i == 0 ? Radius.circular(10) : Radius.zero,
                                                  topLeft: i == 0 ? Radius.circular(10) : Radius.zero,
                                                  bottomRight: i + 1 == value.addsList.length ? Radius.circular(10) : Radius.zero,
                                                  bottomLeft: i + 1 == value.addsList.length ? Radius.circular(10) : Radius.zero,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    value.title = value.addsList[i].title;
                                                    value.quantity = 0;
                                                    value.isOpen = false;
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 12.h),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              "${value.addsList[i].title} - ${value.addsList[i].measure}",
                                                              style: TextStyle(
                                                                fontFamily: 'Inter',
                                                                color: value.title == value.addsList[i].title ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                                                fontSize: 16.sp,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                          ),
                                                          if(value.title == value.addsList[i].title)
                                                            CircleAvatar(
                                                              radius: 10.r,
                                                              backgroundColor: AppColors.vivaMagentaColor,
                                                              child: Center(
                                                                child: SvgPicture.asset(
                                                                  'assets/images/checkmark.svg',
                                                                  color: AppColors.basicwhiteColor,
                                                                  height: 14.h,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 12.h),
                                                    if(i + 1 != value.addsList.length)
                                                      Container(
                                                        color: AppColors.seaColor,
                                                        height: 1,
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h)
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 24.h),
                      WidgetButton(
                        boxShadow: true,
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
                              title: 'Выберите вариант добавки',
                              content: ClientFoodDiaryAddsOptionSheet(),
                            ),
                          ).then((value){
                            if(value == "фрукты"){
                              setState(() {
                                addsList.add(ItemAdds(
                                    addsList: foodDiaryStorage.addsDrinksList.elementAt(3).addsList,
                                    title: "Нажмите, чтобы выбрать",
                                    calorie: 0,
                                    quantity: 0
                                ));
                              });
                            }
                            else if(value == "молоко"){
                              setState(() {
                                addsList.add(ItemAdds(
                                    addsList: foodDiaryStorage.addsDrinksList.elementAt(0).addsList,
                                    title: "Нажмите, чтобы выбрать",
                                    calorie: 0,
                                    quantity: 0
                                ));
                              });
                            }
                            else if(value == "протеин"){
                              setState(() {
                                addsList.add(ItemAdds(
                                    addsList: foodDiaryStorage.addsDrinksList.elementAt(4).addsList,
                                    title: "Нажмите, чтобы выбрать",
                                    calorie: 0,
                                    quantity: 0
                                ));
                              });
                            }
                            else if(value == "овощи"){
                              setState(() {
                                addsList.add(ItemAdds(
                                    addsList: foodDiaryStorage.addsDrinksList.elementAt(2).addsList,
                                    title: "Нажмите, чтобы выбрать",
                                    calorie: 0,
                                    quantity: 0
                                ));
                              });
                            }
                            else if(value == "орехи"){
                              setState(() {
                                addsList.add(ItemAdds(
                                    addsList: foodDiaryStorage.addsDrinksList.elementAt(1).addsList,
                                    title: "Нажмите, чтобы выбрать",
                                    calorie: 0,
                                    quantity: 0
                                ));
                              });
                            }
                            else if(value == "другое"){
                              setState(() {
                                addsList.add(ItemAdds(
                                    addsList: foodDiaryStorage.addsDrinksList.elementAt(5).addsList,
                                    title: "Нажмите, чтобы выбрать",
                                    calorie: 0,
                                    quantity: 0
                                ));
                              });
                            }
                          });
                        },
                        gradient: AppColors.multigradientColor,
                        text: 'Добавить ещё'.toUpperCase(),
                        textColor: AppColors.darkGreenColor,
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),

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
                          if (honeyQuantity != 0 || milkQuantity != 0 ||
                              starchQuantity != 0 || steviaQuantity != 0 ||
                              sugarQuantity != 0 || addsList.isNotEmpty) {

                            if(honeyQuantity != 0){
                              addsList.add(ItemAdds(
                                  quantity: honeyQuantity,
                                  title: "Мед",
                                  addsList: [
                                    ItemDrinkAddsItem(
                                        title: "Мед",
                                        quantity: honeyQuantity,
                                        measure: "ч.л.",
                                        calorie: (32.9 * honeyQuantity) / 5,
                                        ml: 5
                                    )
                                  ]
                              ));
                            }
                            if(sugarQuantity != 0){
                              addsList.add(ItemAdds(
                                  quantity: sugarQuantity,
                                  title: "Сахар",
                                  addsList: [
                                    ItemDrinkAddsItem(
                                        title: "Сахар",
                                        quantity: sugarQuantity,
                                        measure: "ч.л.",
                                        calorie: (33.7 * sugarQuantity) / 5,
                                        ml: 5
                                    )
                                  ]
                              ));
                            }
                            if(steviaQuantity != 0){
                              addsList.add(ItemAdds(
                                  quantity: steviaQuantity,
                                  title: "Стевия",
                                  addsList: [
                                    ItemDrinkAddsItem(
                                        title: "Стевия",
                                        quantity: steviaQuantity,
                                        measure: "табл.",
                                        calorie: (1.44 * steviaQuantity) / 0.06,
                                        ml: 1
                                    )
                                  ]
                              ));
                            }
                            if(starchQuantity != 0){
                              double calorie = foodDiaryStorage.addsDrinksList.elementAt(6).addsList.firstWhere((element)=> element.title == starchTitle).calorie;

                              addsList.add(ItemAdds(
                                  quantity: starchQuantity,
                                  title: starchTitle,
                                  addsList: [
                                    ItemDrinkAddsItem(
                                        title: starchTitle,
                                        quantity: starchQuantity,
                                        measure: "ст.л.",
                                        calorie: (calorie * starchQuantity) / 15,
                                        ml: 15
                                    )
                                  ]
                              ));
                            }
                            if(milkQuantity != 0){
                              double calorie = foodDiaryStorage.addsDrinksList.elementAt(0).addsList.firstWhere((element)=> element.title == milkTitle).calorie;

                              addsList.add(ItemAdds(
                                  quantity: milkQuantity,
                                  title: milkTitle,
                                  addsList: [
                                    ItemDrinkAddsItem(
                                        title: milkTitle,
                                        quantity: milkQuantity,
                                        measure: "ст.л.",
                                        calorie: (calorie * milkQuantity) / (15),
                                        ml: 15
                                    )
                                  ]
                              ));
                            }

                            List<ItemDrinkAddsItem> chosenValues = [];

                            addsList.forEach((element){
                              if(element.quantity != 0){
                                element.addsList.forEach((item){
                                  if(element.title == item.title){
                                    chosenValues.add(ItemDrinkAddsItem(
                                        title: element.title,
                                        quantity: element.quantity,
                                        measure: item.measure,
                                        calorie: item.calorie,
                                        ml: item.ml
                                    ));
                                  }
                                });
                              }
                            });

                            context.router.maybePop(chosenValues);
                          }
                          else {
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
                        child: Text(
                          'добавить в дневник'.toUpperCase(),
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
      ],
    );
  }

  Widget changeNum(String name, Function()? onPressed) {
    return Container(
      width: 48.r,
      height: 48.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.darkGreenColor,
      ),
      child: FormForButton(
        borderRadius: BorderRadius.circular(8.r),
        onPressed: onPressed,
        child: Center(
          child: 'plus' == name
              ? SvgPicture.asset(
            'assets/images/plus.svg',
            width: 20.r,
            color: AppColors.basicwhiteColor,
          )
              : Container(
            width: 16.r,
            height: 1.67.r,
            color: AppColors.basicwhiteColor,
          ),
        ),
      ),
    );
  }
}






