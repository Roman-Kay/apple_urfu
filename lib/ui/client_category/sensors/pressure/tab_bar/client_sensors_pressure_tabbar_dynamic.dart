import 'dart:collection';
import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/health/pressure/pressure_bloc.dart';
import 'package:garnetbook/bloc/client/health/pulse/pulse_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/ui/client_category/sensors/pressure/sheets/client_sensors_pressure_add_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/calendar/calendar_row.dart';
import 'package:garnetbook/widgets/error_handler/error_handler_sensors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:health/health.dart';

class PressureItemList {
  int diastolic;
  int systolic;
  int pulse;
  DateTime date;
  String? comment;
  String? health;

  PressureItemList({required this.diastolic, required this.systolic, required this.date, this.pulse = 0, this.comment, this.health});
}

class ClientSensorsPressureTabBarDynamic extends StatefulWidget {
  const ClientSensorsPressureTabBarDynamic({
    required this.selectedDate,
    required this.isRequested,
    required this.isInit,
    required this.isPulseInit,
    super.key
  });

  final SelectedDate selectedDate;
  final RequestedValue isRequested;
  final SelectedBool isInit;
  final SelectedBool2 isPulseInit;

  @override
  State<ClientSensorsPressureTabBarDynamic> createState() => _ClientTabBarSugarDynamicState();
}

class _ClientTabBarSugarDynamicState extends State<ClientSensorsPressureTabBarDynamic> with AutomaticKeepAliveClientMixin {
  List<int> ml = [50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160];
  List<int> pulsePoint = [30, 60, 90, 120, 150, 180];

  HealthServiceController healthController = HealthServiceController();
  Health health = Health();

  Map<DateTime, int> diastolicList = {};
  Map<DateTime, int> systolicList = {};
  Map<DateTime, int> pulseList = {};
  List<PressureItemList> list = [];

  Map<DateTime, int> initialDiastolicList = {};
  Map<DateTime, int> initialSystolicList = {};
  Map<DateTime, int> initialPulseList = {};
  List<PressureItemList> initialList = [];

