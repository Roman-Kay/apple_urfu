
part of "selection_single_bloc.dart";

class SelectionSingleState{}

class SelectionSingleInitialState extends SelectionSingleState{}

class SelectionSingleLoadingState extends SelectionSingleState{}

class SelectionSingleLoadedState extends SelectionSingleState{
  List<SelectionView>? list;
  SelectionSingleLoadedState(this.list);
}

class SelectionSingleErrorState extends SelectionSingleState{}