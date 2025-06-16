
part of "calendar_for_day_bloc.dart";

class CalendarForDayEvent{}

class CalendarForDayGetEvent extends CalendarForDayEvent{
  String day;
  CalendarForDayGetEvent(this.day);
}