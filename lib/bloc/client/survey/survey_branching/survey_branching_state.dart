
part of "survey_branching_bloc.dart";

class SurveyBranchingState{}

class SurveyBranchingInitialState extends SurveyBranchingState{}

class SurveyBranchingLoadingState extends SurveyBranchingState{}

class SurveyBranchingLoadedState extends SurveyBranchingState{
  List<NextStep> nextStep;
  String? message;
  SurveyBranchingLoadedState(this.nextStep, this.message);
}

class SurveyBranchingErrorState extends SurveyBranchingState{}