
part of 'experience_bloc.dart';

class ExperienceExpertEvent{}

class ExperienceExpertGetEvent extends ExperienceExpertEvent{}

class ExperienceExpertAddEvent extends ExperienceExpertEvent{
  ExpertExperienceRequest request;
  ExperienceExpertAddEvent(this.request);
}

class ExperienceExpertDeleteEvent extends ExperienceExpertEvent{
  int id;
  ExperienceExpertDeleteEvent(this.id);
}