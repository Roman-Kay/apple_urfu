
import 'package:json_annotation/json_annotation.dart';

part "physical_survey_model.g.dart";


@JsonSerializable(fieldRename: FieldRename.snake)
class FQuizItem{
  FQuizItem({
    this.id,
    this.title,
    this.questions
});

  int? id;
  String? title;
  List<FQuestion>? questions;

  factory FQuizItem.fromJson(Map<String, dynamic> json) => _$FQuizItemFromJson(json);
  Map<String, dynamic> toJson() => _$FQuizItemToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class FQuestion{
  FQuestion({
    this.title,
    this.id,
    this.description,
    this.images
});

  int? id;
  String? title;
  String? description;
  List<String>? images;

  factory FQuestion.fromJson(Map<String, dynamic> json) => _$FQuestionFromJson(json);
  Map<String, dynamic> toJson() => _$FQuestionToJson(this);
}