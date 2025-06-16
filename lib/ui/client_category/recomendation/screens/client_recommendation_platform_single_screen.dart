import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:garnetbook/bloc/client/recommendation/single_recommendation/single_recommendation_bloc.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';

@RoutePage()
class ClientRecommendationPlatformSingleScreen extends StatefulWidget {
  const ClientRecommendationPlatformSingleScreen({
    super.key,
    required this.id,
    required this.name,
    required this.type
  });

  final int id;
  final String name;
  final String type;

  @override
  State<ClientRecommendationPlatformSingleScreen> createState() => _ClientRecommendationPlatformSingleScreenState();
}

class _ClientRecommendationPlatformSingleScreenState extends State<ClientRecommendationPlatformSingleScreen> {

  @override
  void initState() {
    context.read<SingleRecommendationBloc>().add(SingleRecommendationGetEvent(widget.id, widget.type));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.darkGreenColor,
              onRefresh: () {
                context.read<SingleRecommendationBloc>().add(SingleRecommendationGetEvent(widget.id, widget.type));
                return Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: BlocBuilder<SingleRecommendationBloc, SingleRecommendationState>(
                    builder: (context, state) {
                      if(state is SingleRecommendationLoadedState){

                        if(state.data != null){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 56.h + 20.h),

                              if(state.data?.image != null && state.data?.image?.content != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: CachedMemoryImage(
                                    uniqueKey: 'app://recommendation_single/photo_${widget.id}/${widget.name}',
                                    base64: state.data?.image?.content,
                                    fit: BoxFit.cover,
                                    width: 360.w,
                                    height: 350.h,
                                  ),
                                ),
                              if(state.data?.image != null && state.data?.image?.content != null)
                                SizedBox(height: 15.h),

                              if(state.data?.content != null)
                                HtmlWidget(
                                  state.data!.content!,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    fontFamily: 'Inter',
                                    color: AppColors.darkGreenColor,
                                  ),
                                  onLoadingBuilder: (context, element, item){
                                    return SizedBox(
                                        height: MediaQuery.of(context).size.height / 1.3,
                                        child: ProgressIndicatorWidget());
                                  },
                                ),

                              SizedBox(height: 48.h),
                            ],
                          );
                        }
                        else{
                          return  Container(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height / 1.1,
                                  child: Center(
                                    child: Text(
                                      "Данные скоро появятся",
                                      style: TextStyle(
                                          color: AppColors.darkGreenColor,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      else if(state is SingleRecommendationLoadingState){
                        return SizedBox(
                            height: MediaQuery.of(context).size.height / 1.3,
                            child: ProgressIndicatorWidget());
                      }
                      else if(state is SingleRecommendationErrorState){
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.3,
                          child: ErrorWithReload(
                            callback: () {
                              context.read<SingleRecommendationBloc>().add(SingleRecommendationGetEvent(widget.id, widget.type));
                            },
                          ),
                        );
                      }
                      return Container();
                    }
                  ),
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
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.name,
                        textAlign: TextAlign.center,
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
