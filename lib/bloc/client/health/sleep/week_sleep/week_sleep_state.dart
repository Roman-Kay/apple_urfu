
part of 'week_sleep_bloc.dart';

class WeekSleepState{}

class WeekSleepInitialState extends WeekSleepState{}

class WeekSleepLoadingState extends WeekSleepState{}

class WeekSleepLoadedState extends WeekSleepState{
  List<ClientSensorsView>? list;
  WeekSleepLoadedState(this.list);
}

class WeekSleepErrorState extends WeekSleepState{}