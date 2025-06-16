

part of "today_workout_cubit.dart";

class TodayWorkoutState{}

class TodayWorkoutInitialState extends TodayWorkoutState{}

class TodayWorkoutLoadingState extends TodayWorkoutState{}

class TodayWorkoutLoadedState extends TodayWorkoutState{
  int calories;
  DateTime? date;
  TodayWorkoutLoadedState(this.calories, this.date);
}

class TodayWorkoutErrorState extends TodayWorkoutState{}