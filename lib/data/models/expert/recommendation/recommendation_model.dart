
import 'package:json_annotation/json_annotation.dart';

part 'recommendation_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertRecommendationsResponse{
  ExpertRecommendationsResponse({
    required this.code,
    this.message,
    this.recommendations
});
  int code;
  String? message;
  List<ExpertRecommendationsView>? recommendations;

  factory ExpertRecommendationsResponse.fromJson(Map<String, dynamic> json) => _$ExpertRecommendationsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertRecommendationsResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertRecommendationsView{
  ExpertRecommendationsView({
    this.expertId,
    this.firstName,
    this.lastName,
    this.create,
    this.update,
    this.expertRecommendationId,
    this.from,
    this.fromOrg,
    this.recommendation
});

  String? create;

  @JsonKey(
    name: 'expertId',
  )
  int? expertId;

  @JsonKey(
    name: 'expertRecommendationId',
  )
  int? expertRecommendationId;

  @JsonKey(
    name: 'firstName',
  )
  String? firstName;
  String? from;

  @JsonKey(
    name: 'fromOrg',
  )
  String? fromOrg;

  @JsonKey(
    name: 'lastName',
  )
  String? lastName;
  String? recommendation;
  String? update;

  factory ExpertRecommendationsView.fromJson(Map<String, dynamic> json) => _$ExpertRecommendationsViewFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertRecommendationsViewToJson(this);
}



@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertRecommendationsRequest{
  ExpertRecommendationsRequest({
    this.recommendation,
    this.fromOrg,
    this.from,
    this.expertEducationId
});

  @JsonKey(
    name: 'expertEducationId',
  )
  int? expertEducationId;
  String? from;

  @JsonKey(
    name: 'fromOrg',
  )
  String? fromOrg;
  String? recommendation;


  factory ExpertRecommendationsRequest.fromJson(Map<String, dynamic> json) => _$ExpertRecommendationsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertRecommendationsRequestToJson(this);
}