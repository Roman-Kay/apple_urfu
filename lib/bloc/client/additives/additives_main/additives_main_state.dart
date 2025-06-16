
part of "additives_main_cubit.dart";

class AdditivesMainState{}

class AdditivesMainInitialState extends AdditivesMainState{}

class AdditivesMainLoadingState extends AdditivesMainState{}

class AdditivesMainLoadedState extends AdditivesMainState{
  List<AdditiveSlotsView>? list;
  AdditivesMainLoadedState(this.list);
}

class AdditivesMainErrorState extends AdditivesMainState{}
