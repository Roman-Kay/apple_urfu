// ignore_for_file: must_be_immutable

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/widgets/graphics/point_chart.dart';

class TargetLineChart extends StatelessWidget {
  TargetLineChart(
      {Key? key,
      this.dateStart,
      this.dateEnd,
      required this.pointA,
      required this.pointB,
      this.isOpacity = false,
      required this.userSpots})
      : super(key: key);

  int pointA;
  int pointB;
  String? dateStart;
  String? dateEnd;
  List<FlSpot> userSpots;
  bool isOpacity;

  String getDate(String? date) {
    if (date != null && date != "") {
      DateTime newDate = DateTime.parse(date);
      if (newDate.difference(DateTime.now()).inDays == 0) {
        return "Сегодня";
      } else {
        return DateFormatting().formatDateRUWithYear(date);
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      height: MediaQuery.of(context).size.height * 0.32,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isOpacity ? AppColors.basicwhiteColor.withOpacity(0.2) : AppColors.basicwhiteColor,
        boxShadow: isOpacity ? null : [
           BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Align(
            alignment: Alignment.topCenter,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              final double widthChart = constraints.maxWidth;
              final double heightChart = constraints.maxHeight;
              return Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.24,
                    width: MediaQuery.of(context).size.width - 20 * 2,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          drawHorizontalLine: false,
                          drawVerticalLine: true,
                          show: true,
                          checkToShowHorizontalLine: (value) {
                            return value.toInt() == 0;
                          },
                          checkToShowVerticalLine: showAllGrids,
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              strokeWidth: 1,
                              color: AppColors.grey10Color,
                            );
                          },
                        ),
                        borderData: FlBorderData(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: AppColors.grey10Color,
                            ),
                            left: BorderSide(
                              width: 1,
                              color: AppColors.grey10Color,
                            ),
                            right: BorderSide(
                              width: 1,
                              color: AppColors.grey10Color,
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
                              if (value == 2) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 9),
                                  child: Text(
                                    getDate(dateStart),
                                    style: TextStyle(
                                      color: AppColors.vivaMagentaColor,
                                      fontSize: 12.sp,
                                      height: 1,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                );
                              } else if (value == 8) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 9),
                                  child: Text(
                                    getDate(dateEnd),
                                    style: TextStyle(
                                      color: AppColors.darkGreenColor,
                                      fontSize: 12.sp,
                                      height: 1,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                );
                              } else {
                                return Text("");
                              }
                            },
                          )),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        minX: 1,
                        minY: 1,
                        maxX: 9,
                        maxY: 9,
                        lineTouchData: LineTouchData(enabled: false),
                        lineBarsData: [
                          LineChartBarData(
                            preventCurveOverShooting: true,
                            preventCurveOvershootingThreshold: 0,
                            isStrokeJoinRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              spotsLine: BarAreaSpotsLine(
                                show: true,
                                flLineStyle: FlLine(
                                  strokeWidth: 1,
                                  color: AppColors.grey30Color,
                                ),
                                // нам не нужно показать линии у первой и последней точки для этого тут проверка
                                checkToShowSpotLine: (spot) => spot ==
                                            userSpots[0] ||
                                        spot == userSpots[userSpots.length - 1]
                                    ? false
                                    : true,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.greenColor.withOpacity(0.3),
                                  AppColors.greenColor.withOpacity(0),
                                ],
                              ),
                            ),
                            color: AppColors.greenColor,
                            barWidth: 1,
                            isCurved: true,
                            dotData: FlDotData(
                              getDotPainter: (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                color: AppColors.greenColor,
                                // нам не нужно показать 1 и последнию точку
                                radius:
                                    index == 0 || index == userSpots.length - 1
                                        ? 0
                                        : 6.r,
                              ),
                            ),
                            spots: userSpots,
                          ),
                        ],
                      ),
                    ),
                  ),
                  PointChart(
                    heightChart: heightChart - 30,
                    // 30 это reservedSize для titlesData
                    widthChart: widthChart,
                    text: pointA.toString(),
                    flSpot: userSpots[1],
                    xMax: 9,
                    yMax: 9,
                  ),
                  PointChart(
                    heightChart: heightChart - 30,
                    // 30 это reservedSize для titlesData
                    widthChart: widthChart,
                    text: pointB.toString(),
                    flSpot: userSpots[userSpots.length - 2],
                    xMax: 9,
                    yMax: 9,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
