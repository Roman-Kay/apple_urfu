
import 'package:json_annotation/json_annotation.dart';

part "quiz_request.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class QuizRequest{
  QuizRequest({
    required this.result,
    required this.userId,
    required this.status,
    required this.questionsData,
    required this.resultD,
    required this.resultS,
    required this.resultT,
    this.gender,
    this.qtypeId
  });

  @JsonKey(
    name: 'user_id',
  )
  int userId;
  String? gender;
  int status;
  int result;

  @JsonKey(
    name: 'result_d',
  )
  int resultD;

  @JsonKey(
    name: 'result_t',
  )
  int resultT;

  @JsonKey(
    name: 'result_s',
  )
  int resultS;

  @JsonKey(
    name: 'qtype_id',
  )
  int? qtypeId;

  @JsonKey(
    name: 'questions_data',
  )
  List<QuestionSave> questionsData;

  factory QuizRequest.fromJson(Map<String, dynamic> json) => _$QuizRequestFromJson(json);
  Map<String, dynamic> toJson() => _$QuizRequestToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class QuestionSave{
  QuestionSave({
    this.questionId,
    this.questionPoint
  });


  @JsonKey(
    name: 'question_id',
  )
  int? questionId;

  @JsonKey(
    name: 'question_point',
  )
  int? questionPoint;

  factory QuestionSave.fromJson(Map<String, dynamic> json) => _$QuestionSaveFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionSaveToJson(this);
}