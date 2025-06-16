
import 'package:garnetbook/data/models/client/recommendation/recommendation_survey.dart';
import 'package:json_annotation/json_annotation.dart';

part "questionnaire_request.g.dart";


@JsonSerializable()
class QuestionnaireCreateRequest{
  QuestionnaireCreateRequest({
    this.questionnaireId,
    this.title,
    this.clientId,
});

  int? clientId;
  int? questionnaireId;
  String? title;

  factory QuestionnaireCreateRequest.fromJson(Map<String, dynamic> json) => _$QuestionnaireCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionnaireCreateRequestToJson(this);

}


@JsonSerializable()
class QuestionnaireUpdateRequest{
  QuestionnaireUpdateRequest({
    this.color,
    this.comment,
    this.text,
    this.result,
    this.statusCode,
    this.title,
    this.statusName,
    this.dass,
    this.passed,
    this.questionnaireId,
    this.questionsDates,
    this.expertId,
    this.id,
    this.recommendations
});

  String? color;
  String? comment;
  List<QuestionnaireDass>? dass;
  String? passed;
  int? questionnaireId;
  List<QuestionnaireQuestionsData>? questionsDates;
  List<Recommendation>? recommendations;
  int? result;
  String? statusCode;
  String? statusName;
  String? text;
  String? title;
  int? expertId;
  int? id;

  factory QuestionnaireUpdateRequest.fromJson(Map<String, dynamic> json) => _$QuestionnaireUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionnaireUpdateRequestToJson(this);
}


@JsonSerializable()
class QuestionnaireQuestionsData{
  QuestionnaireQuestionsData({
    this.id,
    this.answerName,
    this.answerResult,
    this.questionnaireExtId,
    this.questionsName,
});

  String? answerName;
  int? answerResult;
  int? id;
  int? questionnaireExtId;
  String? questionsName;

  factory QuestionnaireQuestionsData.fromJson(Map<String, dynamic> json) => _$QuestionnaireQuestionsDataFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionnaireQuestionsDataToJson(this);
}


@JsonSerializable()
class QuestionnaireDass{
  QuestionnaireDass({
    this.result,
    this.id,
    this.text,
    this.type,
    this.comment,
    this.color
});

  String? color;
  String? comment;
  int? id;
  int? result;
  String? text;
  String? type;

  factory QuestionnaireDass.fromJson(Map<String, dynamic> json) => _$QuestionnaireDassFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionnaireDassToJson(this);

}