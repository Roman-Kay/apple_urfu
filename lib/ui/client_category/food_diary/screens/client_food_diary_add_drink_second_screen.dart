import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/data/models/client/food_diary/food_create_model.dart';
import 'package:garnetbook/data/models/client/food_diary/food_diary_model.dart';
import 'package:garnetbook/domain/services/client/food_diary/food_diary_service.dart';
import 'package:garnetbook/ui/client_category/food_diary/bottom_sheets/client_food_diary_adds_option_sheet.dart';
import 'package:garnetbook/ui/client_category/food_diary/bottom_sheets/client_food_diary_adds_sheet.dart';
import 'package:garnetbook/ui/client_category/food_diary/bottom_sheets/client_food_diary_ml_bottom_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/data/repository/food_diary_storage.dart';
import 'package:garnetbook/utils/functions/mask_formating_functions.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/portion_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class ClientFoodDiaryAddDrinkSecondScreen extends StatefulWidget {
  const ClientFoodDiaryAddDrinkSecondScreen({
    super.key,
    this.view,
    required this.indexChosenDrink,
  });

  final int indexChosenDrink;
  final DrinkView? view;

  @override
  State<ClientFoodDiaryAddDrinkSecondScreen> createState() => _ClientFoodDiaryAddDrinkSecondScreenState();
}

