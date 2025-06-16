
part of 'expert_calendar_today_cubit.dart';

class ExpertCalendarTodayState{}

class ExpertCalendarTodayInitialState extends ExpertCalendarTodayState{}

class ExpertCalendarTodayLoadingState extends ExpertCalendarTodayState{}

class ExpertCalendarTodayLoadedState extends ExpertCalendarTodayState{
  EventsAndIndicatorsForDayResponse? view;
  ExpertCalendarTodayLoadedState(this.view);
}

class ExpertCalendarTodayErrorState extends ExpertCalendarTodayState{}