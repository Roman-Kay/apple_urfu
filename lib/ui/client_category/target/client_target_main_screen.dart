import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/target/target_bloc.dart';
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/graphics/target_line_chart.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/percents/prosent_bar_second.dart';

class RecItem {
  final String? name;
  final String? subName;
  final String text;

  RecItem({
    this.name,
    this.subName,
    required this.text,
  });
}

@RoutePage()
class ClientTargetMainScreen extends StatefulWidget {
  const ClientTargetMainScreen({super.key});

  @override
  State<ClientTargetMainScreen> createState() => _ClientTargetMainScreenState();
}

class _ClientTargetMainScreenState extends State<ClientTargetMainScreen> {
  @override
  void initState() {
    if (BlocProvider.of<TargetBloc>(context).state is TargetLoadedState) {
    } else {
      context.read<TargetBloc>().add(TargetCheckEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.backgroundgradientColor),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 7.w, top: 199.h),
                child: SizedBox(
                  height: 83.h,
                  width: 65.w,
                  child: Image.asset(
                    'assets/images/ananas.webp',
                    fit: BoxFit.fill,
                    color: Colors.white24,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 200.h, left: 246.w),
                child: SizedBox(
                  height: 83.h,
                  width: 83.w,
                  child: Image.asset(
                    'assets/images/ananas2.webp',
                    fit: BoxFit.fill,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 566.h, left: 246.w),
                child: SizedBox(
                  height: 83.h,
                  width: 65.w,
                  child: Image.asset(
                    'assets/images/ananas1.webp',
                    fit: BoxFit.fill,
                    color: Colors.white24,
                  ),
                ),
              ),
              BlocBuilder<TargetBloc, TargetState>(builder: (context, state) {
                if (state is TargetLoadedState) {
                  if (state.view != null && state.view!.isNotEmpty) {
                    return RefreshIndicator(
                      color: AppColors.darkGreenColor,
                      onRefresh: () {
                        context.read<TargetBloc>().add(TargetCheckEvent());
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 56.h + 20.h),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.view?.length,
                                itemBuilder: (context, index) {
                                  List<FlSpot> userSpots = getTable(state.view?[index]);
                                  return Container(
                                    width: double.infinity,
                                    color: Color(0xFFECFFF6),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 16.h),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                                            child: Text(
                                              'Цель №${index + 1}',
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.darkGreenColor,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 18.h),
                                        Container(
                                          width: double.infinity,
                                          height: 64.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.r),
                                            color: AppColors.basicwhiteColor,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 12.r,
                                                  backgroundColor: AppColors.darkGreenColor,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.check,
                                                      color: AppColors.basicwhiteColor,
                                                      size: 18.r,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 16.w),
                                                Text(
                                                  state.view?[index].target?.name ?? "",
                                                  style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.darkGreenColor,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  height: 36.h,
                                                  width: 102.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8.r),
                                                    color: AppColors.vivaMagentaColor,
                                                  ),
                                                  child: FormForButton(
                                                    borderRadius: BorderRadius.circular(8.r),
                                                    onPressed: () {
                                                      context.router.push(ClientSetTargetRoute());
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        'Изменить'.toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w700,
                                                          color: AppColors.basicwhiteColor,
                                                          fontFamily: 'Inter',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 32.h),
                                        if (state.view?[index].target?.name != "Удерживать вес")
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      state.view?[index].pointA.toString() ?? "",
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: AppColors.darkGreenColor,
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(width: 2.w),
                                                    Text(
                                                      state.view?[index].pointA != null ? 'кг' : "",
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: AppColors.darkGreenColor,
                                                        fontSize: 12.sp,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    PercentSecondBar(
                                                      percent: state.view?[index].lessPrc ?? 0,
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      state.view?[index].pointB.toString() ?? "",
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: AppColors.darkGreenColor,
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(width: 2.w),
                                                    Text(
                                                      state.view?[index].pointB != null ? 'кг' : "",
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: AppColors.darkGreenColor,
                                                        fontSize: 12.sp,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 9.h),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Осталось до цели:',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: AppColors.darkGreenColor,
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12.w),
                                                  Text(
                                                    getLostDays(state.view?[index].totalDays, state.view?[index].lessDays).toString() +
                                                        " дней",
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: AppColors.darkGreenColor,
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 33.h),
                                              Text(
                                                'Путь до цели',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: AppColors.darkGreenColor,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              TargetLineChart(
                                                dateStart: state.view?[index].dateA,
                                                dateEnd: state.view?[index].dateB,
                                                pointA: state.view?[index].pointA ?? 0,
                                                pointB: state.view?[index].pointB ?? 0,
                                                userSpots: userSpots,
                                              ),
                                              SizedBox(height: 8.h),
                                              if (state.view?[index].target?.name == "Сбросить вес" ||
                                                  state.view?[index].target?.name == "Набрать вес")
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            getText(state.view![index].target!.name!),
                                                            style: TextStyle(
                                                              fontFamily: 'Inter',
                                                              color: AppColors.darkGreenColor,
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 12.w),
                                                      Text(
                                                        '0.50 кг в неделю',
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: AppColors.darkGreenColor,
                                                          fontSize: 18.w,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              SizedBox(height: 16.h),
                                            ],
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                            SizedBox(height: 32.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: SizedBox(
                                height: 64.h,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: const WidgetStatePropertyAll(
                                      AppColors.darkGreenColor,
                                    ),
                                    shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.r)))),
                                  ),
                                  onPressed: () {
                                    context.router.push(ClientSetTargetRoute());
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: AppColors.basicwhiteColor,
                                        size: 24.r,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        'Добавить цель'.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: AppColors.basicwhiteColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 28.h),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 1.6,
                        child: Center(
                          child: Text(
                            "У вас нет текущих целей",
                            style: TextStyle(
                              color: AppColors.darkGreenColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 28.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: SizedBox(
                          height: 64.h,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll(
                                AppColors.darkGreenColor,
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                            onPressed: () {
                              context.router.push(ClientSetTargetRoute());
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: AppColors.basicwhiteColor,
                                  size: 24.r,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Добавить цель'.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.basicwhiteColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  );
                } else if (state is TargetErrorState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: ErrorWithReload(
                      callback: () {
                        context.read<TargetBloc>().add(TargetCheckEvent());
                      },
                    ),
                  );
                } else if (state is TargetLoadingState) {
                  return SizedBox(height: MediaQuery.of(context).size.height / 1.2, child: ProgressIndicatorWidget());
                }
                return Container();
              }),
              Container(
                height: 56.h,
                width: double.infinity,
                color: AppColors.basicwhiteColor,
                child: Container(
                  height: 56.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientTurquoiseReverse,
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
                        child: Center(
                          child: Text(
                            'Просмотр цели',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.sp,
                              height: 1,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGreenColor,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      )
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

  List<FlSpot> getTable(ClientTargetsView? view) {
    if (view != null && view.pointA != null && view.pointB != null && view.dateA != null && view.dateB != null) {
      if (view.pointA! < view.pointB!) {
        return [FlSpot(1, 3), FlSpot(2, 3), FlSpot(8, 7), FlSpot(9, 7)];
      } else {
        return [FlSpot(1, 7), FlSpot(2, 7), FlSpot(8, 3), FlSpot(9, 3)];
      }
    }
    return [];
  }

  int getLostDays(int? totalDays, int? lessDays) {
    if (totalDays != null && lessDays != null) {
      return totalDays - lessDays;
    } else if (totalDays != null) {
      return totalDays;
    }
    return 0;
  }

  String getText(String target) {
    if (target == "Сбросить вес") {
      return "Рекомендация по\nснижению веса:";
    } else {
      return "Рекомендация по\nнабору веса:";
    }
  }
}
