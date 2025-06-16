
part of "water_diary_chart_bloc.dart";

class WaterDiaryChartEvent{}

class WaterDiaryChartGetEvent extends WaterDiaryChartEvent{
  int month;
  int year;
  WaterDiaryChartGetEvent(this.month, this.year);
}