import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/recommendation/platform_recommendation/platform_recommendation_cubit.dart';
import 'package:garnetbook/bloc/client/recommendation/recommendation_cubit.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'tab_bar/client_recomendation_main_tabbar_from_platform.dart';
import 'tab_bar/client_recomendation_main_tabbar_from_specialist.dart';

@RoutePage()
class ClientRecommendationMainScreen extends StatefulWidget {
  const ClientRecommendationMainScreen({super.key, required this.isFormSurvey});
  final bool isFormSurvey;

  @override
  State<ClientRecommendationMainScreen> createState() => _ClientRecommendationMainScreenState();
}

class _ClientRecommendationMainScreenState extends State<ClientRecommendationMainScreen> with TickerProviderStateMixin {
  late TabController tabController;
  List<ItemAnimationModel> list = [];

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);

    if (widget.isFormSurvey) {
      context.read<PlatformRecommendationCubit>().check();
    } else if (BlocProvider.of<PlatformRecommendationCubit>(context).state is PlatformRecommendationLoadedState) {
    } else {
      context.read<PlatformRecommendationCubit>().check();
    }

    if (BlocProvider.of<RecommendationCubit>(context).state is RecommendationLoadedState) {
    } else {
      context.read<RecommendationCubit>().check();
    }

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      body: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: tabController.index == 0 ? AppColors.gradientBasikWhite : AppColors.gradientTurquoiseReverse,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
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
                    SizedBox(width: 15),
                    Center(
                      child: Text(
                        'Рекомендации',
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
              Expanded(
                child: ClientRecommendationMainTabBarFromPlatform(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
