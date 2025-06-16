
part of "survey_bloc.dart";

class SurveyState{}

class SurveyInitialState extends SurveyState{}

class SurveyLoadingState extends SurveyState{}

class SurveyLoadedState extends SurveyState{
  QuizItem? quizItem;
  SurveyLoadedState(this.quizItem);
}

class SurveyErrorState extends SurveyState{}