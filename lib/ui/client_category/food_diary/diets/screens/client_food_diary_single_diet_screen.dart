import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/diets/diets_full_data/diets_full_data_bloc.dart';
import 'package:garnetbook/data/models/client/food_diary/diets_model.dart';
import 'package:garnetbook/data/repository/receipts_storage.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';

@RoutePage()
class ClientFoodDiarySingleDietScreen extends StatefulWidget {
  const ClientFoodDiarySingleDietScreen({super.key, required this.id});
  final int id;

  @override
  State<ClientFoodDiarySingleDietScreen> createState() => _ClientFoodDiarySingleDietScreenState();
}

class _ClientFoodDiarySingleDietScreenState extends State<ClientFoodDiarySingleDietScreen> {
  double heightSafeArea = 0;
  bool isCategoryOpen = false;
  List<DietProductView> productList = [];
  bool isInit = false;

  Map<String, int> colorList = {
    "красный": 1,
    "оранжевый": 2,
    "желтый": 3,
    "зеленый": 4,
    "темно-зеленый": 5,
  };

  List<String> ratingList = ["Разрешено с ограничением", "Разрешено с 2 ограничениями", "Совсем чуть-чуть", "Запрещено"];

  @override
  void initState() {
    context.read<DietsFullDataBloc>().add(DietsFullDataGetEvent(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<DietsFullDataBloc, DietsFullDataState>(builder: (context, state) {
              if (state is DietsFullDataLoadedState) {
                getView(state.view);

                return RefreshIndicator(
                  color: AppColors.darkGreenColor,
                  onRefresh: () {
                    context.read<DietsFullDataBloc>().add(DietsFullDataGetEvent(widget.id));
                    return Future.delayed(const Duration(seconds: 1));
                  },
                  child: ListView(
                    children: [
                      SizedBox(height: (56 + 24).h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 14.w),
                        width: double.infinity,
                        decoration:
                            BoxDecoration(gradient: AppColors.gradientTurquoise, borderRadius: BorderRadius.circular(8.r), boxShadow: [
                          BoxShadow(
                            color: AppColors.grey70Color.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          )
                        ]),
                        child: FormForButton(
                          borderRadius: BorderRadius.circular(8.r),
                          onPressed: () => setState(() {
                            isCategoryOpen = !isCategoryOpen;
                          }),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: AppColors.basicwhiteColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                                  child: Text(
                                    "Значения цветовой градации продуктов:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      fontFamily: 'Inter',
                                      color: AppColors.darkGreenColor,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: !isCategoryOpen ? Radius.circular(8.r) : Radius.zero,
                                    bottomRight: !isCategoryOpen ? Radius.circular(8.r) : Radius.zero,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12.r,
                                      backgroundColor: getRatingColor(0),
                                      child: Icon(
                                        Icons.check,
                                        color: AppColors.basicwhiteColor,
                                        size: 18.r,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      "Разрешено",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                        fontFamily: 'Inter',
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                    Spacer(),
                                    Transform.flip(
                                      flipY: isCategoryOpen,
                                      child: Transform.rotate(
                                        angle: pi / 2,
                                        child: SvgPicture.asset(
                                          'assets/images/arrow_black.svg',
                                          color: AppColors.darkGreenColor,
                                          height: 24.h,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: isCategoryOpen,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(8.r),
                                      bottomLeft: Radius.circular(8.r),
                                    ),
                                    //elevation: 1,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(8.r),
                                            bottomLeft: Radius.circular(8.r),
                                          ),
                                          gradient: AppColors.gradientTurquoise),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: 300,
                                          minHeight: 50,
                                        ),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: ratingList.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.r),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 14.w),
                                                    CircleAvatar(
                                                      radius: 12.r,
                                                      backgroundColor: getRatingColor(index + 1),
                                                      child: Icon(
                                                        Icons.check,
                                                        color: index + 1 == 2 ? AppColors.darkGreenColor : AppColors.basicwhiteColor,
                                                        size: 18.r,
                                                      ),
                                                    ),
                                                    SizedBox(width: 12.w),
                                                    Text(
                                                      ratingList[index],
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: "Inter",
                                                          color: AppColors.darkGreenColor),
                                                    ),
                                                    SizedBox(width: 14.w),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Text(
                          'Список продуктов:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      productList.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: Wrap(
                                runSpacing: 16.h,
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  for (var eatButtonModal in productList)
                                    DietProductButtonContainer(
                                      dietProductView: eatButtonModal,
                                    ),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                              child: Center(
                                child: Text(
                                  "Данные отсутвуют",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 14.sp, fontFamily: "Inter", color: AppColors.darkGreenColor),
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              } else if (state is DietsFullDataLoadingState) {
                return SizedBox(height: MediaQuery.of(context).size.height / 1.2, child: ProgressIndicatorWidget());
              } else if (state is DietsFullDataErrorState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: ErrorWithReload(
                    callback: () {
                      context.read<DietsFullDataBloc>().add(DietsFullDataGetEvent(widget.id));
                    },
                  ),
                );
              }
              return Container();
            }),
            Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                color: AppColors.basicwhiteColor,
              ),
              child: Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.r,
                      color: AppColors.basicblackColor.withOpacity(0.15),
                      offset: Offset(0, 2),
                    ),
                  ],
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
                        'Конструктор',
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

  getView(Diets? view) {
    if (view != null && view.productGroups != null && view.productGroups!.isNotEmpty && !isInit) {
      view.productGroups!.forEach((element) {
        if (element.productGroupName != null) {
          if (element.products != null && element.products!.isNotEmpty) {
            Map<String, int> productMap = {};

            element.products!.forEach((item) {
              if (item.productName != null) {
                productMap.putIfAbsent(
                    item.productName!, () => item.color != null && colorList.containsKey(item.color!) ? colorList[item.color] ?? 0 : 0);
              }
            });

            if (productMap.isNotEmpty) {
              DietProductView productView = ReceiptsStorage().productList.firstWhere((data) => data.text == element.productGroupName!);

              DietProductView itemView =
                  DietProductView(text: productView.text, name: productView.name, productList: productMap, image: productView.image);

              productList.add(itemView);
            }
          }
        }
      });

      isInit = true;
    }
  }

  Color getRatingColor(int index) {
    if (index == 0)
      return AppColors.darkGreenColor;
    else if (index == 1)
      return AppColors.greenLightColor;
    else if (index == 2)
      return AppColors.yellowColor;
    else if (index == 3)
      return AppColors.orangeColor;
    else
      return AppColors.redColor;
  }
}

class DietProductButtonContainer extends StatelessWidget {
  final DietProductView dietProductView;
  const DietProductButtonContainer({super.key, required this.dietProductView});

  @override
  Widget build(BuildContext context) {
    final List<int> checkMarksList = getCheckMarksList(dietProductView);

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        height: 64.h,
        width: 160.w,
        child: FormForButton(
          borderRadius: BorderRadius.circular(8.r),
          onPressed: () {},
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.darkGreenColor,
              ),
              if (dietProductView.image != null)
                Image.asset(
                  dietProductView.image!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              Container(
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
                child: Center(
                  child: checkMarksList.isNotEmpty
                      ? Row(
                          children: [
                            SizedBox(width: 8.w),
                            Stack(
                              children: [
                                checkMark(
                                  checkMarksList: checkMarksList,
                                  raiting: 1,
                                  backColor: AppColors.redColor,
                                ),
                                checkMark(
                                  checkMarksList: checkMarksList,
                                  raiting: 2,
                                  backColor: AppColors.orangeColor,
                                ),
                                checkMark(
                                  checkMarksList: checkMarksList,
                                  raiting: 3,
                                  backColor: AppColors.yellowColor,
                                  colorIcon: AppColors.darkGreenColor,
                                ),
                                checkMark(
                                  checkMarksList: checkMarksList,
                                  raiting: 4,
                                  backColor: AppColors.greenLightColor,
                                ),
                                checkMark(
                                  checkMarksList: checkMarksList,
                                  raiting: 5,
                                  backColor: AppColors.darkGreenColor,
                                ),
                              ],
                            ),
                            SizedBox(width: 8.w),
                            Flexible(
                              child: Text(
                                dietProductView.text.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                  fontFamily: 'Inter',
                                  color: AppColors.basicwhiteColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 8.w),
                            Flexible(
                              child: Text(
                                dietProductView.text.toUpperCase(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                  fontFamily: 'Inter',
                                  color: AppColors.basicwhiteColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
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

  Widget checkMark({required List<int> checkMarksList, required int raiting, required Color backColor, Color? colorIcon}) {
    if (checkMarksList.indexOf(raiting) != -1) {
      return Padding(
        padding: EdgeInsets.only(top: checkMarksList.indexOf(raiting) * 9.r),
        child: CircleAvatar(
          radius: 8.r,
          backgroundColor: backColor,
          child: Center(
              child: SvgPicture.asset(
            'assets/images/checkmark.svg',
            color: colorIcon ?? AppColors.basicwhiteColor,
            width: 16.r,
          )),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  List<int> getCheckMarksList(DietProductView eatButtonModal) {
    // Вспомогательны лист где мы складываем обшие чек марки.
    final List<int> listCheckMarks = [];
    // Перебор каждого рейтинга.
    for (var integer in [1, 2, 3, 4, 5]) {
      // Если и так у нас все чек марки (их максимум 5), то стопаем функцию.
      if (listCheckMarks.length == 5) {
        break;
      }
      // Запускаем перебор каждого елемента и смотрим его рейтинг.
      for (int element in eatButtonModal.productList.values) {
        // Если рейтинга еще нет в списке добавляем его
        if (element == integer && listCheckMarks.any((i) => i == integer) == false) {
          listCheckMarks.add(integer);
          // стопаем функцию с заданым рейтингом.
          break;
        }
      }
    }
    return listCheckMarks;
  }
}
