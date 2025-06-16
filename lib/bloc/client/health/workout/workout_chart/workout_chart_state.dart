
part of 'workout_chart_bloc.dart';

class WorkoutChartState{}

class WorkoutChartInitialState extends WorkoutChartState{}

class WorkoutChartLoadingState extends WorkoutChartState{}

class WorkoutChartLoadedState extends WorkoutChartState{
  List<ClientActivityView>? view;
  WorkoutChartLoadedState(this.view);
}

class WorkoutChartErrorState extends WorkoutChartState{}