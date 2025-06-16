
part of "client_recommendation_bloc.dart";

class ClientCardRecommendationState{}

class ClientCardRecommendationInitialState extends ClientCardRecommendationState{}

class ClientCardRecommendationLoadingState extends ClientCardRecommendationState{}

class ClientCardRecommendationLoadedState extends ClientCardRecommendationState{
  List<ClientRecommendationShortView>? view;
  ClientCardRecommendationLoadedState(this.view);
}

class ClientCardRecommendationErrorState extends ClientCardRecommendationState{}