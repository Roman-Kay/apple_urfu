
part of 'platform_recommendation_cubit.dart';

class PlatformRecommendationState{}

class PlatformRecommendationInitialState extends PlatformRecommendationState{}

class PlatformRecommendationLoadingState extends PlatformRecommendationState{}

class PlatformRecommendationLoadedState extends PlatformRecommendationState{
  Map<String, List<Recommendation2>>? view;
  PlatformRecommendationLoadedState(this.view);
}

class PlatformRecommendationErrorState extends PlatformRecommendationState{}