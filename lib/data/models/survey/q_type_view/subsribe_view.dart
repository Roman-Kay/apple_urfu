import 'package:garnetbook/data/models/survey/quiz_model.dart';
import 'package:garnetbook/data/models/survey/quiz_request.dart';
import 'package:garnetbook/data/models/survey/quiz_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subsribe_view.g.dart';

@JsonSerializable()
class SubscribeStep {
  SubscribeStep({
    this.stepId,
    this.subscribeId,
    this.stepTitle,
    this.stepType,
    this.nextSteps,
    this.quizzes,
    this.buttons,
    this.message
  });

  @JsonKey(name: 'step_id')
  int? stepId;

  @JsonKey(name: 'subscribe_id')
  int? subscribeId;

  @JsonKey(name: 'step_title')
  String? stepTitle;

  @JsonKey(name: 'step_type')
  String? stepType;

  @JsonKey(name: 'next_steps')
  List<NextStep>? nextSteps;
  QuizItem? quizzes;
  List<Button>? buttons;
  String? message;

  factory SubscribeStep.fromJson(Map<String, dynamic> json) => _$SubscribeStepFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeStepToJson(this);

}

@JsonSerializable()
class NextStep {
  NextStep({
    this.id,
    this.type,
    this.title,
    this.message
  });

  final int? id;
  final String? type;
  final String? title;
  final String? message;

  factory NextStep.fromJson(Map<String, dynamic> json) => _$NextStepFromJson(json);

  Map<String, dynamic> toJson() => _$NextStepToJson(this);

}

@JsonSerializable()
class SubscribeResult {
  SubscribeResult({
    this.userId,
    this.gender,
    this.quizzes,
    this.fquizzes,
  });

  @JsonKey(name: 'user_id')
  final int? userId;
  final String? gender;
  final QuizSubscribeResult? quizzes;
  final List<Fquizz>? fquizzes;

  factory SubscribeResult.fromJson(Map<String, dynamic> json) => _$SubscribeResultFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeResultToJson(this);

}

@JsonSerializable()
class Fquizz {
  Fquizz({
    this.faqId,
    this.status,
    this.questionsData,
  });

  @JsonKey(name: 'faq_id')
  final int? faqId;
  final int? status;

  @JsonKey(name: 'questions_data')
  final List<int>? questionsData;

  factory Fquizz.fromJson(Map<String, dynamic> json) => _$FquizzFromJson(json);

  Map<String, dynamic> toJson() => _$FquizzToJson(this);

}

@JsonSerializable()
class QuizSubscribeResult {
  QuizSubscribeResult({
    this.quizId,
    this.status,
    this.result,
    this.resultD,
    this.resultT,
    this.resultS,
    this.questionsData,
    this.resultIds
  });

  @JsonKey(name: 'quiz_id')
  final int? quizId;
  final int? status;
  final int? result;

  @JsonKey(name: 'result_d')
  final int? resultD;

  @JsonKey(name: 'result_t')
  final int? resultT;

  @JsonKey(name: 'result_s')
  final int? resultS;

  @JsonKey(name: 'questions_data')
  final List<QuestionSave>? questionsData;

  @JsonKey(name: 'results_ids')
  final List<int>? resultIds;

  factory QuizSubscribeResult.fromJson(Map<String, dynamic> json) => _$QuizSubscribeResultFromJson(json);

  Map<String, dynamic> toJson() => _$QuizSubscribeResultToJson(this);

}


@JsonSerializable()
class SubscribeResultView {
  SubscribeResultView({
    this.saveStatus,
    this.stepId,
    this.nextSteps,
    this.buttons,
    this.currentResult,
    this.currentResultD,
    this.currentResultS,
    this.currentResultT,
    this.resultIds,
    this.quizzes,
    this.isNextQuiz
  });

  @JsonKey(name: 'save_status')
  final int? saveStatus;

  @JsonKey(name: 'step_id')
  final int? stepId;

  @JsonKey(name: 'next_steps')
  final List<NextStep>? nextSteps;
  final List<Button>? buttons;

  @JsonKey(name: 'current_result')
  final SubscribeResultItem? currentResult;

  @JsonKey(name: 'current_result_d')
  final SubscribeResultItem? currentResultD;

  @JsonKey(name: 'current_result_s')
  final SubscribeResultItem? currentResultS;

  @JsonKey(name: 'current_result_t')
  final SubscribeResultItem? currentResultT;

  @JsonKey(name: "results_ids")
  final List<int>? resultIds;

  @JsonKey(name: "is_next_quiz")
  final int? isNextQuiz;
  final QuizItem? quizzes;

  factory SubscribeResultView.fromJson(Map<String, dynamic> json) => _$SubscribeResultViewFromJson(json);
  Map<String, dynamic> toJson() => _$SubscribeResultViewToJson(this);

}

@JsonSerializable()
class SubscribeResultItem{
  SubscribeResultItem({
    this.text,
    this.comment,
    this.color
});

  String? color;
  String? comment;
  String? text;

  factory SubscribeResultItem.fromJson(Map<String, dynamic> json) => _$SubscribeResultItemFromJson(json);
  Map<String, dynamic> toJson() => _$SubscribeResultItemToJson(this);
}



