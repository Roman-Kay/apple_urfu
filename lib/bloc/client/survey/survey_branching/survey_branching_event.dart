
part of "survey_branching_bloc.dart";

class SurveyBranchingEvent{}

class SurveyBranchingGeEvent extends SurveyBranchingEvent{
  int stepId;
  SurveyBranchingGeEvent(this.stepId);
}