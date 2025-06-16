
part of "calendar_for_day_bloc.dart";

class CalendarForDayState{}

class CalendarForDayInitialState extends CalendarForDayState{}

class CalendarForDayLoadingState extends CalendarForDayState{}

class CalendarForDayLoadedState extends CalendarForDayState{
  EventsAndIndicatorsForDayResponse? view;
  CalendarForDayLoadedState(this.view);
}

class CalendarForDayErrorState extends CalendarForDayState{}