
import 'package:json_annotation/json_annotation.dart';

part "quiz_model.g.dart";

@JsonSerializable()
class AllQuizModel{
  AllQuizModel({
    this.title,
    this.id,
    this.qtypes
});

  int? id;
  List<String>? qtypes;
  String? title;

  factory AllQuizModel.fromJson(Map<String, dynamic> json) => _$AllQuizModelFromJson(json);
  Map<String, dynamic> toJson() => _$AllQuizModelToJson(this);
}


@JsonSerializable()
class QuizItem {
  QuizItem({
    this.id,
    this.title,
    this.questions,
    this.result,
    this.resultD,
    this.resultT,
    this.resultS,
  });

  final int? id;
  final String? title;
  final List<Question>? questions;
  final List<QuizResult>? result;

  @JsonKey(name: 'result_d')
  final List<QuizResult>? resultD;

  @JsonKey(name: 'result_t')
  final List<QuizResult>? resultT;

  @JsonKey(name: 'result_s')
  final List<QuizResult>? resultS;

  factory QuizItem.fromJson(Map<String, dynamic> json) => _$QuizItemFromJson(json);
  Map<String, dynamic> toJson() => _$QuizItemToJson(this);

}

@JsonSerializable()
class Question {
  Question({
    this.id,
    this.title,
    this.partTitle,
    this.pointData,
    this.coef,
  });

  final int? id;
  final String? title;

  @JsonKey(name: 'part_title')
  final String? partTitle;

  @JsonKey(name: 'point_data')
  final List<PointDatum>? pointData;
  final List<String>? coef;

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);

}

@JsonSerializable()
class PointDatum {
  PointDatum({
    this.ball,
    this.text,
  });

  final int? ball;
  final String? text;

  factory PointDatum.fromJson(Map<String, dynamic> json) => _$PointDatumFromJson(json);

  Map<String, dynamic> toJson() => _$PointDatumToJson(this);

}

@JsonSerializable()
class QuizResult {
  QuizResult({
    this.balls,
    this.comment,
  });

  final int? balls;
  final String? comment;

  factory QuizResult.fromJson(Map<String, dynamic> json) => _$QuizResultFromJson(json);

  Map<String, dynamic> toJson() => _$QuizResultToJson(this);

}


@JsonSerializable(fieldRename: FieldRename.snake)
class QuizResponse{
  QuizResponse({
    this.quiz
});

  List<Quiz>? quiz;

  factory QuizResponse.fromJson(Map<String, dynamic> json) => _$QuizResponseFromJson(json);
  Map<String, dynamic> toJson() => _$QuizResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class Quiz{
  Quiz({
    this.id,
    this.title,
    this.type
});

  int? id;
  String? type;
  String? title;

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
  Map<String, dynamic> toJson() => _$QuizToJson(this);
}