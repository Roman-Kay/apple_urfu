
part of "survey_bloc.dart";

class SurveyEvent{}

class SurveyGetEvent extends SurveyEvent{
  int id;
  SurveyGetEvent(this.id);
}

class SurveyNewEvent extends SurveyEvent{}