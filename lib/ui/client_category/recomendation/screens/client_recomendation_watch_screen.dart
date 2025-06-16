import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/recommendation/single_expert_recommendation_bloc/single_expert_recommendation_bloc.dart';
import 'package:garnetbook/data/repository/recommendation_repository.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:link_text/link_text.dart';
import 'package:garnetbook/utils/images.dart';

@RoutePage()
class ClientRecommendationWatchScreen extends StatefulWidget {
  const ClientRecommendationWatchScreen({
    required this.id,
    required this.name,
    super.key
  });

  final int id;
  final String name;

  @override
  State<ClientRecommendationWatchScreen> createState() => _ClientRecommendationWatchScreenState();
}

class _ClientRecommendationWatchScreenState extends State<ClientRecommendationWatchScreen> {

  @override
  void initState() {
    context.read<SingleExpertRecommendationBloc>().add(SingleExpertRecommendationGetEvent(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<SingleExpertRecommendationBloc, SingleExpertRecommendationState>(
              builder: (context, state) {
                if(state is SingleExpertRecommendationLoadedState){

                  return RefreshIndicator(
                    color: AppColors.darkGreenColor,
                    onRefresh: (){
                      context.read<SingleExpertRecommendationBloc>().add(SingleExpertRecommendationGetEvent(widget.id));
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: ListView(
                        children: [
                          SizedBox(height: 56.h + 20.h),
                          Image.asset(
                            RecommendationRepository().getButtons(widget.name).bigImageName,
                          ),
                          SizedBox(height: 15.h),
                          if (state.view?.recommendationId != null && state.view?.file != null && state.view?.file?.fileBase64 != null && state.view?.file?.fileBase64 != "")
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: CachedMemoryImage(
                                uniqueKey: 'app://recommendation/photo_${state.view?.recommendationId}',
                                base64: state.view?.file?.fileBase64,
                                fit: BoxFit.cover,
                                width: 360.w,
                                height: 350.h,
                              ),
                            ),

                          LinkText(
                            state.view?.recommendationDesc ?? "",
                            linkStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              decoration: TextDecoration.underline,
                              color: AppColors.darkGreenColor,
                            ),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          GestureDetector(
                            onTap: () {
                              context.router.maybePop();
                            },
                            child: Container(
                              height: 64.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.darkGreenColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: Text(
                                  'к другим рекомендациям'.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp,
                                    fontFamily: 'Inter',
                                    color: AppColors.basicwhiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 48.h),
                        ],
                      ),
                    ),
                  );
                }
                else if(state is SingleExpertRecommendationLoadingState){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: ProgressIndicatorWidget());
                }
                else if(state is SingleExpertRecommendationErrorState){
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: ErrorWithReload(
                      callback: () {
                        context.read<SingleExpertRecommendationBloc>().add(SingleExpertRecommendationGetEvent(widget.id));
                      },
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
                        widget.name,
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

  // checkStatus() async{
  //   if()
  // }
}
