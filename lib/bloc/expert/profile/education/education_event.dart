
part of 'education_bloc.dart';

class EducationExpertEvent{}

class EducationExpertGetEvent extends EducationExpertEvent{}

class EducationExpertAddEvent extends EducationExpertEvent{
  ExpertEducationRequest request;
  EducationExpertAddEvent(this.request);
}

class EducationExpertDeleteEvent extends EducationExpertEvent{
  int id;
  EducationExpertDeleteEvent(this.id);
}