
part of 'achievement_bloc.dart';

class AchievementsExpertEvent{}

class AchievementsExpertGetEvent extends AchievementsExpertEvent{}

class AchievementsExpertAddEvent extends AchievementsExpertEvent{
  ExpertAchievesRequest request;
  AchievementsExpertAddEvent(this.request);
}

class AchievementsExpertDeleteEvent extends AchievementsExpertEvent{
  int id;
  AchievementsExpertDeleteEvent(this.id);
}