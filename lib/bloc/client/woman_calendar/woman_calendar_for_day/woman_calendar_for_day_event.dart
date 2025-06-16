
part of 'woman_calendar_for_day_bloc.dart';

class WomanCalendarForDayEvent{}

class WomanCalendarForDayGetEvent extends WomanCalendarForDayEvent{
  DateTime date;
  WomanCalendarForDayGetEvent(this.date);
}