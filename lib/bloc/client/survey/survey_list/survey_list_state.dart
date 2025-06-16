
part of 'survey_list_cubit.dart';

class SurveyListState{}

class SurveyListInitialState extends SurveyListState{}

class SurveyListLoadingState extends SurveyListState{}

class SurveyListLoadedState extends SurveyListState{
  List<QuestionnaireShort>? list;
  SurveyListLoadedState(this.list);
}

class SurveyListErrorState extends SurveyListState{}