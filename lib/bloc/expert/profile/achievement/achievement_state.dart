
part of 'achievement_bloc.dart';

class AchievementsExpertState{}

class AchievementsExpertInitialState extends AchievementsExpertState{}

class AchievementsExpertLoadingState extends AchievementsExpertState{}

class AchievementsExpertLoadedState extends AchievementsExpertState{
  List<ExpertAchievesView>? view;
  AchievementsExpertLoadedState(this.view);
}

class AchievementsExpertErrorState extends AchievementsExpertState{}