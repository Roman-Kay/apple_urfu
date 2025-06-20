import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/survey/balance_wheel/balance_wheel_bloc.dart';
import 'package:garnetbook/data/models/survey/balance_wheel/balance_wheel.dart';
import 'package:garnetbook/data/repository/balance_wheel.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/survey/balance_wheel/bottom_sheet/client_survey_balance_wheel_list_sheet.dart';
import 'package:garnetbook/ui/client_category/survey/balance_wheel/bottom_sheet/client_survey_balance_wheel_single_type_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';


class ClientSurveyBalanceWheelCheckTabBar extends StatefulWidget {
  const ClientSurveyBalanceWheelCheckTabBar({super.key, required this.isInit, required this.selectedDate});

  final SelectedDate selectedDate;
  final SelectedBool isInit;

  @override
  State<ClientSurveyBalanceWheelCheckTabBar> createState() => _ClientSurveyBalanceWheelCheckTabBarState();
}

class _ClientSurveyBalanceWheelCheckTabBarState extends State<ClientSurveyBalanceWheelCheckTabBar> with AutomaticKeepAliveClientMixin{
  BalanceWheelClass balanceWheel = BalanceWheelClass();
  Map<String, int> list = {};
  bool isInit = false;

  Map<int, String> pieList = {
    0 : "карьера",
    1 : "здоровье",
    2 : "друзья",
    3 : "семья",
    4 : "отдых",
    5 : "саморазвитие",
    6 : "деньги",
    7 : "хобби",
  };

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListenableBuilder(
      listenable: widget.selectedDate,
      builder: (context, listener) {
        return BlocBuilder<BalanceWheelBloc, BalanceWheelState>(
          builder: (context, state) {
            if(state is BalanceWheelLoadedState){
              getList(state.view);

              return RefreshIndicator(
                color: AppColors.darkGreenColor,
                onRefresh: (){
                  context.read<BalanceWheelBloc>().add(BalanceWheelGetEvent(widget.selectedDate.date));
                  return Future.delayed(const Duration(seconds: 1));
                },
                child: ListView(
                  children: [
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Text(
                        "Выберите и нажмите на нужный сегмент Колеса баланса и оцените от 1 до 10 по шкале удовлетворенности, где 1 – ты недоволен, а 10 – это твой идеал на сегодня",
                        style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkGreenColor
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(enabled: false),
                                borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(
                                        color: AppColors.grey40Color
                                    )
                                ),
                                sectionsSpace: 1,
                                centerSpaceRadius: 0,
                                sections: showingSections(),
                              ),
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(enabled: false),
                                sectionsSpace: 1,
                                centerSpaceRadius: 0,
                                sections: showingSectionsBasic(),
                              ),
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback: (FlTouchEvent event, pieTouchResponse) {

                                    debugPrint(pieTouchResponse?.touchedSection?.touchedSectionIndex.toString());

                                    int? id = pieTouchResponse?.touchedSection?.touchedSectionIndex;
                                    String? categoryId;

                                    if(id == 0) categoryId = "карьера";
                                    else if(id == 1) categoryId = "здоровье";
                                    else if(id == 2) categoryId = "друзья";
                                    else if(id == 3) categoryId = "семья";
                                    else if(id == 4) categoryId = "отдых";
                                    else if(id == 5) categoryId = "саморазвитие";
                                    else if(id == 6) categoryId = "деньги";
                                    else if(id == 7) categoryId = "хобби";

                                    debugPrint(categoryId);

                                    if(categoryId != null && !isInit){
                                      isInit = true;

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
                                          title: 'Оцените сферу вашей жизни',
                                          content: ClientSurveyBalanceWheelSingleTypeSheet(
                                            categoryType: categoryId!,
                                            date: widget.selectedDate.date,
                                          ),
                                        ),
                                      ).then((value) {
                                        if (value == true) {
                                          isInit = false;
                                          context.read<BalanceWheelBloc>().add(BalanceWheelGetEvent(widget.selectedDate.date));
                                        }
                                      });
                                    }

                                  },
                                ),
                                sectionsSpace: 1,
                                centerSpaceRadius: 0,
                                sections: showingSectionsBasic2(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            else if(state is BalanceWheelLoadingState){
              return SizedBox(height: MediaQuery.of(context).size.height / 1.8, child: ProgressIndicatorWidget());
            }
            else if(state is BalanceWheelErrorState){
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.8,
                child: ErrorWithReload(
                  callback: () {
                    context.read<BalanceWheelBloc>().add(BalanceWheelGetEvent(widget.selectedDate.date));
                  },
                ),
              );
            }
            return Container();
          }
        );
      }
    );
  }

  getList(Map<String, List<BalanceWheel>>? view){
    list = {
      "карьера": 0,
      "здоровье" : 0,
      "друзья" : 0,
      "семья" : 0,
      "отдых" : 0,
      "саморазвитие" : 0,
      "деньги" : 0,
      "хобби" : 0,
    };

    if(view != null && view.isNotEmpty){
      Map<String, List<BalanceWheel>> newMap = {};

      view.forEach((key, val){
        if(val.isNotEmpty){
          val.forEach((element){
            if(element.categoryName != null && element.grade != null && element.create != null){
              newMap.update(key, (value) => value..add(element), ifAbsent: () => [element]);
            }
          });
        }
      });

      if(newMap.isNotEmpty){
        newMap.forEach((key, val){
          val.sort((a, b){
            DateTime aDate = DateTime.parse(a.create!);
            DateTime bDate = DateTime.parse(b.create!);
            return bDate.compareTo(aDate);
          });
        });

        newMap.forEach((key, val){
          list.update(key, (newVal)=> val.first.grade ?? 0);
        });
      }
    }
  }

  // подложка
  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> list = [];

    balanceWheel.categoryList.forEach((element) {
      list.add(PieChartSectionData(
        color: element.color.withOpacity(0.2),
        radius: 120,
        showTitle: false,
        borderSide: BorderSide(
            color: AppColors.basicwhiteColor
        ),
        titleStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          fontFamily: "Inter",
          color: AppColors.basicwhiteColor,
        ),
        badgeWidget: Container(
          width: 125,
          height: 65,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  element.title.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      color: element.color,
                      fontFamily: 'Inter'
                  ),
                ),
                SvgPicture.asset(element.image),
              ],
            ),
          ),
        ),
        badgePositionPercentageOffset: 1.35,
      ));
    });
    return list;
  }


  // основной график
  List<PieChartSectionData> showingSectionsBasic() {
    return List.generate(8, (i) {

      switch (i) {
        case 0:
          return pieChartElementBasic(
              color: Color(0xFFBE3455) ,
              value: list["карьера"] ?? 0
          );
        case 1:
          return pieChartElementBasic(
              color: Color(0xFF00817D) ,
              value: list["здоровье"] ?? 0
          );
        case 2:
          return pieChartElementBasic(
              color: Color(0xFFFF9F00) ,
              value: list["друзья"] ?? 0
          );
        case 3:
          return pieChartElementBasic(
              color: Color(0xFF15ABEE) ,
              value: list["семья"] ?? 0
          );
        case 4:
          return pieChartElementBasic(
              color: Color(0xFF688602) ,
              value: list["отдых"] ?? 0
          );
        case 5:
          return pieChartElementBasic(
              color: Color(0xFF5AA8A5) ,
              value: list["саморазвитие"] ?? 0
          );
        case 6:
          return pieChartElementBasic(
              color: Color(0xFFAA589B) ,
              value: list["деньги"] ?? 0
          );
        default:
          return pieChartElementBasic(
              color: Color(0xFFC5763B) ,
              value: list["хобби"] ?? 0
          );;
      }
    });
  }

  PieChartSectionData pieChartElementBasic({required Color color, required int value}){
    return PieChartSectionData(
      color: color,
      showTitle: value == 1 || value == 2 ? false : true,
      title: value.toString(),
      radius: value == 10 ? 120 : (value * 10 * 125) / 100,
      borderSide: BorderSide(
          color: Colors.transparent
      ),
      titleStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        fontFamily: "Inter",
        color: AppColors.basicwhiteColor,
      ),
      badgePositionPercentageOffset: 1.6,
      badgeWidget: value == 1 || value == 2 ? Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Center(
          child: Text(
            value.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                color: AppColors.basicwhiteColor,
                fontFamily: 'Inter'
            ),
          ),
        ),
      ) : null,
    );
  }


  // tap logic
  List<PieChartSectionData> showingSectionsBasic2() {
    return List.generate(8, (i) {

      switch (i) {
        case 0:
          return pieChartElementBasic2(
              color: Colors.transparent,
              value: list["карьера"] ?? 0
          );
        case 1:
          return pieChartElementBasic2(
              color: Colors.transparent,
              value: list["здоровье"] ?? 0
          );
        case 2:
          return pieChartElementBasic2(
              color: Colors.transparent,
              value: list["друзья"] ?? 0
          );
        case 3:
          return pieChartElementBasic2(
              color: Colors.transparent,
              value: list["семья"] ?? 0
          );
        case 4:
          return pieChartElementBasic2(
              color: Colors.transparent,
              value: list["отдых"] ?? 0
          );
        case 5:
          return pieChartElementBasic2(
              color: Colors.transparent,
              value: list["саморазвитие"] ?? 0
          );
        case 6:
          return pieChartElementBasic2(
              color: Colors.transparent,
              value: list["деньги"] ?? 0
          );
        default:
          return pieChartElementBasic2(
              color: Colors.transparent,
              value: list["хобби"] ?? 0
          );;
      }
    });
  }

  PieChartSectionData pieChartElementBasic2({required Color color, required int value}){
    return PieChartSectionData(
      color: color,
      showTitle: false,
      radius: 180,
      borderSide: BorderSide(
          color: Colors.transparent
      ),
    );
  }

}


