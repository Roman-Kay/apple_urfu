
part of "recommendation_cubit.dart";

class RecommendationState{}

class RecommendationInitialState extends RecommendationState{}

class RecommendationLoadingState extends RecommendationState{}

class RecommendationLoadedState extends RecommendationState{
  ClientRecommendationsResponse? view;
  RecommendationLoadedState(this.view);
}

class RecommendationErrorState extends RecommendationState{}