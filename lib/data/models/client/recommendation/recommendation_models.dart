
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:json_annotation/json_annotation.dart';

part "recommendation_models.g.dart";


@JsonSerializable()
class ClientRecommendationsResponse{
  ClientRecommendationsResponse({
    this.message,
    this.code,
    this.recommendations
});

  int? code;
  int? id;
  String? message;
  List<ClientRecommendationShortView>? recommendations;
  String? token;

  factory ClientRecommendationsResponse.fromJson(Map<String, dynamic> json) => _$ClientRecommendationsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClientRecommendationsResponseToJson(this);

}


@JsonSerializable()
class ClientRecommendationShortView{
  ClientRecommendationShortView({
    this.expertPosition,
    this.expertFirstName,
    this.expertId,
    this.recommendationType,
    this.recommendationId,
    this.expertLastName,
    this.recommendationPlatform,
    this.recommendationStatus,
    this.update,
    this.create,
    this.recommendationName,
    this.recommendationDesc
});

  String? expertFirstName;
  int? expertId;
  String? expertLastName;
  String? expertPosition;
  int? recommendationId;
  bool? recommendationPlatform;
  ReferenceTrackerStatusesView? recommendationStatus;
  RecommendationTypesView? recommendationType;
  String? create;
  String? update;
  String? recommendationDesc;
  String? recommendationName;


  factory ClientRecommendationShortView.fromJson(Map<String, dynamic> json) => _$ClientRecommendationShortViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientRecommendationShortViewToJson(this);
}


@JsonSerializable()
class ClientRecommendationView{
  ClientRecommendationView({
    this.create,
    this.update,
    this.expertId,
    this.recommendationPlatform,
    this.file,
    this.recommendationDesc,
    this.recommendationId,
    this.recommendationStatus,
    this.recommendationType,
    this.expertLastName,
    this.expertFirstName,
    this.expertPosition,
    this.recommendationName
});

  String? create;
  String? expertFirstName;
  int? expertId;
  String? expertLastName;
  String? expertPosition;
  FileView? file;
  String? recommendationDesc;
  int? recommendationId;
  String? update;
  bool? recommendationPlatform;
  ReferenceTrackerStatusesView? recommendationStatus;
  RecommendationTypesView? recommendationType;
  String? recommendationName;

  factory ClientRecommendationView.fromJson(Map<String, dynamic> json) => _$ClientRecommendationViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientRecommendationViewToJson(this);
}


@JsonSerializable()
class ReferenceTrackerStatusesView{
  ReferenceTrackerStatusesView({
    this.name,
    this.id,
    this.create
});

  String? create;
  int? id;
  String? name;

  factory ReferenceTrackerStatusesView.fromJson(Map<String, dynamic> json) => _$ReferenceTrackerStatusesViewFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceTrackerStatusesViewToJson(this);

}


@JsonSerializable()
class RecommendationTypesView{
  RecommendationTypesView({
    this.id,
    this.name,
    this.fileBase64,
});

  FileView? fileBase64;
  int? id;
  String? name;


  factory RecommendationTypesView.fromJson(Map<String, dynamic> json) => _$RecommendationTypesViewFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationTypesViewToJson(this);

}