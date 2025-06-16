
part of "selection_list_cubit.dart";

class SelectionListState{}

class SelectionListInitialState extends SelectionListState{}

class SelectionListLoadingState extends SelectionListState{}

class SelectionListLoadedState extends SelectionListState{
  List<AllQuizModel>? list;
  SelectionListLoadedState(this.list);
}

class SelectionListErrorState extends SelectionListState{}