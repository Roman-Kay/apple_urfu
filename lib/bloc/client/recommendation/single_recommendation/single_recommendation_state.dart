
part of 'single_recommendation_bloc.dart';

class SingleRecommendationState{}

class SingleRecommendationInitialState extends SingleRecommendationState{}

class SingleRecommendationLoadingState extends SingleRecommendationState{}

class SingleRecommendationLoadedState extends SingleRecommendationState{
  RecommendationData? data;
  SingleRecommendationLoadedState(this.data);
}

class SingleRecommendationErrorState extends SingleRecommendationState{}