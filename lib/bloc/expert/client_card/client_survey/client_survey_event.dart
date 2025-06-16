
part of "client_survey_bloc.dart";

class ClientCardSurveyEvent{}

class ClientCardSurveyGetEvent extends ClientCardSurveyEvent{
  int id;
  ClientCardSurveyGetEvent(this.id);
}

class ClientCardSurveyInitialEvent extends ClientCardSurveyEvent{}