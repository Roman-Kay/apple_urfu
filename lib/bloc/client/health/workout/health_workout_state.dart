
part of 'health_workout_bloc.dart';

class HealthWorkoutState{}

class HealthWorkoutInitialState extends HealthWorkoutState{}

class HealthWorkoutLoadingState extends HealthWorkoutState{}

class HealthWorkoutLoadedState extends HealthWorkoutState{
  List<ClientActivityView>? view;
  DateTime? date;

  HealthWorkoutLoadedState(this.view, this.date);
}

class HealthWorkoutErrorState extends HealthWorkoutState{}

class HealthWorkoutNotConnectedState extends HealthWorkoutState{}
