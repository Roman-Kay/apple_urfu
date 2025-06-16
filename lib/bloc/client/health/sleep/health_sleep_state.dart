
part of "health_sleep_bloc.dart";

class HealthSleepState{}

class HealthSleepInitialState extends HealthSleepState{}

class HealthSleepLoadingState extends HealthSleepState{}

class HealthSleepLoadedState extends HealthSleepState{
  int minutes;
  int hours;
  String? date;
  String? health;
  int? clientSensorId;

  HealthSleepLoadedState({
    required this.minutes,
    required this.hours,
    this.date,
    this.health,
    this.clientSensorId
});
}

class HealthSleepErrorState extends HealthSleepState{}

class HealthSleepNotConnectedState extends HealthSleepState{}
