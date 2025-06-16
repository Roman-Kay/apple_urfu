
part of "expert_data_bloc.dart";

class ExpertDataState{}

class ExpertDataInitialState extends ExpertDataState{}

class ExpertDataLoadingState extends ExpertDataState{}

class ExpertDataLoadedState extends ExpertDataState{
  ExpertFullCardView? view;
  ExpertDataLoadedState(this.view);
}

class ExpertDataErrorState extends ExpertDataState{}