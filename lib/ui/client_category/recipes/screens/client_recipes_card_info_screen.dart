// ignore_for_file: must_be_immutable

import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:garnetbook/bloc/client/recipes/recipes_all/recipes_all_cubit.dart';
import 'package:garnetbook/bloc/client/recipes/recipes_today/recipes_today_cubit.dart';
import 'package:garnetbook/data/models/client/recipes/recipes_response.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/client/recipes/recipes_service.dart';
import 'package:garnetbook/ui/client_category/recipes/components/client_recipes_recommendation_list.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';


@RoutePage()
class ClientRecipesCardInfoScreen extends StatefulWidget {
  ClientRecipesCardInfoScreen({super.key, required this.recipeId, this.isFromExpert = false});

  bool isFromExpert;
  final int recipeId;

  @override
  State<ClientRecipesCardInfoScreen> createState() => _ClientRecipesCardInfoScreenState();
}

class _ClientRecipesCardInfoScreenState extends State<ClientRecipesCardInfoScreen> {
  List<String> ingredientsList = [];
  RecipesView? recipe;


  @override
  void initState() {
    if(BlocProvider.of<RecipesAllCubit>(context).state is RecipesAllLoadedState){}else{
      context.read<RecipesAllCubit>().check();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<RecipesAllCubit, RecipesAllState>(
              builder: (context, state) {
                if(state is RecipesAllLoadedState){
                  getIngredients(state.view);

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 56.h + 20.h),
                              SizedBox(
                                width: (349 - 16).w,
                                child: Text(
                                  recipe?.recipeName ?? "",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.darkGreenColor,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 18.h),
                              SizedBox(
                                height: 116.h,
                                width: 349.w,
                                child: Stack(
                                  children: [
                                    recipe?.file?.fileBase64 != null
                                        ? CachedMemoryImage(
                                      uniqueKey: "app://reception/recept_photo/${recipe?.recipeId}",
                                      base64: recipe!.file!.fileBase64!,
                                      fit: BoxFit.cover,
                                      width: 349.w,
                                      height: 116.h,
                                    )
                                        : Container(
                                      decoration: BoxDecoration(
                                        gradient: AppColors.gradientTurquoise,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.photo,
                                          size: 30,
                                          color: AppColors.darkGreenColor,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.h),
                                        child: Container(
                                          width: 32.r,
                                          height: 32.r,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(32.r),
                                            color: Color(0xC7FFFFFF),
                                          ),
                                          child: FormForButton(
                                            borderRadius: BorderRadius.circular(32.r),
                                            onPressed: () async{
                                              if(recipe?.recipeId != null && recipe?.favorites != true){
                                                context.loaderOverlay.show();
                                                final service = RecipesService();

                                                final response = await service.addRecipesFavorites(recipe!.recipeId);

                                                if(response.result){
                                                  GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.makeFavoriteReceiptClient);

                                                  context.loaderOverlay.hide();

                                                  if(widget.isFromExpert){
                                                    context.read<RecipesAllCubit>().check();
                                                  }
                                                  else{
                                                    context.read<RecipesAllCubit>().check();
                                                    context.read<RecipesTodayCubit>().check();
                                                  }
                                                }
                                                else{
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
                                              else if(recipe?.recipeFavoritesId != null){
                                                context.loaderOverlay.show();
                                                final service = RecipesService();

                                                final response = await service.deleteRecipesFavorites(recipe!.recipeFavoritesId!);

                                                if(response.result){
                                                  GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.deleteFavoriteReceiptClient);

                                                  context.loaderOverlay.hide();

                                                  if(widget.isFromExpert){
                                                    context.read<RecipesAllCubit>().check();
                                                  }
                                                  else{
                                                    context.read<RecipesAllCubit>().check();
                                                    context.read<RecipesTodayCubit>().check();
                                                  }

                                                }
                                                else{
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
                                            },
                                            child: Center(
                                              child: SvgPicture.asset(
                                                recipe?.favorites == true
                                                    ? 'assets/images/heart_fill.svg'
                                                    : 'assets/images/heart_outline.svg',
                                                width: 21.w,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'СОСТАВ:',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              SizedBox(
                                width: 370.w,
                                child: ListView.builder(
                                  itemCount: ingredientsList.length,
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return IngredientWidget(
                                      name: ingredientsList[index],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 20.h),
                              recipe != null && recipe?.recipeText != null
                                  ? HtmlWidget(recipe!.recipeText!,
                                  textStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.darkGreenColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ))
                                  : Container(),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                        if(!widget.isFromExpert)
                          ClientRecipesRecommendationList(recipeId: recipe?.recipeId ?? 0),
                      ],
                    ),
                  );
                }
                else if(state is RecipesAllErrorState){
                  return Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: ErrorWithReload(
                        callback: () {
                          context.read<RecipesAllCubit>().check();
                        },
                      ),
                    ),
                  );
                }
                else if(state is RecipesAllLoadingState){
                  return Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Center(
                        child: ProgressIndicatorWidget(),
                      ),
                    ),
                  );
                }
                return Container();
              }
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
                        onPressed: () {
                          context.router.maybePop();
                        },
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
                        'Карточка рецепта',
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

  getIngredients(List<RecipesView>? view) {
    ingredientsList.clear();

    if(view != null && view.isNotEmpty){
      for(var element in view){
        if(element.recipeId == widget.recipeId){
          recipe = element;
          break;
        }
      }
    }


    if (recipe != null && recipe?.recipeDesc != null) {
      ingredientsList = recipe!.recipeDesc!.split(',');
    }
  }

  Widget IngredientWidget(
      {required String name,
      String? weight,
      String? countingSystem,
      bool? isSmall}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: SizedBox(
              //width: isSmall != null ? 100.w : 280.w,
              child: Text(
                name,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.darkGreenColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.seaColor,
          )
        ],
      ),
    );
  }
}
