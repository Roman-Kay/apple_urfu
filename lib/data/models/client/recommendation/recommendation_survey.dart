
import 'package:json_annotation/json_annotation.dart';

part 'recommendation_survey.g.dart';


@JsonSerializable()
class Recommendation{
  Recommendation({
    this.id,
    this.remoteId,
    this.remoteTitle,
    this.remoteType,
    this.remoteName
});

  int? id;
  int? remoteId;
  String? remoteTitle;
  String? remoteType;
  String? remoteName;


  factory Recommendation.fromJson(Map<String, dynamic> json) => _$RecommendationFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationToJson(this);
}


@JsonSerializable()
class QuestionnaireRecommendation{
  QuestionnaireRecommendation({
    this.id,
    this.recommendations,
    this.clientId,
    this.expertId,
    this.message,
    this.code,
    this.questionnaireId,
    this.statusCode,
    this.statusName,
    this.title
  });

  int? clientId;
  int? code;
  int? expertId;
  int? id;
  String? message;
  int? questionnaireId;
  List<Recommendation>? recommendations;
  String? statusCode;
  String? statusName;
  String? title;


  factory QuestionnaireRecommendation.fromJson(Map<String, dynamic> json) => _$QuestionnaireRecommendationFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionnaireRecommendationToJson(this);
}