
part of 'recommendation_bloc.dart';

class RecommendationExpertEvent{}

class RecommendationGetEvent extends RecommendationExpertEvent{}

class RecommendationAddEvent extends RecommendationExpertEvent{
  ExpertRecommendationsRequest request;
  RecommendationAddEvent(this.request);
}