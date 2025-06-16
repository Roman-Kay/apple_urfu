
part of 'education_bloc.dart';

class EducationExpertState{}

class EducationExpertInitialState extends EducationExpertState{}

class EducationExpertLoadingState extends EducationExpertState{}

class EducationExpertLoadedState extends EducationExpertState{
  List<ExpertEducationView>? view;
  EducationExpertLoadedState(this.view);
}

class EducationExpertErrorState extends EducationExpertState{}