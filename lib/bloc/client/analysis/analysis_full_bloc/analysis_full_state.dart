part of 'analysis_full_bloc.dart';

class AnalysisFullState{}

class AnalysisFullInitialState extends AnalysisFullState{}

class AnalysisFullLoadingState extends AnalysisFullState{}

class AnalysisFullLoadedState extends AnalysisFullState{
  ClientTestDto? view;
  AnalysisFullLoadedState(this.view);
}

class AnalysisFullErrorState extends AnalysisFullState{}