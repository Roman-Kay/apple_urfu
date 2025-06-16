import 'dart:io';
import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/weight/weight_bloc.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/weight/tabbar/client_sensors_weight_check.dart';
import 'package:garnetbook/ui/client_category/sensors/weight/tabbar/client_sensors_weight_dynamic.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/add_fit_button.dart';
import 'package:health/health.dart';

@RoutePage()
class ClientSensorsWeightScreen extends StatefulWidget {
  const ClientSensorsWeightScreen({super.key});

  @override
  State<ClientSensorsWeightScreen> createState() => _ClientSensorsWeightScreenState();
}

class _ClientSensorsWeightScreenState extends State<ClientSensorsWeightScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final _isRequested = RequestedValue();
  final _selectedDate = SelectedDate();
  Health health = Health();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    getRequested();

    if(BlocProvider.of<WeightBloc>(context).state is WeightLoadedState){}else{
      context.read<WeightBloc>().add(WeightGetEvent(7, DateTime.now()));
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            final double heightSafeArea = constraints.maxHeight;
            return Column(
              children: [
                ListenableBuilder(
                  listenable: _isRequested,
                  builder: (context, child) {
                    return Container(
                      width: double.infinity,
                      height: 56.h,
                      color: AppColors.basicwhiteColor,
                      child: Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientTurquoiseReverse,
                        ),
                        child: !_isRequested.isNotRequested && Platform.isAndroid
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        )),
                                  ),
                                  Text(
                                    'Вес',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.sp,
                                      fontFamily: 'Inter',
                                      color: AppColors.darkGreenColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.w),
                                    child: AddFitButton(
                                      onPressed: () {
                                        context.read<WeightBloc>().add(WeightConnectedEvent(7, DateTime.now()));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                alignment: Alignment.center,
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
                                        )),
                                  ),
                                  Text(
                                    'Вес',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.sp,
                                      fontFamily: 'Inter',
                                      color: AppColors.darkGreenColor,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  }
                ),
                Container(
                  width: double.infinity,
                  height: heightSafeArea - 56.h,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/my_day_wiegth.webp',
                        height: double.infinity - 56.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Column(
                        children: [
                          Container(
                            color: AppColors.basicwhiteColor.withOpacity(0.2),
                            height: 54.h,
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: TabBar(
                                  indicatorColor: AppColors.basicwhiteColor,
                                  controller: tabController,
                                  labelColor: AppColors.basicwhiteColor,
                                  unselectedLabelColor: AppColors.basicwhiteColor.withOpacity(0.5),
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
                              ),
                            ),
                          ),
                          SizedBox(
                            height: heightSafeArea - 56.h - 54.h,
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                ClientSensorsWeightCheck(isRequested: _isRequested, selectedDate: _selectedDate),
                                ClientSensorsWeightDynamic(isRequested: _isRequested, selectedDate: _selectedDate),
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
          }),
        ),
      ),
    );
  }

  getRequested() async {
    final requested = Platform.isAndroid
        ? await health.hasPermissions([HealthDataType.WEIGHT], permissions: [HealthDataAccess.READ_WRITE])
        : await health.requestAuthorization([HealthDataType.WEIGHT], permissions: [HealthDataAccess.READ_WRITE]);
    ;

    if (Platform.isAndroid) {
      if (requested == true) {
        _isRequested.select(true);
      } else {
        _isRequested.select(false);
      }
    }
  }
}
