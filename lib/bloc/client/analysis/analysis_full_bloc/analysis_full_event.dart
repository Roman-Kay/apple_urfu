part of 'analysis_full_bloc.dart';

class AnalysisFullEvent{}

class AnalysisFullGetEvent extends AnalysisFullEvent{
  int analysisId;
  AnalysisFullGetEvent(this.analysisId);
}

class AnalysisFullInitialEvent extends AnalysisFullEvent{}