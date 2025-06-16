
part of "additives_for_today_cubit.dart";

class AdditivesForTodayState{}

class AdditivesForTodayInitialState extends AdditivesForTodayState{}

class AdditivesForTodayLoadingState extends AdditivesForTodayState{}

class AdditivesForTodayLoadedState extends AdditivesForTodayState{
  List<AdditiveSlotsView>? list;
  AdditivesForTodayLoadedState(this.list);
}

class AdditivesForTodayErrorState extends AdditivesForTodayState{}