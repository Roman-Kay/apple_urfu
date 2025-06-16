

part of 'experience_bloc.dart';

class ExperienceExpertState{}

class ExperienceExpertInitialState extends ExperienceExpertState{}

class ExperienceExpertLoadingState extends ExperienceExpertState{}

class ExperienceExpertLoadedState extends ExperienceExpertState{
  List<ExpertExperienceView>? view;
  ExperienceExpertLoadedState(this.view);
}

class ExperienceExpertErrorState extends ExperienceExpertState{}