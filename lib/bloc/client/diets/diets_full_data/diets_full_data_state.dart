
part of 'diets_full_data_bloc.dart';

class DietsFullDataState{}

class DietsFullDataInitialState extends DietsFullDataState{}

class DietsFullDataLoadingState extends DietsFullDataState{}

class DietsFullDataLoadedState extends DietsFullDataState{
  Diets? view;
  DietsFullDataLoadedState(this.view);
}

class DietsFullDataErrorState extends DietsFullDataState{}