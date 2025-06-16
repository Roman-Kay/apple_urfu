
part of 'expert_list_bloc.dart';

class ExpertListState{
  List<ExpertShortCardView>? itemList;
  dynamic error;
  int? nextPageKey;
  bool isLastPage;
  int totalElement;

  ExpertListState({
    this.itemList,
    this.error,
    this.nextPageKey = 0,
    this.isLastPage = false,
    this.totalElement = 0
});
}

class ExpertListInitialState extends ExpertListState{}

class ExpertListLoadingState extends ExpertListState{
  List<ExpertShortCardView> expertList;
  bool isFirstFetch;

  ExpertListLoadingState({
    required this.expertList,
    this.isFirstFetch = false
});
}

class ExpertListLoadedState extends ExpertListState{
  List<ExpertShortCardView> expertList;
  ExpertListLoadedState(this.expertList);
}

class ExpertListFullListState extends ExpertListState{
  List<ExpertShortCardView> expertList;
  ExpertListFullListState(this.expertList);
}

class ExpertListErrorState extends ExpertListState{}