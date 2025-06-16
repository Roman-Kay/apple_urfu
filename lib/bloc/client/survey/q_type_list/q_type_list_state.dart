
part of "q_type_list_cubit.dart";

class QTypeListState{}

class QTypeListInitialState extends QTypeListState{}

class QTypeListLoadingState extends QTypeListState{}

class QTypeListLoadedState extends QTypeListState{
  List<QTypeView>? view;
  QTypeListLoadedState(this.view);
}

class QTypeListErrorState extends QTypeListState{}