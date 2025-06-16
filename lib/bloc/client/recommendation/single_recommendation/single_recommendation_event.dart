
part of 'single_recommendation_bloc.dart';

class SingleRecommendationEvent{}

class SingleRecommendationGetEvent extends SingleRecommendationEvent{
  int id;
  String type;
  SingleRecommendationGetEvent(this.id, this.type);
}