

part of 'calendar_cubit.dart';

class CalendarState{}

class CalendarInitialState extends CalendarState{}

class CalendarLoadingState extends CalendarState{}

class CalendarLoadedState extends CalendarState{
  List<EventView>? view;
  CalendarLoadedState(this.view);
}

class CalendarErrorState extends CalendarState{}