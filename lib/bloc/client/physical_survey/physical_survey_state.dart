
part of "physical_survey_bloc.dart";

class PhysicalSurveyState{}

class PhysicalSurveyInitialState extends PhysicalSurveyState{}

class PhysicalSurveyLoadingState extends PhysicalSurveyState{}

class PhysicalSurveyLoadedState extends PhysicalSurveyState{
  FQuizItem? view;
  PhysicalSurveyLoadedState(this.view);
}

class PhysicalSurveyErrorState extends PhysicalSurveyState{}