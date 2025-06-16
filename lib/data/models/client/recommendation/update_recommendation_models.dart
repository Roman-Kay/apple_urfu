
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_models.dart';
import 'package:json_annotation/json_annotation.dart';

part "update_recommendation_models.g.dart";


@JsonSerializable()
class UpdateClientRecommendationsRequest{
  UpdateClientRecommendationsRequest({
    this.recommendationId,
    this.recommendationDesc,
    this.file,
    this.expertId,
    this.clientId,
    this.recommendationStatusId,
    this.recommendationTypeId,
    this.recommendationName
});

  int? clientId;
  int? expertId;
  ImageView? file;
  String? recommendationDesc;
  int? recommendationId;
  int? recommendationStatusId;
  int? recommendationTypeId;
  String? recommendationName;

  factory UpdateClientRecommendationsRequest.fromJson(Map<String, dynamic> json) => _$UpdateClientRecommendationsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateClientRecommendationsRequestToJson(this);
}


@JsonSerializable()
class UpdateClientRecommendationsResponse{
  UpdateClientRecommendationsResponse({
    this.recommendation,
    this.code,
    this.message
});

  int? code;
  String? message;
  ClientRecommendationView? recommendation;

  factory UpdateClientRecommendationsResponse.fromJson(Map<String, dynamic> json) => _$UpdateClientRecommendationsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateClientRecommendationsResponseToJson(this);
}