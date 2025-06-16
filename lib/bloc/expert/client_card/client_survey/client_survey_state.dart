
part of "client_survey_bloc.dart";

class ClientCardSurveyState{}

class ClientCardSurveyInitialState extends ClientCardSurveyState{}

class ClientCardSurveyLoadingState extends ClientCardSurveyState{}

class ClientCardSurveyLoadedState extends ClientCardSurveyState{
  List<QuestionnaireShort>? list;
  ClientCardSurveyLoadedState(this.list);
}

class ClientCardSurveyErrorState extends ClientCardSurveyState{}
