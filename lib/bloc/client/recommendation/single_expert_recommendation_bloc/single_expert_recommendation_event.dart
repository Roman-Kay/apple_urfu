
part of 'single_expert_recommendation_bloc.dart';

class SingleExpertRecommendationEvent{}

class SingleExpertRecommendationInitialEvent extends SingleExpertRecommendationEvent{}

class SingleExpertRecommendationGetEvent extends SingleExpertRecommendationEvent{
  int id;
  SingleExpertRecommendationGetEvent(this.id);
}
