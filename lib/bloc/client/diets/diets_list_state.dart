
part of 'diets_list_bloc.dart';


class DietsListState{}

class DietsListInitialState extends DietsListState{}

class DietsListLoadingState extends DietsListState{}

class DietsListLoadedState extends DietsListState{
  List<Diets>? view;
  DietsListLoadedState(this.view);
}

class DietsListErrorState extends DietsListState{}