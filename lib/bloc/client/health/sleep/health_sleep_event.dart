
part of "health_sleep_bloc.dart";

class HealthSleepEvent{}

class HealthSleepCheckEvent extends HealthSleepEvent{
  DateTime date;
  HealthSleepCheckEvent(this.date);
}

class HealthConnectedEvent extends HealthSleepEvent{
  DateTime date;
  HealthConnectedEvent(this.date);
}