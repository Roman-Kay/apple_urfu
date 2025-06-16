import 'package:json_annotation/json_annotation.dart';

part 'platform_recommendation.g.dart';

@JsonSerializable()
class PlatformRecommendationModel {
  PlatformRecommendationModel({
    required this.recommendation
  });

  final Map<String, List<Recommendation2>>? recommendation;

  factory PlatformRecommendationModel.fromJson(Map<String, dynamic> json) => _$PlatformRecommendationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlatformRecommendationModelToJson(this);

}

@JsonSerializable()
class Recommendation2 {
  Recommendation2({
    required this.id,
    required this.remoteId,
    required this.remoteName,
    required this.remoteTitle,
    required this.remoteType,
  });

  final int? id;
  final int? remoteId;
  final String? remoteName;
  final String? remoteTitle;
  final String? remoteType;

  factory Recommendation2.fromJson(Map<String, dynamic> json) => _$Recommendation2FromJson(json);

  Map<String, dynamic> toJson() => _$Recommendation2ToJson(this);

}
