
part of 'woman_calendar_for_period_bloc.dart';

class  WomanCalendarForPeriodState{}

class  WomanCalendarForPeriodInitialState extends  WomanCalendarForPeriodState{}

class  WomanCalendarForPeriodLoadingState extends  WomanCalendarForPeriodState{}

class  WomanCalendarForPeriodLoadedState extends  WomanCalendarForPeriodState{
  ResponseWomenCalendarResponse? view;
  WomanCalendarForPeriodLoadedState(this.view);
}

class  WomanCalendarForPeriodErrorState extends  WomanCalendarForPeriodState{}