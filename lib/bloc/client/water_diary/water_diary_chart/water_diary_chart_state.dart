
part of "water_diary_chart_bloc.dart";

class WaterDiaryChartState{}

class WaterDiaryChartInitialState extends WaterDiaryChartState{}

class WaterDiaryChartLoadingState extends WaterDiaryChartState{}

class WaterDiaryChartLoadedState extends WaterDiaryChartState{
  List<ClientWaterView>? list;
  WaterDiaryChartLoadedState(this.list);
}

class WaterDiaryChartErrorState extends WaterDiaryChartState{}