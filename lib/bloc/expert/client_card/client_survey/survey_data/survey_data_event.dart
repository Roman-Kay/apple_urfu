
part of "survey_data_bloc.dart";

class SurveyDataEvent{}

class SurveyDataGetEvent extends SurveyDataEvent{
  int surveyId;
  SurveyDataGetEvent(this.surveyId);
}

class SurveyDataInitialEvent extends SurveyDataEvent{}