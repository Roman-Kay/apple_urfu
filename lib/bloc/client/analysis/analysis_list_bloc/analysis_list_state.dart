
part of 'analysis_list_bloc.dart';

class AnalysisListState{}

class AnalysisListInitialState extends AnalysisListState{}

class AnalysisListLoadingState extends AnalysisListState{}

class AnalysisListLoadedState extends AnalysisListState{
  List<ClientTestShort>? view;
  AnalysisListLoadedState(this.view);
}

class AnalysisListErrorState extends AnalysisListState{}