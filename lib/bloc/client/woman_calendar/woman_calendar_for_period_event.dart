
part of 'woman_calendar_for_period_bloc.dart';

class WomanCalendarForPeriodEvent{}

class WomanCalendarForPeriodGetEvent extends WomanCalendarForPeriodEvent{
  int date;
  WomanCalendarForPeriodGetEvent(this.date);
}