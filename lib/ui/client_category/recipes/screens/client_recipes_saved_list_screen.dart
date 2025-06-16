
import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/recipes/recipes_all/recipes_all_cubit.dart';
import 'package:garnetbook/bloc/client/recipes/recipes_today/recipes_today_cubit.dart';
import 'package:garnetbook/data/models/client/recipes/recipes_response.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/client/recipes/recipes_service.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';


@RoutePage()
class ClientRecipesSavedListScreen extends StatefulWidget {
  const ClientRecipesSavedListScreen({super.key});

  @override
  State<ClientRecipesSavedListScreen> createState() => _ClientRecipesSavedListScreenState();
}

class _ClientRecipesSavedListScreenState extends State<ClientRecipesSavedListScreen> {
  List<RecipesView> list =[];

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
                  if (state is RecipesAllLoadedState) {
                    getList(state.view);

                    if (list.isNotEmpty) {
                      return RefreshIndicator(
                        color: AppColors.darkGreenColor,
                        onRefresh: () {
                          context.read<RecipesAllCubit>().check();
                          return Future.delayed(const Duration(seconds: 1));
                        },
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 56.h + 20.h),
                                ListView.builder(
                                  itemCount: list.length,
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 349.w,
                                      margin: EdgeInsets.only(bottom: 22.h,),
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
                                          if(list[index].recipeId != null){
                                            context.router.push(ClientRecipesCardInfoRoute(
                                              recipeId: list[index].recipeId!,
                                            ));
                                          }
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 10.h),
                                            SizedBox(
                                              width: (349 - 16).w,
                                              child: Text(
                                                list[index].recipeName ?? "",
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: AppColors.darkGreenColor,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            SizedBox(
                                              height: 116.h,
                                              width: double.infinity,
                                              child: Stack(
                                                children: [
                                                  list[index].file?.fileBase64 != null
                                                      ? CachedMemoryImage(
                                                    uniqueKey: "app://reception/recept_photo/${list[index].recipeId}",
                                                    base64: list[index].file!.fileBase64!,
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
                                                          color: Color(0xC7FFFFFF),
                                                          borderRadius: BorderRadius.circular(32.r),
                                                        ),
                                                        child: FormForButton(
                                                          borderRadius: BorderRadius.circular(32.r),
                                                          onPressed: () async{
                                                            if(state.view?[index].recipeFavoritesId != null){
                                                              context.loaderOverlay.show();
                                                              final service = RecipesService();

                                                              final response = await service.deleteRecipesFavorites(state.view![index].recipeFavoritesId!);

                                                              if(response.result){
                                                                GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.deleteFavoriteReceiptClient);

                                                                context.loaderOverlay.hide();
                                                                context.read<RecipesAllCubit>().check();
                                                                context.read<RecipesTodayCubit>().check();
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
                                                              'assets/images/heart_fill.svg',
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
                                              width: (349 - 16).w,
                                              child: Text(
                                                list[index].recipeDesc ?? "",
                                                maxLines: 3,
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
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Center(
                        child: Text(
                          "Данные отсутствуют",
                          style: TextStyle(
                              color: AppColors.darkGreenColor,
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  }
                  else if (state is RecipesAllErrorState) {
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
                  } else if (state is RecipesAllLoadingState) {
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
                }),
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
                        'Избранные рецепты',
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

  getList(List<RecipesView>? view){
    list.clear();

    if(view != null && view.isNotEmpty){
      view.forEach((element){
        if(element.favorites == true){
          list.add(element);
        }
      });
    }
  }
}
