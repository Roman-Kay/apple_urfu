import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/recipes/recipes_today/recipes_today_cubit.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/client/recipes/recipes_service.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ClientRecipesHorizontalList extends StatefulWidget {
  const ClientRecipesHorizontalList({super.key});

  @override
  State<ClientRecipesHorizontalList> createState() => _ClientRecipesHorizontalListState();
}

class _ClientRecipesHorizontalListState extends State<ClientRecipesHorizontalList> {

  @override
  void initState() {
    if(BlocProvider.of<RecipesTodayCubit>(context).state is RecipesTodayLoadedState){}else{
      context.read<RecipesTodayCubit>().check();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesTodayCubit, RecipesTodayState>(
        builder: (context, state) {
          if (state is RecipesTodayLoadedState) {
            if (state.view != null && state.view!.isNotEmpty) {

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.basicwhiteColor,
                  gradient: null,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 64.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Рецепты дня',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.darkGreenColor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              height: 36.h,
                              width: 160.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: AppColors.darkGreenColor.withOpacity(0.3),
                                ),
                              ),
                              child: FormForButton(
                                borderRadius: BorderRadius.circular(4.r),
                                onPressed: () {
                                  context.router.push(ClientRecipesMainRoute());
                                },
                                child: Center(
                                  child: Text(
                                    'все рецепты'.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.darkGreenColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250.h,
                      child: Center(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.view?.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 230.h,
                              width: 284.w,
                              margin: EdgeInsets.only(
                                top: 16.h,
                                left: index == 0 ? 14.w : 22.w,
                                right: index + 1 == state.view?.length ? 14.w : 0,
                                bottom: 16.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.basicblackColor.withOpacity(0.15),
                                    blurRadius: 10.r,
                                  )
                                ],
                              ),
                              child: FormForButton(
                                borderRadius: BorderRadius.circular(8.r),
                                onPressed: () {
                                  if(state.view?[index].recipeId != null){
                                    context.router.push(ClientRecipesCardInfoRoute(
                                      recipeId: state.view![index].recipeId!,
                                    ));
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    Flexible(
                                      child: Text(
                                        state.view?[index].recipeName ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: AppColors.darkGreenColor,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      height: 94.h,
                                      width: 284.w,
                                      child: Stack(
                                        children: [
                                          state.view?[index].file?.fileBase64 != null
                                              ? CachedMemoryImage(
                                            uniqueKey: "app://reception/recept_photo/${state.view?[index].recipeId}",
                                            base64: state.view?[index].file?.fileBase64,
                                            fit: BoxFit.cover,
                                            width: 284.w,
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
                                                    if(state.view?[index].recipeId != null && state.view?[index].favorites != true){
                                                      context.loaderOverlay.show();
                                                      final service = RecipesService();

                                                      final response = await service.addRecipesFavorites(state.view?[index].recipeId);

                                                      if(response.result){
                                                        GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.makeFavoriteReceiptClient);

                                                        context.loaderOverlay.hide();
                                                        setState(() {
                                                          state.view?[index].favorites = true;
                                                        });
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
                                                    else if(state.view?[index].recipeFavoritesId != null && state.view?[index].favorites == true){
                                                      context.loaderOverlay.show();
                                                      final service = RecipesService();

                                                      final response = await service.deleteRecipesFavorites(state.view![index].recipeFavoritesId!);

                                                      if(response.result){
                                                        GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.deleteFavoriteReceiptClient);

                                                        context.loaderOverlay.hide();
                                                        setState(() {
                                                          state.view?[index].favorites = false;
                                                        });
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
                                                      state.view?[index].favorites == true
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
                                    SizedBox(height: 8.h),
                                    SizedBox(
                                      width: 268.w,
                                      child: Text(
                                        state.view?[index].recipeDesc ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: AppColors.darkGreenColor.withOpacity(0.7),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return Container();
        });
  }

}