  String chooseType = 'Все';
  final List<String> types = ['Все', 'Утро', 'День', 'Вечер', 'Ночь'];
  DateTime newDate = DateUtils.dateOnly(DateTime.now());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        BlocBuilder<PressureBloc, PressureState>(builder: (context, pressureState) {
          if (pressureState is PressureLoadedState) {
            getRequested();
            getList(pressureState.list);

            return BlocBuilder<PulseBloc, PulseState>(builder: (context, pulseState) {
              if (pulseState is PulseLoadedState) {
                getPulseList(pulseState.list);
              }

              return RefreshIndicator(
                color: AppColors.darkGreenColor,
                onRefresh: () {
                  setState(() {
                    chooseType = 'Все';
                  });

                  widget.isInit.select(false);
                  widget.isPulseInit.select(false);

                  context.read<PressureBloc>().add(PressureGetEvent(widget.selectedDate.date, widget.isRequested));
                  context.read<PulseBloc>().add(PulseGetEvent(widget.selectedDate.date));
                  return Future.delayed(const Duration(seconds: 1));
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  children: [
                    SizedBox(height: 20.h),
                    ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: AppColors.basicwhiteColor.withOpacity(0.5),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.r,
                                color: AppColors.basicblackColor.withOpacity(0.1),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Column(
                              children: [
                                SizedBox(height: 8.h),
                                CalendarRow(
                                  color: AppColors.basicwhiteColor,
                                  selectedDate: widget.selectedDate.date,
                                  onPressedDateCon: () {
                                    DatePickerBdaya.showDatePicker(
                                      context,
                                      showTitleActions: true,
                                      minTime: DateTime(DateTime.now().year - 1, 0, 0),
                                      maxTime: DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                      ),
                                      onConfirm: (newDate) {
                                        setState(() {
                                          chooseType = 'Все';
                                        });
                                        widget.isInit.select(false);
                                        widget.isPulseInit.select(false);

                                        widget.selectedDate.select(newDate);
                                        context.read<PressureBloc>().add(PressureGetEvent(newDate, widget.isRequested));
                                        context.read<PulseBloc>().add(PulseGetEvent(newDate));
                                      },
                                      currentTime: widget.selectedDate.date,
                                      locale: LocaleType.ru,
                                    );
                                  },
                                  onPressedLeft: () {
                                    setState((){
                                      chooseType = 'Все';
                                    });

                                    widget.isInit.select(false);
                                    widget.isPulseInit.select(false);
                                    widget.selectedDate.select(widget.selectedDate.date.subtract(Duration(days: 1)));
                                    context.read<PressureBloc>().add(PressureGetEvent(widget.selectedDate.date, widget.isRequested));
                                    context.read<PulseBloc>().add(PulseGetEvent(widget.selectedDate.date));
                                  },
                                  onPressedRight: () {
                                    if (widget.selectedDate.date.add(Duration(days: 1)).isAfter(DateTime.now())) {
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
                                    } else {
                                      setState((){
                                        chooseType = 'Все';
                                      });

                                      widget.isInit.select(false);
                                      widget.isPulseInit.select(false);
                                      widget.selectedDate.select(widget.selectedDate.date.add(Duration(days: 1)));
                                      context.read<PressureBloc>().add(PressureGetEvent(widget.selectedDate.date, widget.isRequested));
                                      context.read<PulseBloc>().add(PulseGetEvent(widget.selectedDate.date));
                                    }
                                  },
                                ),
                                SizedBox(height: 25.h),
                                ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      height: 37.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.basicwhiteColor.withOpacity(0.7),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                                        child: Stack(
                                          children: [
                                            AnimatedAlign(
                                              alignment: Alignment(
                                                types.indexOf(chooseType) == 0
                                                    ? -1
                                                    : types.indexOf(chooseType) == 1
                                                        ? -0.5
                                                        : types.indexOf(chooseType) == 2
                                                            ? 0
                                                            : types.indexOf(chooseType) == 3
                                                                ? 0.5
                                                                : 1,
                                                0,
                                              ),
                                              curve: Curves.easeInOutQuart,
                                              duration: Duration(milliseconds: 300),
                                              child: Container(
                                                width: 64.w,
                                                height: 28.h,
                                                decoration: BoxDecoration(
                                                  color: AppColors.vivaMagentaColor,
                                                  borderRadius: BorderRadius.circular(8.r),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                for (var text in types)
                                                  SizedBox(
                                                    width: 64.w,
                                                    child: FormForButton(
                                                      onPressed: () => changePressureType(text),
                                                      borderRadius: BorderRadius.circular(8.r),
                                                      child: Center(
                                                        child: Text(
                                                          text,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14.sp,
                                                            fontFamily: 'Inter',
                                                            color: chooseType == text ? AppColors.basicwhiteColor : AppColors.vivaMagentaColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 7.w,
                                        top: 18.h,
                                        right: 7.w,
                                        bottom: 12.h,
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.basicwhiteColor.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 150.h,
                                            width: double.infinity,
                                            child: LineChart(
                                              LineChartData(
                                                lineTouchData: LineTouchData(enabled: true),
                                                gridData: FlGridData(
                                                  drawHorizontalLine: true,
                                                  drawVerticalLine: false,
                                                  horizontalInterval: 1,
                                                  show: true,
                                                  checkToShowHorizontalLine: showAllGrids,
                                                  getDrawingHorizontalLine: (value) {
                                                    return value % 2 == 1
                                                        ? FlLine(
                                                            color: AppColors.seaColor,
                                                            strokeWidth: 0.1,
                                                          )
                                                        : FlLine(strokeWidth: 0);
                                                  },
                                                ),
                                                borderData: FlBorderData(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: AppColors.seaColor,
                                                      width: 0,
                                                    ),
                                                  ),
                                                ),
                                                titlesData: FlTitlesData(
                                                  bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                    interval: 1,
                                                    showTitles: true,
                                                    reservedSize: 30,
                                                    getTitlesWidget: (value, meta) {
                                                      String text = '';
                                                      switch (value.toInt()) {
                                                        case 0:
                                                          text = '0';
                                                          break;
                                                        case 2:
                                                          text = '2';
                                                          break;
                                                        case 4:
                                                          text = '4';
                                                          break;
                                                        case 6:
                                                          text = '6';
                                                          break;
                                                        case 8:
                                                          text = '8';
                                                          break;
                                                        case 10:
                                                          text = '10';
                                                          break;
                                                        case 12:
                                                          text = '12';
                                                          break;
                                                        case 14:
                                                          text = '14';
                                                          break;
                                                        case 16:
                                                          text = '16';
                                                          break;
                                                        case 18:
                                                          text = '18';
                                                          break;
                                                        case 20:
                                                          text = '20';
                                                          break;
                                                        case 22:
                                                          text = '22';
                                                          break;
                                                        case 24:
                                                          text = '24';
                                                          break;
                                                        default:
                                                          text = "";
                                                          break;
                                                      }
                                                      return Padding(
                                                        padding: const EdgeInsets.only(top: 12),
                                                        child: Text(
                                                          "  $text",
                                                          style: TextStyle(
                                                              color: AppColors.grey50Color,
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.w400,
                                                              fontFamily: 'Inter'),
                                                        ),
                                                      );
                                                    },
                                                  )),
                                                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                  rightTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                    reservedSize: 50,
                                                    interval: 1,
                                                    showTitles: true,
                                                    getTitlesWidget: (value, meta) {
                                                      String text = '';
                                                      switch (value.toInt()) {
                                                        case 1:
                                                          text = '60';
                                                          break;
                                                        case 3:
                                                          text = '80';
                                                          break;
                                                        case 5:
                                                          text = '100';
                                                          break;
                                                        case 7:
                                                          text = '120';
                                                          break;
                                                        case 9:
                                                          text = '140';
                                                          break;
                                                        case 11:
                                                          text = '160';
                                                          break;
                                                      }
                                                      return Padding(
                                                        padding: const EdgeInsets.only(left: 12.5),
                                                        child: Text(
                                                          text,
                                                          style: TextStyle(
                                                            color: AppColors.grey50Color,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w400,
                                                            fontFamily: 'Inter',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )),
                                                ),
                                                minX: 0,
                                                minY: 0,
                                                maxX: 24,
                                                maxY: 12,
                                                lineBarsData: [
                                                  LineChartBarData(
                                                    color: AppColors.vivaMagentaColor,
                                                    spots: getSystolicTable(),
                                                  ),
                                                  LineChartBarData(
                                                    color: AppColors.blueColor,
                                                    spots: getDiastolicTable(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 18.h),
                                          Row(
                                            children: [
                                              SizedBox(width: 10.w),
                                              CircleAvatar(
                                                radius: 5.r,
                                                backgroundColor: AppColors.vivaMagentaColor,
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                'Систолическое',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp,
                                                  fontFamily: 'Inter',
                                                  color: AppColors.darkGreenColor,
                                                ),
                                              ),
                                              SizedBox(width: 28.w),
                                              CircleAvatar(
                                                radius: 5.r,
                                                backgroundColor: AppColors.blueColor,
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                'Диастолическое',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp,
                                                  fontFamily: 'Inter',
                                                  color: AppColors.darkGreenColor,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 7.w,
                                        top: 18.h,
                                        right: 7.w,
                                        bottom: 12.h,
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.basicwhiteColor.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 150.h,
                                            width: double.infinity,
                                            child: LineChart(
                                              LineChartData(
                                                lineTouchData: LineTouchData(enabled: true),
                                                gridData: FlGridData(
                                                  drawHorizontalLine: true,
                                                  drawVerticalLine: false,
                                                  horizontalInterval: 1,
                                                  show: true,
                                                  checkToShowHorizontalLine: showAllGrids,
                                                  getDrawingHorizontalLine: (value) {
                                                    return value % 2 == 1
                                                        ? FlLine(
                                                            color: AppColors.seaColor,
                                                            strokeWidth: 0.1,
                                                          )
                                                        : FlLine(strokeWidth: 0);
                                                  },
                                                ),
                                                borderData: FlBorderData(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: AppColors.seaColor,
                                                      width: 0,
                                                    ),
                                                  ),
                                                ),
                                                titlesData: FlTitlesData(
                                                  bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                    interval: 1,
                                                    showTitles: true,
                                                    reservedSize: 30,
                                                    getTitlesWidget: (value, meta) {
                                                      String text = '';
                                                      switch (value.toInt()) {
                                                        case 0:
                                                          text = '0';
                                                          break;
                                                        case 2:
                                                          text = '2';
                                                          break;
                                                        case 4:
                                                          text = '4';
                                                          break;
                                                        case 6:
                                                          text = '6';
                                                          break;
                                                        case 8:
                                                          text = '8';
                                                          break;
                                                        case 10:
                                                          text = '10';
                                                          break;
                                                        case 12:
                                                          text = '12';
                                                          break;
                                                        case 14:
                                                          text = '14';
                                                          break;
                                                        case 16:
                                                          text = '16';
                                                          break;
                                                        case 18:
                                                          text = '18';
                                                          break;
                                                        case 20:
                                                          text = '20';
                                                          break;
                                                        case 22:
                                                          text = '22';
                                                          break;
                                                        case 24:
                                                          text = '24';
                                                          break;
                                                        default:
                                                          text = "";
                                                          break;
                                                      }
                                                      return Padding(
                                                        padding: const EdgeInsets.only(top: 12),
                                                        child: Text(
                                                          "  $text",
                                                          style: TextStyle(
                                                              color: AppColors.grey50Color,
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.w400,
                                                              fontFamily: 'Inter'),
                                                        ),
                                                      );
                                                    },
                                                  )),
                                                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                  rightTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                    reservedSize: 50,
                                                    interval: 1,
                                                    showTitles: true,
                                                    getTitlesWidget: (value, meta) {
                                                      String text = '';
                                                      switch (value.toInt()) {
                                                        case 1:
                                                          text = '  30';
                                                          break;
                                                        case 2:
                                                          text = '  60';
                                                          break;
                                                        case 3:
                                                          text = '  90';
                                                          break;
                                                        case 4:
                                                          text = '  120';
                                                          break;
                                                        case 5:
                                                          text = '  150';
                                                          break;
                                                        case 6:
                                                          text = '  180';
                                                          break;
                                                      }
                                                      return Padding(
                                                        padding: const EdgeInsets.only(left: 12.5),
                                                        child: Text(
                                                          text,
                                                          style: TextStyle(
                                                            color: AppColors.grey50Color,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w400,
                                                            fontFamily: 'Inter',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )),
                                                ),
                                                minX: 0,
                                                minY: 0,
                                                maxX: 24,
                                                maxY: 6,
                                                lineBarsData: [
                                                  LineChartBarData(
                                                    color: AppColors.vivaMagentaColor,
                                                    spots: getPulseTable(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 18.h),
                                          Row(
                                            children: [
                                              SizedBox(width: 10.w),
                                              CircleAvatar(
                                                radius: 5.r,
                                                backgroundColor: AppColors.vivaMagentaColor,
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                'Пульс',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.sp,
                                                  fontFamily: 'Inter',
                                                  color: AppColors.darkGreenColor,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: list.length,
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    final item = list[index];
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 41.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 60.w,
                                                height: 25.h,
                                                decoration: BoxDecoration(
                                                  gradient: AppColors.multigradientColor,
                                                  borderRadius: BorderRadius.circular(4.r),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    DateFormatting().formatTime(item.date),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 14.sp,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.darkGreenColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "${item.systolic}/${item.diastolic}",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18.sp,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.basicwhiteColor,
                                                    ),
                                                  ),
                                                  if (item.pulse != 0)
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 20.w),
                                                        SvgPicture.asset(
                                                          'assets/images/pulse.svg',
                                                          height: 16.h,
                                                          color: getColor(item),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            item.pulse.toString(),
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 18.sp,
                                                              fontFamily: 'Inter',
                                                              color: AppColors.basicwhiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8.w),
                                                      ],
                                                    ),
                                                  if (item.health != null)
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 8.w),
                                                        Text(
                                                          item.health ?? 'Нормальное',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12.sp,
                                                            fontFamily: 'Inter',
                                                            color: AppColors.basicwhiteColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        if(item.comment != null)
                                          ClipRRect(
                                            clipBehavior: Clip.hardEdge,
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.r),
                                                  color: AppColors.basicwhiteColor.withOpacity(0.7),
                                                  border: Border.all(width: 1, color: AppColors.limeColor),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
                                                  child: Text(
                                                    item.comment ?? "",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12.sp,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.vivaMagentaColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 24.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              );
            });
          }
          else if (pressureState is PressureNotConnectedState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              child: ErrorHandler(
                addValueFunction: (){
                  addNewValue();
                },
              ),
            );
          }
          else if (pressureState is PressureErrorState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.6,
              child: Center(
                  child: ErrorWithReload(
                      isWhite: true,
                      callback: () {
                        setState((){
                          chooseType = 'Все';
                        });

                        widget.isInit.select(false);
                        widget.isPulseInit.select(false);
                        context.read<PressureBloc>().add(PressureGetEvent(widget.selectedDate.date, widget.isRequested));
                        context.read<PulseBloc>().add(PulseGetEvent(widget.selectedDate.date));
                      },
                  )),
            );
          }
          else if (pressureState is PressureLoadingState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.6,
              child: Center(
                child: ProgressIndicatorWidget(isWhite: true,),
              ),
            );
          }
          return Container();
        }),
        BlocBuilder<PressureBloc, PressureState>(builder: (context, pressureState) {
          if (pressureState is PressureNotConnectedState) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: WidgetButton(
                        onTap: (){
                          setState((){
                            chooseType = 'Все';
                          });
                          widget.isInit.select(false);
                          widget.isPulseInit.select(false);
                          context.read<PressureBloc>().add(PressuredConnectedEvent(widget.selectedDate.date, widget.isRequested));
                          context.read<PulseBloc>().add(PulseGetEvent(widget.selectedDate.date));
                        },
                        color: AppColors.darkGreenColor,
                        text: 'повторить'.toUpperCase(),
                      ),
                    ),
                    SizedBox(width: 30.h),
                    Expanded(
                      child: WidgetButton(
                        onTap: () => context.router.maybePop(),
                        color: AppColors.seaColor,
                        textColor: AppColors.darkGreenColor,
                        text: 'на главную'.toUpperCase(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        }),
      ],
    );
  }

  addNewValue(){
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
        color: AppColors.darkGreenColor,
        title: 'Добавить измерение',
        content: ClientSensorsPressureAddSheet(
          date: widget.selectedDate.date,
        ),
      ),
    ).then((val) {
      if (val == true) {
        setState((){
          chooseType = 'Все';
        });

        widget.isInit.select(false);
        widget.isPulseInit.select(false);
        context.read<PressureBloc>().add(PressureUpdateEvent(widget.selectedDate.date, widget.isRequested));
        context.read<PulseBloc>().add(PulseGetEvent(widget.selectedDate.date));
      }
    });
  }

  changePressureType(String text){
    chooseType = text;

    if(text == 'Все'){
      systolicList = initialSystolicList;
      diastolicList = initialDiastolicList;
      pulseList = initialPulseList;
      list = initialList;
    }

    else if(text == 'Утро'){
      systolicList = {};
      diastolicList = {};
      pulseList = {};
      list = [];

      initialSystolicList.forEach((key, val){
        if(key.hour >= 6 && key.hour < 10){ // 6:00 - 10:00
          systolicList.putIfAbsent(key, ()=> val);
        }
      });

      initialDiastolicList.forEach((key, val){
        if(key.hour >= 6 && key.hour < 10){ // 6:00 - 10:00
          diastolicList.putIfAbsent(key, ()=> val);
        }
      });

      initialPulseList.forEach((key, val){
        if(key.hour >= 6 && key.hour < 10){ // 6:00 - 10:00
          pulseList.putIfAbsent(key, ()=> val);
        }
      });

      initialList.forEach((element){
        if(element.date.hour >= 6 && element.date.hour < 10){
          list.add(element);
        }
      });
    }

    else if(text == 'День'){
      systolicList = {};
      diastolicList = {};
      pulseList = {};
      list = [];

      initialSystolicList.forEach((key, val){
        if(key.hour >= 10 && key.hour < 18){ // 10:00 - 18:00
          systolicList.putIfAbsent(key, ()=> val);
        }
      });

      initialDiastolicList.forEach((key, val){
        if(key.hour >= 10 && key.hour < 18){ // 10:00 - 18:00
          diastolicList.putIfAbsent(key, ()=> val);
        }
      });

      initialPulseList.forEach((key, val){
        if(key.hour >= 10 && key.hour < 18){ // 10:00 - 18:00
          pulseList.putIfAbsent(key, ()=> val);
        }
      });

      initialList.forEach((element){
        if(element.date.hour >= 10 && element.date.hour < 18){ // 10:00 - 18:00
          list.add(element);
        }
      });
    }

    else if(text == 'Вечер'){
      systolicList = {};
      diastolicList = {};
      pulseList = {};
      list = [];

      initialSystolicList.forEach((key, val){
        if(key.hour >= 18 && key.hour < 22){ // 18:00 - 22:00
          systolicList.putIfAbsent(key, ()=> val);
        }
      });

      initialDiastolicList.forEach((key, val){
        if(key.hour >= 18 && key.hour < 22){ // 18:00 - 22:00
          diastolicList.putIfAbsent(key, ()=> val);
        }
      });

      initialPulseList.forEach((key, val){
        if(key.hour >= 18 && key.hour < 22){ // 18:00 - 22:00
          pulseList.putIfAbsent(key, ()=> val);
        }
      });

      initialList.forEach((element){
        if(element.date.hour >= 18 && element.date.hour < 22){ // 18:00 - 22:00
          list.add(element);
        }
      });
    }

    else if(text == 'Ночь'){
      systolicList = {};
      diastolicList = {};
      pulseList = {};
      list = [];

      initialSystolicList.forEach((key, val){
        if(key.hour >= 22 && key.hour < 6){ // 22:00 - 6:00
          systolicList.putIfAbsent(key, ()=> val);
        }
      });

      initialDiastolicList.forEach((key, val){
        if(key.hour >= 22 && key.hour < 6){ // 22:00 - 6:00
          diastolicList.putIfAbsent(key, ()=> val);
        }
      });

      initialPulseList.forEach((key, val){
        if(key.hour >= 22 && key.hour < 6){ // 22:00 - 6:00
          pulseList.putIfAbsent(key, ()=> val);
        }
      });

      initialList.forEach((element){
        if(element.date.hour >= 22 && element.date.hour < 6){ // 22:00 - 6:00
          list.add(element);
        }
      });
    }

    setState(() {});
  }

  getRequested() async {
    List<HealthDataType> healthDataType = [HealthDataType.BLOOD_PRESSURE_DIASTOLIC, HealthDataType.BLOOD_PRESSURE_SYSTOLIC];

    List<HealthDataAccess> permissions = [HealthDataAccess.READ_WRITE, HealthDataAccess.READ_WRITE];

    final requested = Platform.isAndroid
        ? await health.hasPermissions(healthDataType, permissions: permissions)
        : await health.requestAuthorization(healthDataType, permissions: permissions);

    if (Platform.isAndroid) {
      if (requested == true) {
        widget.isRequested.select(true);
      } else {
        widget.isRequested.select(false);
      }
    }
  }

  Color getColor(PressureItemList item) {
    if (
        // item.diastolic < 60 ||
        item.systolic < 120) {
      return AppColors.blueSecondaryColor;
    } else if (
        // (item.diastolic >= 60 && item.diastolic <= 79) &&
        (item.systolic >= 120 && item.systolic <= 130)) {
      return AppColors.greenLightColor;
    } else if (
        // (item.diastolic >= 60 && item.diastolic <= 79) &&
        (item.systolic >= 130 && item.systolic <= 140)) {
      return AppColors.orangeColor;
    } else if (
        // (item.diastolic >= 80 && item.diastolic <= 89) ||
        (item.systolic >= 140 && item.systolic <= 160)) {
      return AppColors.tints3Color;
    } else if (
        // (item.diastolic >= 90 && item.diastolic <= 120)||
        (item.systolic >= 160 && item.systolic <= 180)) {
      return Color(0xFFCD5B6F);
    } else {
      return AppColors.redColor;
    }
  }

  pulseReconnected() async {
    List<HealthDataType> healthDataType = [HealthDataType.HEART_RATE];

    List<HealthDataAccess> permissions = [HealthDataAccess.READ_WRITE];
    bool requested = await health.requestAuthorization(healthDataType, permissions: permissions);
    if (requested) {
      context.read<PressureBloc>().add(PressureGetEvent(widget.selectedDate.date, widget.isRequested));
      context.read<PulseBloc>().add(PulseGetEvent(widget.selectedDate.date));
    }
  }

  getList(List<ClientSensorsView>? view) {
    if(!widget.isInit.isInit){
      diastolicList.clear();
      systolicList.clear();
      list.clear();

      if (view != null && view.isNotEmpty) {
        view.forEach((element) {
          if (element.healthSensorVal != null && element.dateSensor != null) {
            DateTime tempDate = DateTime.parse(element.dateSensor!);

            String newTest = element.healthSensorVal.toString();
            List values = newTest.split(".");

            int diastolic = int.parse(values.first);
            int systolic = int.parse(setDecimalDigits(values.last));

            systolicList.putIfAbsent(tempDate, () => systolic);
            diastolicList.putIfAbsent(tempDate, () => diastolic);

            bool isExist = list.any((item) => item.date == tempDate);

            if (!isExist) {
              list.add(PressureItemList(
                  diastolic: diastolic,
                  systolic: systolic,
                  date: tempDate,
                  comment: element.comment,
                  health: element.health)
              );
            }
          }
        });
      }

      if (list.isNotEmpty) {
        list.sort((a, b) => a.date.compareTo(b.date));
      }

      if (systolicList.isNotEmpty) {
        systolicList = SplayTreeMap<DateTime, int>.from(systolicList, (a, b) => a.compareTo(b));

        List<DateTime> tempList = systolicList.keys.toList();
        List<DateTime> deletedDays = [];

        for (int index = 0; index < tempList.length; index++) {
          if (index + 1 < tempList.length) {
            Duration difference = tempList[index + 1].difference(tempList[index]);

            if (difference.inMinutes < 20) {
              deletedDays.add(tempList[index + 1]);
            }
          }
        }

        if (deletedDays.isNotEmpty) {
          deletedDays.forEach((element) {
            if (systolicList.containsKey(element)) {
              systolicList.remove(element);
            }
          });
        }
      }

      if (diastolicList.isNotEmpty) {
        diastolicList = SplayTreeMap<DateTime, int>.from(diastolicList, (a, b) => a.compareTo(b));

        List<DateTime> tempList = diastolicList.keys.toList();
        List<DateTime> deletedDays = [];

        for (int index = 0; index < tempList.length; index++) {
          if (index + 1 < tempList.length) {
            Duration difference = tempList[index + 1].difference(tempList[index]);

            if (difference.inMinutes < 20) {
              deletedDays.add(tempList[index + 1]);
            }
          }
        }

        if (deletedDays.isNotEmpty) {
          deletedDays.forEach((element) {
            if (diastolicList.containsKey(element)) {
              diastolicList.remove(element);
            }
          });
        }
      }

      initialSystolicList = systolicList;
      initialDiastolicList = diastolicList;
      initialList = list;
      widget.isInit.select(true);
    }
  }

  getPulseList(List<ClientSensorsView>? view) {
    if(!widget.isPulseInit.isInit){
      pulseList.clear();

      if (view != null && view.isNotEmpty) {
        view.forEach((element) {
          if (element.healthSensorVal != null && element.dateSensor != null) {
            DateTime tempDate = DateTime.parse(element.dateSensor!);

            pulseList.putIfAbsent(tempDate, () => element.healthSensorVal!.toInt());

            bool isExist = list.any((item) => item.date == tempDate);

            if (isExist) {
              for (var item in list) {
                if (item.date == tempDate) {
                  item.pulse = element.healthSensorVal!.toInt();
                  break;
                }
              }
            }
          }
        });
      }

      if (list.isNotEmpty) {
        list.sort((a, b) => a.date.compareTo(b.date));
      }

      if (pulseList.isNotEmpty) {
        pulseList = SplayTreeMap<DateTime, int>.from(pulseList, (a, b) => a.compareTo(b));

        List<DateTime> tempList = pulseList.keys.toList();
        List<DateTime> deletedDays = [];

        for (int index = 0; index < tempList.length; index++) {
          if (index + 1 < tempList.length) {
            Duration difference = tempList[index + 1].difference(tempList[index]);

            if (difference.inMinutes < 20) {
              deletedDays.add(tempList[index + 1]);
            }
          }
        }

        if (deletedDays.isNotEmpty) {
          deletedDays.forEach((element) {
            if (pulseList.containsKey(element)) {
              pulseList.remove(element);
            }
          });
        }
      }

      initialPulseList = pulseList;
      widget.isPulseInit.select(true);
    }

  }

  List<FlSpot> getDiastolicTable() {
    List<FlSpot> userSpots = [];

    if (diastolicList.isNotEmpty) {
      diastolicList.forEach((date, value) {
        double userMl = 0;
        String time = DateFormatting().formatTime(date);
        String newTime = time.substring(0, 2);

        for (var element in ml) {
          int index = ml.indexOf(element);
          if (value == element) {
            userMl = index.toDouble();
            break;
          } else if (value <= 60) {
            userMl = 1;
            break;
          } else if (value >= 160) {
            userMl = 12;
            break;
          } else if (value < element) {
            double result = (value / element) * (index);
            if (result < 0) {
              userMl = 1;
            } else {
              userMl = result;
            }
            break;
          }
        }
        userSpots.add(FlSpot(double.parse(newTime), userMl));
      });
    }

    return userSpots;
  }

  List<FlSpot> getSystolicTable() {
    List<FlSpot> userSpots = [];

    if (systolicList.isNotEmpty) {
      systolicList.forEach((date, value) {
        double userMl = 0;
        String time = DateFormatting().formatTime(date);
        String newTime = time.substring(0, 2);

        for (var element in ml) {
          int index = ml.indexOf(element);
          if (value == element) {
            userMl = index.toDouble();
            break;
          } else if (value <= 60) {
            userMl = 1;
            break;
          } else if (value >= 160) {
            userMl = 12;
            break;
          } else if (value < element) {
            double result = (value / element) * (index);
            if (result < 0) {
              userMl = 1;
            } else {
              userMl = result;
            }
            break;
          }
        }
        userSpots.add(FlSpot(double.parse(newTime), userMl));
      });
    }

    return userSpots;
  }

  List<FlSpot> getPulseTable() {
    List<FlSpot> userSpots = [];

    if (pulseList.isNotEmpty) {
      pulseList.forEach((date, value) {
        double userMl = 0;
        String time = DateFormatting().formatTime(date);
        String newTime = time.substring(0, 2);

        for (var element in pulsePoint) {
          int index = pulsePoint.indexOf(element);

          if (value == element) {
            userMl = index.toDouble() + 1;
            break;
          } else if (value == 0) {
            userMl = 1;
            break;
          } else if (value >= 180) {
            userMl = 6;
            break;
          } else if (value < element) {
            double result = (value / element) * (index + 1);
            if (result < 0) {
              userMl = 1;
            } else {
              userMl = result;
            }
            break;
          }
        }
        userSpots.add(FlSpot(double.parse(newTime), userMl));
      });
    }
    return userSpots;
  }

  String setDecimalDigits(String number) {
    String firstChar = number[0];

    if (number.length == 1) {
      if (firstChar == "1" || firstChar == "2") {
        return number + "00";
      }
      return number + "0";
    }

    if ((firstChar == "1" || firstChar == "2") && number.length == 2) {
      return number + "0";
    }
    return number;
  }

  Widget row({
    required String name,
    required String min,
    required String max,
    required String medium,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 65.w,
          child: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
              fontFamily: 'Inter',
              color: AppColors.grey50Color,
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 80.w,
          child: Center(
            child: Text(
              min,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                fontFamily: 'Inter',
                color: AppColors.darkGreenColor,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 80.w,
          child: Center(
            child: Text(
              medium,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                fontFamily: 'Inter',
                color: AppColors.darkGreenColor,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 80.w,
          child: Center(
            child: Text(
              max,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                fontFamily: 'Inter',
                color: AppColors.darkGreenColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
