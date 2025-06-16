

part of "health_step_bloc.dart";

class HealthStepState{}

class HealthStepInitialState extends HealthStepState{}

class HealthStepLoadingState extends HealthStepState{}

class HealthStepLoadedState extends HealthStepState{
  int steps;
  int calorie;
  double distance;
  int hours;
  bool connected;

  HealthStepLoadedState({
    required this.steps,
    required this.hours,
    required this.distance,
    required this.calorie,
    required this.connected
});
}

class HealthStepErrorState extends HealthStepState{}

class HealthStepNotConnectedState extends HealthStepState{}