class _ClientFoodDiaryAddDrinkSecondScreenState extends State<ClientFoodDiaryAddDrinkSecondScreen> {
  FoodDiaryStorage foodDiaryStorage = FoodDiaryStorage();
  List<String> choosePortion = [];
  String addsDrinks = "";
  List<ItemDrinkAddsItem> itemAdds = [];
  RegExp regExp = RegExpFormatting.integerRegExp;
  bool isOpen = false;
  TextEditingController portionController = TextEditingController();
  ItemDrinkItem? selectedDrink;
  ItemWater? selectedWaterDrink;
  int? valueMlSelected;

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
    return GestureDetector(
      onTap: (){
        if(isOpen){
          setState(() {
            isOpen = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.basicwhiteColor,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: (56 + 20).h),
                        SizedBox(
                          height: 56.h,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Stack(
                              children: [
                                Image.asset(
                                  foodDiaryStorage.listOfItemDrink[widget.indexChosenDrink].image,
                                  width: double.infinity,
                                  height: 56.h,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 56.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft,
                                      colors: [
                                        AppColors.basicblackColor.withOpacity(0),
                                        AppColors.basicblackColor.withOpacity(0.8),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            foodDiaryStorage.listOfItemDrink[widget.indexChosenDrink].title.toUpperCase(),
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: AppColors.basicwhiteColor,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 32.r,
                                          height: 32.r,
                                          decoration: BoxDecoration(
                                            color: AppColors.vivaMagentaColor,
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: SvgPicture.asset(
                                              'assets/images/edit.svg',
                                              color: AppColors.basicwhiteColor,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        if (foodDiaryStorage.listOfItemDrink[widget.indexChosenDrink].addsList.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 24.h),
                              Text(
                                widget.indexChosenDrink == 5 ? "Выберите вид и жирность напитка" : 'Выберите вид напитка',
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.darkGreenColor,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: double.infinity,
                                height: 1,
                                decoration: BoxDecoration(gradient: AppColors.gradientTurquoise),
                              ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        if (widget.indexChosenDrink == 5)
                          Column(
                            children: [
                              FormForButton(
                                onPressed: (){
                                  setState(() {
                                    isOpen = !isOpen;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8.r),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(width: 1, color: AppColors.darkGreenColor),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          selectedDrink == null ? 'Нажмите, чтобы выбрать' : selectedDrink!.title,
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            color: AppColors.darkGreenColor,
                                          ),
                                        ),
                                      ),
                                      Transform.flip(
                                        flipY: isOpen,
                                        child: Transform.rotate(
                                          angle: pi / 2,
                                          child: SvgPicture.asset(
                                            'assets/images/arrow_black.svg',
                                            color: AppColors.darkGreenColor,
                                            height: 24.h,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Visibility(
                                visible: isOpen,
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
                                          itemCount: foodDiaryStorage.listOfItemDrink[5].addsList.length,
                                          itemBuilder: (context, index) {
                                            final value = foodDiaryStorage.listOfItemDrink[5].addsList[index];

                                            return FormForButton(
                                              borderRadius: BorderRadius.only(
                                                topRight: index == 0 ? Radius.circular(10) : Radius.zero,
                                                topLeft: index == 0 ? Radius.circular(10) : Radius.zero,
                                                bottomRight: index + 1 == foodDiaryStorage.listOfItemDrink[5].addsList.length ? Radius.circular(10) : Radius.zero,
                                                bottomLeft: index + 1 == foodDiaryStorage.listOfItemDrink[5].addsList.length ? Radius.circular(10) : Radius.zero,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedDrink = value;
                                                  isOpen = false;
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
                                                            value.title,
                                                            style: TextStyle(
                                                              fontFamily: 'Inter',
                                                              color: value == selectedDrink ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ),
                                                        if(value == selectedDrink)
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
                                                  if(index + 1 != foodDiaryStorage.listOfItemDrink[5].addsList.length)
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
                            ],
                          ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: foodDiaryStorage.listOfItemDrink[widget.indexChosenDrink].addsList.isNotEmpty && widget.indexChosenDrink != 5,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: foodDiaryStorage.listOfItemDrink[widget.indexChosenDrink].addsList.length,
                        itemBuilder: (context, index) {
                          final listOffAddsDrinks = List.generate(
                            index + 1 != foodDiaryStorage.listOfItemDrink[widget.indexChosenDrink].addsList.length ? 2 : 1,
                            (int i) => foodDiaryStorage.listOfItemDrink[widget.indexChosenDrink].addsList[index + i],
                          );

                          return index % 2 != 0
                              ? const SizedBox()
                              : Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0 ? 14.w : 0,
                                    right: 14.w,
                                  ),
                                  child: Column(
                                    children: [
                                      for (var add in listOffAddsDrinks)
                                        AnimatedOpacity(
                                          opacity: addsDrinks == add.type ? 1 : 0.5,
                                          duration: Duration(milliseconds: 100),
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: listOffAddsDrinks.indexOf(add) == 0 ? 12.h : 0),
                                            child: ClipRRect(
                                              clipBehavior: Clip.hardEdge,
                                              borderRadius: BorderRadius.circular(4.r),
                                              child: Stack(
                                                children: [
                                                  if (add.image != null)
                                                    Image.asset(
                                                      add.image!,
                                                      width: 160.w,
                                                      height: 38.h,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  Container(
                                                    width: 160.w,
                                                    height: 38.h,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment.centerRight,
                                                        colors: [
                                                          AppColors.basicblackColor.withOpacity(0.8),
                                                          AppColors.basicblackColor.withOpacity(0),
                                                        ],
                                                      ),
                                                    ),
                                                    child: FormForButton(
                                                      borderRadius: BorderRadius.circular(4.r),
                                                      onPressed: () {
                                                        setState(() {
                                                          addsDrinks = add.type;
                                                          selectedDrink = add;

                                                          if(selectedWaterDrink != null){
                                                            selectedWaterDrink = null;
                                                          }
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    add.type.toUpperCase(),
                                                                    style: TextStyle(
                                                                      fontFamily: "Inter",
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 12,
                                                                      height: 1,
                                                                      color: AppColors.basicwhiteColor,
                                                                    ),
                                                                  ),
                                                                  if (add.subTitle != null)
                                                                    Column(
                                                                      children: [
                                                                        SizedBox(height: 3.h),
                                                                        Text(
                                                                          add.subTitle!.toUpperCase(),
                                                                          style: TextStyle(
                                                                            fontFamily: "Inter",
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: 8,
                                                                            height: 10 / 12.1,
                                                                            color: AppColors.basicwhiteColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                            CircleAvatar(
                                                              radius: 12.r,
                                                              backgroundColor: addsDrinks == add.type ? AppColors.vivaMagentaColor : AppColors.basicwhiteColor,
                                                              child: addsDrinks == add.type
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
                                          ),
                                        )
                                    ],
                                  ),
                                );
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (widget.indexChosenDrink == 6 || widget.indexChosenDrink == 0 || widget.indexChosenDrink == 1 || widget.indexChosenDrink == 13) && selectedDrink != null && selectedDrink!.subList != null && selectedDrink!.subList!.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          Text(
                            widget.indexChosenDrink == 6 ? "Выберите вид и жирность напитка" : "Выберите вид напитка",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            height: 1,
                            decoration: BoxDecoration(gradient: AppColors.gradientTurquoise),
                          ),
                          SizedBox(height: 16.h),
                          FormForButton(
                            onPressed: (){
                              setState(() {
                                isOpen = !isOpen;
                              });
                            },
                            borderRadius: BorderRadius.circular(8.r),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(width: 1, color: AppColors.darkGreenColor),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      selectedWaterDrink == null ? 'Нажмите, чтобы выбрать' : selectedWaterDrink!.text,
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ),
                                  Transform.flip(
                                    flipY: isOpen,
                                    child: Transform.rotate(
                                      angle: pi / 2,
                                      child: SvgPicture.asset(
                                        'assets/images/arrow_black.svg',
                                        color: AppColors.darkGreenColor,
                                        height: 24.h,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Visibility(
                            visible: isOpen,
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
                                    child: selectedDrink != null && selectedDrink!.subList != null
                                        ? ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: selectedDrink!.subList!.length,
                                      itemBuilder: (context, index) {
                                        final value = selectedDrink!.subList![index];

                                        return FormForButton(
                                          borderRadius: BorderRadius.only(
                                            topRight: index == 0 ? Radius.circular(10) : Radius.zero,
                                            topLeft: index == 0 ? Radius.circular(10) : Radius.zero,
                                            bottomRight: index + 1 == selectedDrink!.subList!.length ? Radius.circular(10) : Radius.zero,
                                            bottomLeft: index + 1 == selectedDrink!.subList!.length ? Radius.circular(10) : Radius.zero,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              selectedWaterDrink = value;
                                              isOpen = false;
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
                                                        value.text,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: value == selectedWaterDrink ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    if(value == selectedWaterDrink)
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
                                              if(index + 1 != selectedDrink!.subList!.length)
                                                Container(
                                                  color: AppColors.seaColor,
                                                  height: 1,
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                        : Container(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Column(
                      children: [
                        if (openAdds())
                          Column(
                            children: [
                              SizedBox(height: 15.h),
                              if (itemAdds.isNotEmpty)
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: 24.w,
                                    runSpacing: 12.h,
                                    children: [
                                      for (var item in itemAdds)
                                        IntrinsicWidth(
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 29.h,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.r),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: AppColors.limeColor,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 12.w, right: 90.w),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      item.title,
                                                      style: TextStyle(
                                                        fontFamily: "Inter",
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14.sp,
                                                        color: AppColors.vivaMagentaColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                  width: 78.w,
                                                  height: 29.h,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: AppColors.vivaMagentaColor),
                                                  child: Center(
                                                    child: Text(
                                                      "${item.quantity}(${item.measure})",
                                                      style: TextStyle(
                                                        fontFamily: "Inter",
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14.sp,
                                                        color: AppColors.basicwhiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              if (itemAdds.isNotEmpty) SizedBox(height: 24.h),
                              WidgetButton(
                                boxShadow: true,
                                onTap: () {
                                  List<ItemAdds> addsList = [];

                                  if(widget.indexChosenDrink == 7){
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
                                          title: 'Выберите добавку',
                                          content: ClientFoodDiaryAddsSheet(
                                            foodId: widget.indexChosenDrink,
                                            itemAdds: itemAdds,
                                            addsList: addsList,
                                            showMilk: ((widget.indexChosenDrink == 6 || widget.indexChosenDrink == 0 || widget.indexChosenDrink == 1 || widget.indexChosenDrink == 13) && selectedDrink != null && selectedDrink!.subList != null && selectedDrink!.subList!.isNotEmpty) ? true : false,
                                          ),
                                        ),
                                      ).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            itemAdds.clear();
                                            itemAdds = value as List<ItemDrinkAddsItem>;
                                          });
                                        }
                                      });
                                    });
                                  }
                                  else{
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
                                        title: 'Выберите добавку',
                                        content: ClientFoodDiaryAddsSheet(
                                          foodId: widget.indexChosenDrink,
                                          addsList: addsList,
                                          itemAdds: itemAdds,
                                          showMilk: ((widget.indexChosenDrink == 6 || widget.indexChosenDrink == 0 || widget.indexChosenDrink == 1 || widget.indexChosenDrink == 13) && selectedDrink != null && selectedDrink!.subList != null && selectedDrink!.subList!.isNotEmpty) ? true : false,
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          itemAdds.clear();
                                          itemAdds = value as List<ItemDrinkAddsItem>;
                                        });
                                      }
                                    });
                                  }
                                },
                                gradient: AppColors.multigradientColor,
                                text: 'Выберите добавку*'.toUpperCase(),
                                textColor: AppColors.darkGreenColor,
                              ),
                              SizedBox(height: 4.h),
                              SizedBox(
                                height: 32.h,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                                      child: CircleAvatar(
                                        radius: 1.5,
                                        backgroundColor: AppColors.darkGreenColor,
                                      ),
                                    ),
                                    Text(
                                      'Можно добавить напиток без добавок',
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        SizedBox(height: 20.h),
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
                          decoration: BoxDecoration(
                            gradient: AppColors.gradientTurquoise,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: 16.h,
                            children: [
                              for (var portion in foodDiaryStorage.items)
                                FormForButton(
                                  borderRadius: BorderRadius.circular(8.r),
                                  onPressed: () {
                                    setState(() {
                                      if (choosePortion.contains(portion)) {
                                        choosePortion.remove(portion);
                                      } else {
                                        choosePortion.add(portion);
                                      }
                                    });
                                  },
                                  child: "$portion" == '1000'
                                      ? Center(
                                          child: PortionButton(
                                            isChoose: choosePortion.contains(portion),
                                            textColor: AppColors.darkGreenColor,
                                            backgroundColor: AppColors.basicwhiteColor,
                                            textColorChoose: AppColors.basicwhiteColor,
                                            backgroundColorChoose: AppColors.darkGreenColor,
                                            borderColor: AppColors.greenColor,
                                            text: "$portion",
                                          ),
                                        )
                                      : PortionButton(
                                          isChoose: choosePortion.contains(portion),
                                          textColor: AppColors.darkGreenColor,
                                          backgroundColor: AppColors.basicwhiteColor,
                                          textColorChoose: AppColors.basicwhiteColor,
                                          backgroundColorChoose: AppColors.darkGreenColor,
                                          borderColor: AppColors.greenColor,
                                          text: "$portion",
                                        ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        FormForButton(
                          borderRadius: BorderRadius.circular(8.r),
                          onPressed: (){
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
                                title: 'Введите объем, мл',
                                content: ClientFoodDiaryMlBottomSheet(
                                  oldText: valueMlSelected != null ? valueMlSelected.toString() : null,
                                ),
                              ),
                            ).then((value){
                              if(value == true){
                                setState(() {
                                  valueMlSelected = null;
                                  choosePortion.removeWhere((data) => data == value);
                                  portionController.clear();
                                });
                              }
                              else if(value != null){
                                setState(() {
                                  valueMlSelected = int.parse(value);
                                  portionController.text = value;
                                  choosePortion.add(value);
                                });
                              }
                            });
                          },
                          child: CustomTextFieldLabel(
                            isSmall: true,
                            hintText: 'Свой вариант',
                            maxLength: 5,
                            enabled: false,
                            hintColor: AppColors.darkGreenColor,
                            controller: portionController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(height: 160.h),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 15.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.basicwhiteColor.withOpacity(0.3),
                            AppColors.basicwhiteColor,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: AppColors.basicwhiteColor,
                      padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 14.h, top: 10.h),
                      child: Row(
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
                                    }
                                  }

                                  int allPortion = 0;

                                  choosePortion.forEach((element) {
                                    int value = int.parse(element);
                                    allPortion = allPortion + value;
                                  });

                                  ItemDrink drinkItem = foodDiaryStorage.listOfItemDrink[widget.indexChosenDrink];
                                  double calories = 0;
                                  double addsCalories = 0;

                                  if (itemAdds.isNotEmpty) {
                                    itemAdds.forEach((element) {
                                      addsCalories = addsCalories + element.calorie;
                                    });
                                  }

                                  if((widget.indexChosenDrink == 6 || widget.indexChosenDrink == 0 || widget.indexChosenDrink == 1 || widget.indexChosenDrink == 13) && selectedDrink!.subList != null && selectedDrink!.subList!.isNotEmpty){
                                    if(selectedDrink == null){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                            'Выберите вид напитка',
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
                                      if(selectedWaterDrink != null){
                                        calories = (selectedWaterDrink!.calorie * allPortion) / selectedWaterDrink!.portion;

                                        final userDrink = Drink(
                                            id: widget.indexChosenDrink,
                                            foodName: selectedWaterDrink!.text,
                                            calories: calories.toInt() + addsCalories.toInt(),
                                            portion: allPortion);

                                        if(widget.view != null){
                                          validate(selectedWaterDrink!.text, calories.toInt() + addsCalories.toInt(), allPortion);
                                        }
                                        else{
                                          context.router.maybePop(userDrink);
                                        }
                                      }
                                      else{
                                        calories = (selectedDrink!.calorie * allPortion) / selectedDrink!.ml;

                                        final userDrink = Drink(
                                            id: widget.indexChosenDrink,
                                            foodName: selectedDrink!.title,
                                            calories: calories.toInt() + addsCalories.toInt(),
                                            portion: allPortion);

                                        if(widget.view != null){
                                          validate(selectedDrink!.title, calories.toInt() + addsCalories.toInt(), allPortion);
                                        }
                                        else{
                                          context.router.maybePop(userDrink);
                                        }
                                      }
                                    }

                                  }

                                  if (drinkItem.calorie != null && addsDrinks.isEmpty) {
                                    calories = (drinkItem.calorie! * allPortion) / 100;

                                    final userDrink = Drink(
                                        id: widget.indexChosenDrink,
                                        foodName: drinkItem.title,
                                        calories: calories.toInt() + addsCalories.toInt(),
                                        portion: allPortion);

                                    if(widget.view != null){
                                      validate(drinkItem.title, calories.toInt() + addsCalories.toInt(), allPortion);
                                    }
                                    else{
                                      context.router.maybePop(userDrink);
                                    }
                                  }

                                  else if(widget.indexChosenDrink == 5){
                                    if(selectedDrink == null){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                            'Выберите вид напитка',
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
                                      calories = (selectedDrink!.calorie * allPortion) / selectedDrink!.ml;

                                      final userDrink = Drink(
                                          id: widget.indexChosenDrink,
                                          foodName: selectedDrink!.title,
                                          calories: calories.toInt() + addsCalories.toInt(),
                                          portion: allPortion);

                                      if(widget.view != null){
                                        validate(selectedDrink!.title, calories.toInt() + addsCalories.toInt(), allPortion);
                                      }
                                      else{
                                        context.router.maybePop(userDrink);
                                      }
                                    }
                                  }

                                  else if(widget.indexChosenDrink == 6){
                                    if(selectedDrink == null){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                            'Выберите вид напитка',
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
                                      if(selectedWaterDrink != null){
                                        calories = (selectedWaterDrink!.calorie * allPortion) / selectedWaterDrink!.portion;

                                        final userDrink = Drink(
                                            id: widget.indexChosenDrink,
                                            foodName: selectedWaterDrink!.text,
                                            calories: calories.toInt() + addsCalories.toInt(),
                                            portion: allPortion);

                                        if(widget.view != null){
                                          validate(selectedWaterDrink!.text, calories.toInt() + addsCalories.toInt(), allPortion);
                                        }
                                        else{
                                          context.router.maybePop(userDrink);
                                        }
                                      }
                                      else{
                                        calories = (selectedDrink!.calorie * allPortion) / selectedDrink!.ml;

                                        final userDrink = Drink(
                                            id: widget.indexChosenDrink,
                                            foodName: selectedDrink!.title,
                                            calories: calories.toInt() + addsCalories.toInt(),
                                            portion: allPortion);

                                        if(widget.view != null){
                                          validate(selectedDrink!.title, calories.toInt() + addsCalories.toInt(), allPortion);
                                        }
                                        else{
                                          context.router.maybePop(userDrink);
                                        }
                                      }
                                    }
                                  }

                                  else if (addsDrinks.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 3),
                                        content: Text(
                                          'Выберите вид напитка',
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

                                  else if (addsDrinks.isNotEmpty) {
                                    ItemDrinkItem drink = drinkItem.addsList.firstWhere((element) => element.type == addsDrinks);

                                    calories = (drink.calorie * allPortion) / drink.ml;

                                    final userDrink = Drink(
                                        id: widget.indexChosenDrink,
                                        foodName: drink.title,
                                        calories: calories.toInt() + addsCalories.toInt(),
                                        portion: allPortion);

                                    if(widget.view != null){
                                      validate(drink.title, calories.toInt() + addsCalories.toInt(), allPortion);
                                    }
                                    else{
                                      context.router.maybePop(userDrink);
                                    }
                                  }
                                }

                                else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                        'Выберите значение, мл',
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
                                widget.view != null ? "редактировать".toUpperCase() : 'добавить в дневник'.toUpperCase(),
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
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientTurquoiseReverse,
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
                        widget.view != null ? "Изменить напиток" : 'Добавить напиток',
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
            ],
          ),
        ),
      ),
    );
  }

  validate(String title, int calories, int portion) async{
    context.loaderOverlay.show();
    final response = await FoodDiaryService().addFoodDiary(ClientFoodCreateRequest(
      waters: null,
      drinks: [Drink(
        id: widget.view?.id,
        portion: portion,
        foodName: title,
        calories: calories,
        foodPeriod: widget.view?.foodPeriod,
        foodTime: widget.view?.foodTime,
        comment: widget.view?.comment
      )],
      foods: null,
    ));


    if (response.result) {
      context.loaderOverlay.hide();
      context.router.maybePop(true);
    }

    else {
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

  bool openAdds() {
    if (widget.indexChosenDrink == 2 || widget.indexChosenDrink == 3 || widget.indexChosenDrink == 4 || widget.indexChosenDrink == 8 || widget.indexChosenDrink == 14) {
      return false;
    }
    return true;
  }

  check() {
    if (widget.view != null) {
      if(widget.view?.portion != null){
        if(foodDiaryStorage.items.contains(widget.view!.portion!.toString())){
          setState(() {
            choosePortion.add(widget.view!.portion!.toString());
          });
        }
        else{
          setState(() {
            portionController.text = widget.view!.portion!.toString();
          });
        }

      }

      if(widget.view?.foodName != null){
        if(widget.indexChosenDrink == 5){
          ItemDrink itemDrink = foodDiaryStorage.listOfItemDrink.elementAt(5);

          itemDrink.addsList.forEach((element){
            if(element.title == widget.view!.foodName!){
              setState(() {
                selectedDrink = element;
              });
            }
          });
        }
        else if(widget.indexChosenDrink == 0 || widget.indexChosenDrink == 1 ||
            widget.indexChosenDrink == 3 || widget.indexChosenDrink > 8
        ){
          ItemDrink itemDrink = foodDiaryStorage.listOfItemDrink.elementAt(widget.indexChosenDrink);

          itemDrink.addsList.forEach((element){
            if(element.title == widget.view!.foodName){
              setState(() {
                addsDrinks = element.type;
                selectedDrink = element;
              });
            }
          });

        }

        else if(widget.indexChosenDrink == 6){
          ItemDrink itemDrink = foodDiaryStorage.listOfItemDrink.elementAt(6);

          itemDrink.addsList.forEach((element){
            if(element.title == widget.view!.foodName!){
              setState(() {
                addsDrinks = element.type;
                selectedDrink = element;
              });
            }

            if(element.subList != null && element.subList!.isNotEmpty){
              element.subList!.forEach((item){
                if(item.text == widget.view!.foodName!){
                  setState(() {
                    addsDrinks = element.type;
                    selectedDrink = element;
                    selectedWaterDrink = item;
                  });
                }
              });
            }
          });
        }
      }
    }
  }
}
