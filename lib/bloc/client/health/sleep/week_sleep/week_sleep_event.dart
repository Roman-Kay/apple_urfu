
part of "week_sleep_bloc.dart";

class WeekSleepEvent{}

class WeekSleepGetEvent extends WeekSleepEvent{
  int dayQuantity;
  DateTime date;
  int? clientId;

  WeekSleepGetEvent({
    required this.dayQuantity,
    required this.date,
    this.clientId
  });
}