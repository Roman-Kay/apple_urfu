
part of "my_expert_cubit.dart";

class MyExpertState{}

class MyExpertInitialState extends MyExpertState{}

class MyExpertLoadingState extends MyExpertState{}

class MyExpertLoadedState extends MyExpertState{
  List<ExpertShortCardView>? view;
  MyExpertLoadedState(this.view);
}

class MyExpertErrorState extends MyExpertState{}