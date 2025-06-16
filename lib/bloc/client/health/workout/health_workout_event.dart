
part of 'health_workout_bloc.dart';

class HealthWorkoutEvent{}

class HealthWorkoutCheckEvent extends HealthWorkoutEvent{
  DateTime startDate;
  HealthWorkoutCheckEvent(this.startDate);
}

class HealthWorkoutGetForExpertEvent extends HealthWorkoutEvent{
  int id;
  int dayQuantity;
  DateTime startDate;
  HealthWorkoutGetForExpertEvent(this.id, this.dayQuantity, this.startDate);
}
