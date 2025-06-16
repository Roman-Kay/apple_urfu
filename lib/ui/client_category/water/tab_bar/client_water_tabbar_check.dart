import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/water_diary/water_diary_bloc.dart';
import 'package:garnetbook/bloc/client/water_diary/water_diary_chart/water_diary_chart_bloc.dart';
import 'package:garnetbook/ui/client_category/water/bottom_sheets/client_water_add_sheet.dart';
import 'package:garnetbook/ui/client_category/water/bottom_sheets/client_watter_change_target_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/bottom_align.dart/bottom_align.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/calendar/calendar_row.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/graphics/custom_radial_persent_widget.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';

class ClientWaterTabBarWatterCheck extends StatefulWidget {
  const ClientWaterTabBarWatterCheck({super.key, this.isFromFoodDiary});
  final String? isFromFoodDiary;

  @override
  State<ClientWaterTabBarWatterCheck> createState() => _ClientWaterTabBarWatterCheckState();
}

class _ClientWaterTabBarWatterCheckState extends State<ClientWaterTabBarWatterCheck> with AutomaticKeepAliveClientMixin {
  DateTime selectedDate = DateUtils.dateOnly(DateTime.now());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final double maxHeight = constraints.maxHeight;
      return Stack(
        children: [
          BlocBuilder<WaterDiaryBloc, WaterDiaryState>(builder: (context, state) {
            if (state is WaterDiaryGetState) {
              return RefreshIndicator(
                color: AppColors.darkGreenColor,
                onRefresh: () {
                  context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(selectedDate));
                  context.read<WaterDiaryChartBloc>().add(WaterDiaryChartGetEvent(DateTime.now().month, DateTime.now().year));
                  return Future.delayed(const Duration(seconds: 1));
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [

                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.circular(8.r),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: AppColors.basicwhiteColor.withValues(alpha: 0.8),
                              child: Column(
                                children: [
                                  SizedBox(height: 16.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    child: CalendarRow(
                                      selectedDate: selectedDate,
                                      onPressedDateCon: () {
                                        DatePickerBdaya.showDatePicker(
                                          context,
                                          showTitleActions: true,
                                          minTime: DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
                                          maxTime: DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day,
                                          ),
                                          onConfirm: (newDate) {
                                            setState(() {
                                              selectedDate = newDate;
                                            });
                                            context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(selectedDate));
                                          },
                                          currentTime: selectedDate,
                                          locale: LocaleType.ru,
                                        );

                                      },
                                      onPressedLeft: () {
                                        setState(() {
                                          selectedDate = selectedDate.subtract(Duration(days: 1));
                                        });
                                        context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(selectedDate));
                                      },
                                      onPressedRight: () {
                                        if (selectedDate.add(Duration(days: 1)).isAfter(DateTime.now())) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              duration: Duration(seconds: 3),
                                              content: Text(
                                                'Невозможно узнать будущие показатели',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.sp,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        else {
                                          setState(() {
                                            selectedDate = selectedDate.add(Duration(days: 1));
                                          });
                                          context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(selectedDate));
                                        }

                                      },
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Container(
                                    height: 1,
                                    color: AppColors.basicwhiteColor,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Вы выпили воды',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.sp,
                                            color: AppColors.darkGreenColor,
                                            fontFamily: "Inter"
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            width: 300.w,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 10.w),
                                                  Text(
                                                    "${state.today == null ? '0' : state.today?.dayVal ?? "0"}",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 62.sp,
                                                        color: AppColors.blueSecondaryColor,
                                                        fontFamily: "Inter"
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Text(
                                                    'мл',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 14.sp,
                                                      fontFamily: "Inter",
                                                      color: AppColors.blueSecondaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          useSafeArea: true,
                          backgroundColor: AppColors.basicwhiteColor,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          context: context,
                          builder: (context) => ModalSheet(
                            title: 'Изменить цель дня',
                            content: ClientWatterChangeTargetSheet(
                              dayTarget: state.today?.dayNorm,
                            ),
                          ),
                        ).then((value) {
                          if (value == true) {
                            context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(selectedDate));
                          }
                        }),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(320.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  height: 310.h,
                                  width: 310.w,
                                  color: AppColors.basicwhiteColor.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                            RadialPercentWidget(
                              percent: state.today == null ? 0 : calculatePercent(state.today?.dayVal, state.dayTarget),
                              lineColor: AppColors.basicwhiteColor.withOpacity(0.1), //
                              boxShadowColor: AppColors.basicwhiteColor.withOpacity(0.1), //
                              freePaintColor: AppColors.basicwhiteColor.withOpacity(0.6), //
                              linePercentColor: AppColors.blueSecondaryColor, //
                              backGroundColor: AppColors.basicwhiteColor.withOpacity(0.6),
                              end2LineColor: AppColors.basicwhiteColor.withOpacity(0.1),
                              endLineColor: AppColors.basicwhiteColor.withOpacity(0.1),
                              child: SizedBox(
                                height: 130.h,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/water_drop.svg',
                                          color: AppColors.blueSecondaryColor,
                                        ),
                                        Text(
                                          'Цель дня:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.sp,
                                            height: 1,
                                            fontFamily: 'Inter',
                                            color: AppColors.blueSecondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const Spacer(),
                                    const Spacer(),
                                    Text(
                                      getTarget(state.dayTarget),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 48.sp,
                                        fontFamily: 'Inter',
                                        height: 1,
                                        color: AppColors.blueSecondaryColor,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'литра',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp,
                                        fontFamily: 'Inter',
                                        height: 1,
                                        color: AppColors.blueSecondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: SizedBox(
                          height: 49.h,
                          child: Stack(
                            children: [
                              ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: BorderRadius.circular(8.r),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    height: 49.h,
                                    color: AppColors.basicwhiteColor.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Text(
                                    'Отлично! Пейте воду в течении дня',
                                    style: TextStyle(
                                      color: AppColors.darkGreenColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 200.h),
                    ],
                  ),
                ),
              );
            }
            else if (state is WaterDiaryErrorState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.6,
                child: ErrorWithReload(
                  isWhite: true,
                  callback: () {
                    context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(selectedDate));
                  },
                ),
              );
            }
            else if (state is WaterDiaryLoadingState) {
              return SizedBox(height: MediaQuery.of(context).size.height / 1.6, child: ProgressIndicatorWidget(isWhite: true));
            }
            return Container();
          }),
          BlocBuilder<WaterDiaryBloc, WaterDiaryState>(builder: (context, state) {
            if (state is WaterDiaryGetState) {
              return BottomAlign(
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                    child: WidgetButton(
                      onTap: () {
                        showModalBottomSheet(
                          useSafeArea: true,
                          backgroundColor: AppColors.basicwhiteColor,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          context: context,
                          builder: (context) => ModalSheet(
                            title: 'Размер порции',
                            content: ClientWaterAddSheet(
                              target: state.dayTarget,
                              isFromFoodDiary: false,
                            ),
                          ),
                        ).then((value) {
                          if (value == true) {
                            context.read<WaterDiaryBloc>().add(WaterDiaryCheckEvent(selectedDate));
                            context.read<WaterDiaryChartBloc>().add(WaterDiaryChartGetEvent(DateTime.now().month, DateTime.now().year));
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/watter_glass.svg',
                            color: AppColors.basicwhiteColor,
                            height: 24.h,
                          ),
                          SizedBox(
                            width: 18.8.h,
                          ),
                          Text(
                            'Добавить воды'.toUpperCase(),
                            style: TextStyle(
                              color: AppColors.basicwhiteColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                ),
                heightOfChild: 96.h,
                heightSafeArea: maxHeight,
              );
            }
            return Container();

            }
          ),
        ],
      );
    });
  }

  double calculatePercent(int? dayVal, int? dayTarget) {
    if (dayVal != null) {
      if (dayTarget != null && dayTarget != 0) {
        return dayVal / dayTarget;
      } else {
        return (dayVal / 2000);
      }
    } else {
      return 0.0;
    }
  }

  String getTarget(int? dayTarget) {
    if (dayTarget != null) {
      if (dayTarget == 0) {
        return "2";
      } else {
        double target = dayTarget / 1000;
        return target.toStringAsFixed(1);
      }
    }
    return "2";
  }
}
