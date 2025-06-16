import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/recipes/recipes_all/recipes_all_cubit.dart';
import 'package:garnetbook/data/models/client/recipes/recipes_response.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/client/recipes/recipes_service.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';

// ignore: must_be_immutable
class ClientRecipesRecommendationList extends StatefulWidget {
  int recipeId;

  ClientRecipesRecommendationList({super.key, required this.recipeId});

  @override
  State<ClientRecipesRecommendationList> createState() => _ClientRecipesRecommendationListState();
}

class _ClientRecipesRecommendationListState extends State<ClientRecipesRecommendationList> {
  List<RecipesView> receipts = [];

  @override
  void initState() {

    if(BlocProvider.of<RecipesAllCubit>(context).state is RecipesAllLoadedState){}else{
      context.read<RecipesAllCubit>().check();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesAllCubit, RecipesAllState>(
        builder: (context, state) {
          if (state is RecipesAllLoadedState) {

            if (state.view != null && state.view!.isNotEmpty) {
              getList(state.view);

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: null,
                  gradient: AppColors.gradientTurquoiseReverse,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 64.h,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Возможно вам понравятся',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.darkGreenColor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Container(
                        width: double.infinity,
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientTurquoise,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250.h,
                      child: Center(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: receipts.length > 2 ? 2 : receipts.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 230.h,
                              width: 284.w,
                              margin: EdgeInsets.only(
                                top: 16.h,
                                left: index == 0 ? 14.w : 22.w,
                                right: index + 1 == state.view?.length
                                    ? 14.w
                                    : 0,
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
                                  if(receipts[index].recipeId != null){
                                    context.router.push(ClientRecipesCardInfoRoute(
                                      recipeId: receipts[index].recipeId!,
                                    ));
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    SizedBox(
                                      width: 268.w,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          receipts[index].recipeName ?? "",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.darkGreenColor,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      height: 94.h,
                                      width: 284.w,
                                      child: Stack(
                                        children: [
                                          receipts[index].file?.fileBase64 != null
                                              ? CachedMemoryImage(
                                            uniqueKey: "app://reception/recept_photo/${state.view?[index].recipeId}",
                                            base64: receipts[index].file?.fileBase64,
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
                                                    color: Color(0xC7FFFFFFF)),
                                                child: FormForButton(
                                                  borderRadius: BorderRadius.circular(32.r),
                                                  onPressed: () async{
                                                    if(receipts[index].recipeId != null && receipts[index].favorites != true){
                                                      context.loaderOverlay.show();
                                                      final service = RecipesService();

                                                      final response = await service.addRecipesFavorites(receipts[index].recipeId);

                                                      if(response.result){
                                                        GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.makeFavoriteReceiptClient);

                                                        context.loaderOverlay.hide();
                                                        setState(() {
                                                          receipts[index].favorites = true;
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
                                                    else if(receipts[index].recipeFavoritesId != null && receipts[index].favorites == true){
                                                      context.loaderOverlay.show();
                                                      final service = RecipesService();

                                                      final response = await service.deleteRecipesFavorites(receipts[index].recipeFavoritesId!);

                                                      if(response.result){
                                                        GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.deleteFavoriteReceiptClient);

                                                        context.loaderOverlay.hide();
                                                        setState(() {
                                                          receipts[index].favorites = false;
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
                                                      receipts[index].favorites == true
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
                                        receipts[index].recipeDesc ?? "",
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

  getList(view) {
    view?.forEach((element) {
      if (element.recipeId != widget.recipeId) {
        receipts.add(element);
      }
    });
  }
}
