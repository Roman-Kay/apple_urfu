
part of 'recommendation_bloc.dart';

class RecommendationExpertState{}

class RecommendationExpertInitialState extends RecommendationExpertState{}

class RecommendationExpertLoadingState extends RecommendationExpertState{}

class RecommendationExpertLoadedState extends RecommendationExpertState{
  List<ExpertRecommendationsView>? view;
  RecommendationExpertLoadedState(this.view);
}

class RecommendationExpertErrorState extends RecommendationExpertState{}