
import 'package:json_annotation/json_annotation.dart';

part "physical_survey_request.g.dart";


@JsonSerializable(fieldRename: FieldRename.snake)
class FQuizRequest{
  FQuizRequest({
    required this.status,
    required this.userId,
    required this.questionData,
    this.ballsId
});


  @JsonKey(
    name: 'user_id',
  )
  int userId;
  int status;

  @JsonKey(
    name: 'questions_data',
  )
  List<int> questionData;

  @JsonKey(
    name: 'balls_id',
  )
  int? ballsId;


  factory FQuizRequest.fromJson(Map<String, dynamic> json) => _$FQuizRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FQuizRequestToJson(this);

}