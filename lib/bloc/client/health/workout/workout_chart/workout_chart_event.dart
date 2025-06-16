
part of 'workout_chart_bloc.dart';

class WorkoutChartEvent{}

class WorkoutChartGetEvent extends WorkoutChartEvent{
  int dayQuantity;
  DateTime date;
  WorkoutChartGetEvent(this.dayQuantity, this.date);
}