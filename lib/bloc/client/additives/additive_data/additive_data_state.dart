
part of "additive_data_bloc.dart";

class AdditiveDataState{}

class AdditiveDataInitialState extends AdditiveDataState{}

class AdditiveDataLoadingState extends AdditiveDataState{}

class AdditiveDataLoadedState extends AdditiveDataState{
  ClientAdditivesView? view;
  AdditiveDataLoadedState(this.view);
}

class AdditiveDataErrorState extends AdditiveDataState{}