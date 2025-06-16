
part of "survey_data_bloc.dart";

class SurveyDataState{}

class SurveyDataInitialState extends SurveyDataState{}

class SurveyDataLoadingState extends SurveyDataState{}

class SurveyDataLoadedState extends SurveyDataState{
  Questionnaire? survey;
  FileView? report;
  SurveyDataLoadedState(this.survey, this.report);
}

class SurveyDataErrorState extends SurveyDataState{}