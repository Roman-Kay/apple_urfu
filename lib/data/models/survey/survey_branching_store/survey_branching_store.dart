
import 'package:json_annotation/json_annotation.dart';

part "survey_branching_store.g.dart";

@JsonSerializable()
class SurveyBranchingList{
  SurveyBranchingList({
    required this.list
});

  List<SurveyBranchingStoreView> list;

  factory SurveyBranchingList.fromJson(Map<String, dynamic> json) => _$SurveyBranchingListFromJson(json);
  Map<String, dynamic> toJson() => _$SurveyBranchingListToJson(this);

}

@JsonSerializable()
class SurveyBranchingStoreView{
  SurveyBranchingStoreView({
    required this.currentStep,
    required this.targetType,
    required this.finishedStep,
    required this.lastChanged,
    required this.allStep
  });

  int currentStep;
  String targetType;
  List<QuestionObject> finishedStep;
  List<int> allStep;
  String lastChanged;

  factory SurveyBranchingStoreView.fromJson(Map<String, dynamic> json) => _$SurveyBranchingStoreViewFromJson(json);
  Map<String, dynamic> toJson() => _$SurveyBranchingStoreViewToJson(this);
}

@JsonSerializable()
class QuestionObject{
  QuestionObject({
    required this.surveyId,
    required this.passedQuestions,
    required this.stepId
});

  List<QuestionItem>? passedQuestions;
  int surveyId;
  int stepId;

  factory QuestionObject.fromJson(Map<String, dynamic> json) => _$QuestionObjectFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionObjectToJson(this);
}


@JsonSerializable()
class QuestionItem {
  QuestionItem(
      {required this.questionId,
        this.answerBall,
        this.answerBallD,
        this.answerBallS,
        this.answerBallT,
        required this.questionText,
        required this.answerText});

  int questionId;
  int? answerBall;
  String questionText;
  int? answerBallD;
  int? answerBallT;
  int? answerBallS;
  String answerText;

  factory QuestionItem.fromJson(Map<String, dynamic> json) => _$QuestionItemFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionItemToJson(this);
}
