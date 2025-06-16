

import 'package:garnetbook/data/models/client/recommendation/recommendation_survey.dart';
import 'package:garnetbook/data/models/client/short_card/client_short_card.dart';
import 'package:garnetbook/data/models/expert/list/expert_list.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_request.dart';
import 'package:json_annotation/json_annotation.dart';

part "questionnaire_response.g.dart";


@JsonSerializable()
class QuestionnaireShort{
  QuestionnaireShort({
    this.create,
    this.message,
    this.code,
    this.statusCode,
    this.statusName,
    this.passed,
    this.id,
    this.questionnaireId,
    this.title,
    this.expertId,
    this.clientId,
    this.token,
    this.expertPosition,
    this.expertFirstName
});


  int? code;
  String? create;
  int? clientId;
  int? expertId;
  String? expertFirstName;
  String? expertPosition;
  int? id;
  String? message;
  String? passed;
  int? questionnaireId;
  String? statusCode;
  String? statusName;
  String? title;
  String? token;

  factory QuestionnaireShort.fromJson(Map<String, dynamic> json) => _$QuestionnaireShortFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionnaireShortToJson(this);

}


@JsonSerializable()
class Questionnaire{
  Questionnaire({
    this.title,
    this.questionnaireId,
    this.id,
    this.questionsDates,
    this.passed,
    this.dass,
    this.statusName,
    this.statusCode,
    this.result,
    this.text,
    this.comment,
    this.color,
    this.code,
    this.message,
    this.expert,
    this.create,
    this.client,
    this.recommendations
});

  ClientShortCardView? client;
  int? code;
  String? color;
  String? comment;
  String? create;
  List<QuestionnaireDass>? dass;
  ExpertShortCardView? expert;
  int? id;
  String? message;
  String? passed;
  int? questionnaireId;
  List<QuestionnaireQuestionsData>? questionsDates;
  List<Recommendation>? recommendations;
  int? result;
  String? statusCode;
  String? statusName;
  String? text;
  String? title;

  factory Questionnaire.fromJson(Map<String, dynamic> json) => _$QuestionnaireFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionnaireToJson(this);

}