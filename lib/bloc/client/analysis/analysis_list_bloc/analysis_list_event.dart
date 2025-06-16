
part of 'analysis_list_bloc.dart';

class AnalysisListEvent {}

class AnalysisListGetEvent extends AnalysisListEvent{
  int clientId;
  AnalysisListGetEvent(this.clientId);
}

class AnalysisListInitialEvent extends AnalysisListEvent{}