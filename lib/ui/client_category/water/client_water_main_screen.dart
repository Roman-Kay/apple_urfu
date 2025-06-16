import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/water_diary/water_diary_bloc.dart';
import 'package:garnetbook/bloc/client/water_diary/water_diary_chart/water_diary_chart_bloc.dart';
import 'package:garnetbook/ui/client_category/water/tab_bar/client_water_tabbar_check.dart';
import 'package:garnetbook/ui/client_category/water/tab_bar/client_water_tabbar_dynamic.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';

@RoutePage()
class ClientWaterMainScreen extends StatefulWidget {
  const ClientWaterMainScreen({super.key, this.isFromFoodDiary});
  final String? isFromFoodDiary;

  @override
  State<ClientWaterMainScreen> createState() => _ClientWaterMainScreenState();
}

class _ClientWaterMainScreenState extends State<ClientWaterMainScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);

    if (BlocProvider.of<WaterDiaryBloc>(context).state is WaterDiaryGetState) {
    } else {
      context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(DateTime.now()));
    }

    context.read<WaterDiaryChartBloc>().add(WaterDiaryChartGetEvent(DateTime.now().month, DateTime.now().year));

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double heightSafeArea = constraints.maxHeight;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        Center(
                          child: Text(
                            'Питьевой режим',
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
                  Container(
                    width: double.infinity,
                    height: heightSafeArea - 56.h,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/limonade.webp',
                          width: double.infinity,
                          height: double.infinity - 56.h,
                          fit: BoxFit.cover,
                        ),
                        Column(
                          children: [
                            Container(
                              color: AppColors.basicwhiteColor.withOpacity(0.1),
                              height: 54.h,
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [

                                      TabBar(
                                        indicatorColor: AppColors.darkGreenColor,
                                        controller: tabController,
                                        labelColor: AppColors.darkGreenColor,
                                        unselectedLabelColor: AppColors.darkGreenColor.withOpacity(0.5),
                                        indicatorSize: TabBarIndicatorSize.label,
                                        labelStyle: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        tabs: [
                                          SizedBox(
                                            width: 150.w,
                                            height: 56.h,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Tab(
                                                height: 56.h,
                                                text: 'Отслеживание',
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 150.w,
                                            height: 56.h,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Tab(
                                                height: 56.h,
                                                text: 'Динамика',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: AppColors.basicwhiteColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: heightSafeArea - 56.h - 54.h,
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  ClientWaterTabBarWatterCheck(isFromFoodDiary: widget.isFromFoodDiary),
                                  ClientWaterTabBarDynamic(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
