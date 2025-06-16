
part of "client_recommendation_bloc.dart";

class ClientCardRecommendationEvent{}

class ClientCardRecommendationGetEvent extends ClientCardRecommendationEvent{
  int id;
  ClientCardRecommendationGetEvent(this.id);
}

class ClientCardRecommendationInitialEvent extends ClientCardRecommendationEvent{}