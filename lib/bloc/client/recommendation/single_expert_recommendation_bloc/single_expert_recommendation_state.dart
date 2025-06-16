
part of 'single_expert_recommendation_bloc.dart';

class SingleExpertRecommendationState {}

class SingleExpertRecommendationInitialState extends SingleExpertRecommendationState{}

class SingleExpertRecommendationLoadingState extends SingleExpertRecommendationState{}

class SingleExpertRecommendationLoadedState extends SingleExpertRecommendationState{
  ClientRecommendationView? view;
  SingleExpertRecommendationLoadedState(this.view);
}

class SingleExpertRecommendationErrorState extends SingleExpertRecommendationState{}