import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/survey/survey_bloc.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_survey.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_request.dart';
import 'package:garnetbook/data/models/survey/quiz_model.dart';
import 'package:garnetbook/data/models/survey/quiz_request.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/data/models/survey/survey_branching_store/survey_branching_store.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/notification/push_service.dart';
import 'package:garnetbook/domain/services/survey/questionnarie_service.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';
import 'package:garnetbook/ui/client_category/survey/components/survey_element_widget.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/buttons.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';


@RoutePage()
class ClientSurveyWatchScreen extends StatefulWidget {
  const ClientSurveyWatchScreen({
    required this.surveyId,
    required this.id,
    this.expertId,
    Key? key}) : super(key: key);

  final int id;
  final int? expertId;
  final int surveyId;

  @override
  State<ClientSurveyWatchScreen> createState() => _ClientSurveyWatchScreenState();
}

class _ClientSurveyWatchScreenState extends State<ClientSurveyWatchScreen> {
  Set<QuestionItem> questions = {};
  int? result;
  bool isFinish = false;


  @override
  void initState() {
    context.read<SurveyBloc>().add(SurveyGetEvent(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.gradientTurquoiseReverse),
        child: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<SurveyBloc, SurveyState>(builder: (context, state) {
                if (state is SurveyLoadedState) {
                  check(state.quizItem?.questions);

                  return RefreshIndicator(
                    color: AppColors.darkGreenColor,
                    onRefresh: () {
                      context.read<SurveyBloc>().add(SurveyGetEvent(widget.id));
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 56.h + 20.h),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradientThird,
                                    borderRadius: BorderRadius.circular(4.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.basicblackColor.withOpacity(0.1),
                                        blurRadius: 10.r,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      'Пожалуйста ответьте максимально точно на следующие вопросы:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        height: 1.1,
                                        fontFamily: 'Inter',
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                if (state.quizItem?.questions != null && state.quizItem!.questions!.isNotEmpty)
                                  ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: state.quizItem!.questions!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var newItem;

                                      for (var element in questions) {
                                        if (element.questionId == state.quizItem!.questions![index].id!) {
                                          newItem = element;
                                          break;
                                        }
                                      }

                                      return SurveyElementWidget(
                                          answers: questions,
                                          question: state.quizItem!.questions![index],
                                          index: index,
                                          id: state.quizItem!.questions![index].id!,
                                          item: newItem);
                                    },
                                  ),
                                SizedBox(height: 32.h),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.h, left: 14.w, right: 14.w),
                            child: WidgetButton(
                              color: AppColors.darkGreenColor,
                              onTap: () async {
                                if (isFinish) {
                                  context.router.maybePop(true);
                                }
                                else {
                                  bool isFull = questions.any((element) => element.answerBall == null);

                                  if (isFull) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                          'Вы ответили не на все вопросы',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  else {
                                    FocusScope.of(context).unfocus();
                                    context.loaderOverlay.show();

                                    final service = SurveyServices();
                                    final storage = SharedPreferenceData.getInstance();

                                    final userId = await storage.getUserId();
                                    final gender = await storage.getItem(SharedPreferenceData.userGenderKey);

                                    List<QuestionSave> userAnswers = [];
                                    List<QuestionnaireQuestionsData> questionnaireList = [];
                                    String? userGender;

                                    int userResult = 0;
                                    int userResultS = 0;
                                    int userResultD = 0;
                                    int userResultT = 0;

                                    for (var element in questions) {
                                      if (element.answerBall != null) {
                                        setState(() {
                                          userResult = userResult + element.answerBall!;
                                        });
                                      }

                                      if (element.answerBallS != null) {
                                        setState(() {
                                          userResultS = userResultS + element.answerBallS!;
                                        });
                                      }

                                      if (element.answerBallD != null) {
                                        setState(() {
                                          userResultD = userResultD + element.answerBallD!;
                                        });
                                      }

                                      if (element.answerBallT != null) {
                                        setState(() {
                                          userResultT = userResultT + element.answerBallT!;
                                        });
                                      }
                                    }

                                    questions.forEach((element) {
                                      if (element.answerBall != null) {
                                        userAnswers.add(QuestionSave(questionId: element.questionId, questionPoint: element.answerBall));

                                        questionnaireList.add(QuestionnaireQuestionsData(
                                          answerName: element.answerText,
                                          answerResult: element.answerBall,
                                          questionnaireExtId: widget.id,
                                          questionsName: element.questionText,
                                        ));
                                      }
                                    });

                                    if (gender != "" && (widget.id == 32 || widget.id == 33 || widget.id == 34)) {
                                      userGender = gender == "male" ? "m" : "w";
                                    }

                                    final response = await service.setSurveyResults(
                                        widget.id,
                                        QuizRequest(
                                            result: userResult,
                                            resultD: userResultD,
                                            resultS: userResultS,
                                            resultT: userResultT,
                                            userId: int.parse(userId),
                                            status: 1,
                                            questionsData: userAnswers,
                                            gender: userGender));

                                    if (response.result) {
                                      final questionnaireService = QuestionnaireService();
                                      List<QuestionnaireDass> dassList = [];

                                      List<Recommendation> recommendation = [];

                                      if (widget.id == 35 && response.value != null && response.value!.isNotEmpty) {
                                        response.value!.forEach((element) {
                                          if (element.type == "d") {
                                            dassList.add(QuestionnaireDass(
                                              comment: element.comment,
                                              color: element.color,
                                              result: userResultD,
                                              text: element.text,
                                              type: "d",
                                            ));
                                          }

                                          if (element.type == "t") {
                                            dassList.add(QuestionnaireDass(
                                              comment: element.comment,
                                              color: element.color,
                                              result: userResultT,
                                              text: element.text,
                                              type: "t",
                                            ));
                                          }

                                          if (element.type == "s") {
                                            dassList.add(QuestionnaireDass(
                                              comment: element.comment,
                                              color: element.color,
                                              result: userResultS,
                                              text: element.text,
                                              type: "s",
                                            ));
                                          }
                                        });
                                      }

                                      // рекомендации
                                      if(response.value != null && response.value!.isNotEmpty){
                                        if(response.value!.first.buttons != null && response.value!.first.buttons!.isNotEmpty){

                                          response.value!.forEach((buttons){
                                            if(buttons.buttons != null && buttons.buttons!.isNotEmpty){
                                              buttons.buttons!.forEach((rec){
                                                if(rec.title != null && rec.items != null && rec.items!.isNotEmpty){
                                                  rec.items!.forEach((type){
                                                    recommendation.add(Recommendation(
                                                      remoteId: type.resourceId,
                                                      remoteTitle: type.resourceTitle,
                                                      remoteType: type.resourceType,
                                                      remoteName: rec.title,
                                                    ));
                                                  });
                                                }
                                              });
                                            }
                                          });
                                        }
                                      }

                                      final response2 = await questionnaireService.setSurveyResult(QuestionnaireUpdateRequest(
                                          color: response.value?.first.color,
                                          comment: response.value?.first.comment,
                                          passed: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                                          questionnaireId: widget.id,
                                          result: userResult,
                                          statusCode: "PASSED",
                                          statusName: "PASSED",
                                          id: widget.surveyId,
                                          expertId: widget.expertId,
                                          recommendations: recommendation.isNotEmpty ? recommendation : null,
                                          title: state.quizItem?.title ?? "",
                                          text: response.value?.first.text,
                                          dass: dassList.isNotEmpty ? dassList : null,
                                          questionsDates: questionnaireList));



                                      GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.passExpertSurveyClient);

                                      final userName = await storage.getItem(SharedPreferenceData.userNameKey);

                                      if(userName != ""){
                                        await PushService().sendPush(
                                            "Клиент $userName прошел назначеннный опросник",
                                            widget.expertId.toString()
                                        );
                                      }

                                      context.loaderOverlay.hide();

                                      setState(() {
                                        isFinish = true;
                                        result = userResult;
                                      });
                                      context.router.maybePop(true);

                                    }
                                    else {
                                      context.loaderOverlay.hide();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                            'Произошла ошибка. Попробуйте повторить позже',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              text: isFinish ? "назад".toUpperCase() : 'готово'.toUpperCase(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                else if (state is SurveyErrorState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: ErrorWithReload(
                      callback: () {
                        context.read<SurveyBloc>().add(SurveyGetEvent(widget.id));
                      },
                    ),
                  );
                }
                else if (state is SurveyLoadingState) {
                  return SizedBox(height: MediaQuery.of(context).size.height / 1.2, child: ProgressIndicatorWidget());
                }
                return Container();
              }),
              Container(
                width: double.infinity,
                height: 56.h,
                color: AppColors.basicwhiteColor,
                child: Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientTurquoise,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.basicblackColor.withOpacity(0.1),
                        blurRadius: 10.r,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            context.router.maybePop();
                          },
                          icon: Image.asset(
                            AppImeges.arrow_back_png,
                            color: AppColors.darkGreenColor,
                            height: 25.h,
                            width: 25.w,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Просмотр опросника",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  check(List<Question>? list) {
    if (list != null && list.isNotEmpty) {
      list.forEach((element) {
        if (element.id != null && element.title != null && element.pointData != null && element.pointData!.isNotEmpty) {
          bool isChecked = questions.any((item) => element.id == item.questionId);
          if (!isChecked) {
            questions.add(QuestionItem(
              questionId: element.id!,
              answerBall: null,
              questionText: element.title!,
              answerText: "",
            ));
          }
        }
      });

      List<int> needToDeleteSurvey = [];

      for (var element in questions) {
        bool isExist = list.any((value) => value.id == element.questionId);

        if (!isExist) {
          needToDeleteSurvey.add(element.questionId);
        }
      }

      if (needToDeleteSurvey.isNotEmpty) {
        needToDeleteSurvey.forEach((element) {
          questions.removeWhere((value) => value.questionId == element);
        });
      }
    }
  }

}
