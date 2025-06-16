
part of "physical_survey_bloc.dart";

class PhysicalSurveyEvent{}

class PhysicalSurveyGetEvent extends PhysicalSurveyEvent{
  int id;
  PhysicalSurveyGetEvent(this.id);
}