
part of 'additives_cubit.dart';

class AdditivesState{}

class AdditivesInitialState extends AdditivesState{}

class AdditivesLoadingState extends AdditivesState{}

class AdditivesLoadedState extends AdditivesState{
  ClientAdditivesResponse? view;
  AdditivesLoadedState(this.view);
}

class AdditivesErrorState extends AdditivesState{}