import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/data/repository/food_diary_storage.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';

@RoutePage()
class ClientFoodDiaryAddDrinkScreen extends StatefulWidget {
  const ClientFoodDiaryAddDrinkScreen({super.key});

  @override
  State<ClientFoodDiaryAddDrinkScreen> createState() => _ClientFoodDiaryAddDrinkScreenState();
}

class _ClientFoodDiaryAddDrinkScreenState extends State<ClientFoodDiaryAddDrinkScreen> {
  FoodDiaryStorage storage = FoodDiaryStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: (56 + 20).h),
                    ListView.builder(
                      itemCount: storage.listOfItemDrink.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        List listOfIndexDrinks = List.generate(
                          index + 1 != storage.listOfItemDrink.length ? 2 : 1,
                          (int i) => storage.listOfItemDrink[index + i],
                        );

                        return index % 2 != 0
                            ? const SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (var drink in listOfIndexDrinks)
                                      ClipRRect(
                                        clipBehavior: Clip.hardEdge,
                                        borderRadius: BorderRadius.circular(8.r),
                                        child: SizedBox(
                                          height: 100.h,
                                          width: 164.w,
                                          child: FormForButton(
                                            borderRadius: BorderRadius.circular(8.r),
                                            onPressed: () {
                                              context.router
                                                  .push(ClientFoodDiaryAddDrinkSecondRoute(
                                                view: null,
                                                indexChosenDrink: index + listOfIndexDrinks.indexOf(drink),
                                              ))
                                                  .then((value) {
                                                if (value != null) {
                                                  context.router.maybePop(value);
                                                }
                                              });
                                            },
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  height: 100.h,
                                                  width: 164.w,
                                                  child: Image.asset(
                                                    drink.image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Container(
                                                  height: 100.h,
                                                  width: 164.w,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        AppColors.basicblackColor.withOpacity(0),
                                                        AppColors.basicblackColor.withOpacity(0.8),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(bottom: 8.h),
                                                    child: SizedBox(
                                                      width: 148.w,
                                                      child: Text(
                                                        drink.title.toUpperCase(),
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontFamily: 'Inter',
                                                          fontWeight: FontWeight.w700,
                                                          color: AppColors.basicwhiteColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                      },
                    ),
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
                        'Добавить напиток',
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
    );
  }
}
