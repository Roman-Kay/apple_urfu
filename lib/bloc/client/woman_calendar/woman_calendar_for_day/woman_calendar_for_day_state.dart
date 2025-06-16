
part of 'woman_calendar_for_day_bloc.dart';

class WomanCalendarForDayState{}

class WomanCalendarForDayInitialState extends WomanCalendarForDayState{}

class WomanCalendarForDayLoadingState extends WomanCalendarForDayState{}

class WomanCalendarForDayLoadedState extends WomanCalendarForDayState{
  ClientPeriodView? view;
  WomanCalendarForDayLoadedState(this.view);
}

class WomanCalendarForDayErrorState extends WomanCalendarForDayState{}