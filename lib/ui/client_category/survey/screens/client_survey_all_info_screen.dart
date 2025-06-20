import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/survey/subscribe_bloc/subscribe_bloc.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_survey.dart';
import 'package:garnetbook/data/models/survey/q_type_view/subsribe_view.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_request.dart';
import 'package:garnetbook/data/models/survey/quiz_model.dart';
import 'package:garnetbook/data/models/survey/quiz_request.dart';
import 'package:garnetbook/data/models/survey/survey_branching_store/survey_branching_store.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/survey/questionnarie_service.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';
import 'package:garnetbook/ui/client_category/survey/components/survey_element_widget.dart';
import 'package:garnetbook/ui/client_category/target/bottom_sheet/client_target_next_steps_choice_bottom_sheet.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class ClientSurveyAllInfoScreen extends StatefulWidget {
  const ClientSurveyAllInfoScreen(
      {required this.stepId,
      this.quizzes,
      this.resultIds,
      this.isFromBranching = false,
      required this.targetType,
      this.branchingCurrentStep,
      super.key});

  final int stepId;
  final QuizItem? quizzes;
  final List<int>? resultIds;
  final bool isFromBranching;
  final String targetType;
  final int? branchingCurrentStep;

  @override
  State<ClientSurveyAllInfoScreen> createState() => _ClientSurveyAllInfoScreenState();
}

class _ClientSurveyAllInfoScreenState extends State<ClientSurveyAllInfoScreen> {
  ScrollController _controller = ScrollController();
  Set<QuestionItem> questions = {};

  int? result;
  bool isNextPhysical = false;
  bool isButtonsNext = false;
  bool isNextBranching = false;
  int? isNextStepId; // next survey step id

  int? surveyId;
  String? surveyTitle;
  List<Question>? questionsList;

  @override
  void initState() {
    if (widget.quizzes == null) {
      context.read<SubscribeBloc>().add(SubscribeGetEvent(widget.stepId));
    } else {
      getList(widget.quizzes);
    }

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
              BlocBuilder<SubscribeBloc, SubscribeState>(builder: (context, state) {
                if (state is SubscribeLoadedState) {
                  if (widget.quizzes == null) getList(state.view?.quizzes);

                  return RefreshIndicator(
                    color: AppColors.darkGreenColor,
                    onRefresh: () {
                      context.read<SubscribeBloc>().add(SubscribeGetEvent(widget.stepId));
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: ListView(
                        controller: _controller,
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
                          if (questionsList != null && questionsList!.isNotEmpty)
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: questionsList?.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var newItem;

                                for (var element in questions) {
                                  if (element.questionId == questionsList![index].id!) {
                                    newItem = element;
                                    break;
                                  }
                                }

                                return SurveyElementWidget(
                                    answers: questions,
                                    isEdit: result == null ? true : false,
                                    question: questionsList![index],
                                    index: index,
                                    id: questionsList![index].id!,
                                    item: newItem);
                              },
                            ),
                          SizedBox(height: 24.h),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.h, top: 15.h),
                            child: Column(
                              children: [
                                if (isButtonsNext)
                                  WidgetButton(
                                    onTap: () async {
                                      context.router.popUntilRouteWithName(ClientMainMainRoute.name);
                                      context.router.push(ClientRecommendationMainRoute(isFormSurvey: true));
                                    },
                                    color: AppColors.darkGreenColor,
                                    text: 'посмотреть рекомендации'.toUpperCase(),
                                  ),
                                if (isNextStepId != null && result != null)
                                  WidgetButton(
                                    onTap: () async {
                                      if (isNextPhysical) {
                                        context.router.popAndPush(ClientPhysicalSurveyRoute(stepId: isNextStepId!));
                                      } else if (isNextBranching) {
                                        context.router
                                            .popAndPush(ClientSurveyBranchingRoute(stepId: isNextStepId!, targetType: widget.targetType));
                                      } else {
                                        context.router.popAndPush(ClientSurveyAllInfoRoute(
                                            stepId: isNextStepId!,
                                            branchingCurrentStep: widget.branchingCurrentStep,
                                            targetType: widget.targetType,
                                            isFromBranching: widget.isFromBranching));
                                      }

                                      setState(() {
                                        questions.clear();
                                        result = null;
                                        isButtonsNext = false;
                                        isNextPhysical = false;
                                        isNextBranching = false;
                                        isNextStepId = null;
                                      });
                                    },
                                    color: AppColors.darkGreenColor,
                                    text: 'продолжить'.toUpperCase(),
                                  ),
                                if (result == null)
                                  WidgetButton(
                                    color: AppColors.darkGreenColor,
                                    onTap: () async {
                                      if (result == null) {
                                        bool isFull = questions.any((element) => element.answerBall == null);

                                        if (isFull) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              duration: Duration(seconds: 3),
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
                                        } else {
                                          FocusScope.of(context).unfocus();
                                          context.loaderOverlay.show();

                                          final service = SurveyServices();
                                          final storage = SharedPreferenceData.getInstance();

                                          final userId = await storage.getUserId();
                                          final clientId = await storage.getItem(SharedPreferenceData.clientIdKey);
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
                                              userAnswers
                                                  .add(QuestionSave(questionId: element.questionId, questionPoint: element.answerBall));

                                              questionnaireList.add(QuestionnaireQuestionsData(
                                                answerName: element.answerText,
                                                answerResult: element.answerBall,
                                                questionnaireExtId: element.questionId,
                                                questionsName: element.questionText,
                                              ));
                                            }
                                          });

                                          if (gender != "" && (surveyId == 32 || surveyId == 33 || surveyId == 34)) {
                                            userGender = gender == "male" ? "m" : "w";
                                          }

                                          // сохраняем результаты в админку - к Диме
                                          if (surveyId != null) {
                                            final response = await service.saveSubscribeResult(
                                              widget.stepId, // айди шага
                                              SubscribeResult(
                                                userId: int.parse(userId),
                                                gender: userGender,
                                                quizzes: QuizSubscribeResult(
                                                    quizId: surveyId!, // айди опросника
                                                    status: 1,
                                                    resultIds: widget.resultIds,
                                                    result: userResult,
                                                    resultD: userResultD,
                                                    resultT: userResultT,
                                                    resultS: userResultS,
                                                    questionsData: userAnswers),
                                                fquizzes: null,
                                              ),
                                            );

                                            if (response.result) {
                                              final questionnaireService = QuestionnaireService();

                                              List<QuestionnaireDass> dassList = [];
                                              List<Recommendation> recommendation = [];

                                              // опросник DASS
                                              if (surveyId == 35 && response.value != null) {
                                                if (response.value?.currentResultD != null) {
                                                  dassList.add(QuestionnaireDass(
                                                    comment: response.value?.currentResultD?.comment,
                                                    color: response.value?.currentResultD?.color,
                                                    result: userResultD,
                                                    text: response.value?.currentResultD?.text,
                                                    type: "d",
                                                  ));
                                                }
                                                if (response.value?.currentResultT != null) {
                                                  dassList.add(QuestionnaireDass(
                                                    comment: response.value?.currentResultT?.comment,
                                                    color: response.value?.currentResultT?.color,
                                                    result: userResultT,
                                                    text: response.value?.currentResultT?.text,
                                                    type: "t",
                                                  ));
                                                }
                                                if (response.value?.currentResultS != null) {
                                                  dassList.add(QuestionnaireDass(
                                                    comment: response.value?.currentResultS?.comment,
                                                    color: response.value?.currentResultS?.color,
                                                    result: userResultS,
                                                    text: response.value?.currentResultS?.text,
                                                    type: "s",
                                                  ));
                                                }
                                              }

                                              //рекомендации
                                              if (response.value != null &&
                                                  response.value?.buttons != null &&
                                                  response.value!.buttons!.isNotEmpty) {
                                                response.value!.buttons!.forEach((buttons) {
                                                  if (buttons.items != null && buttons.items!.isNotEmpty && buttons.title != null) {
                                                    buttons.items!.forEach((type) {
                                                      recommendation.add(Recommendation(
                                                        remoteId: type.resourceId,
                                                        remoteTitle: type.resourceTitle,
                                                        remoteType: type.resourceType,
                                                        remoteName: buttons.title,
                                                      ));
                                                    });
                                                  }
                                                });
                                              }

                                              //создаем опросник на главный бэкенд
                                              final createSurvey = await questionnaireService
                                                  .setSurveyToClient(QuestionnaireCreateRequest(
                                                      questionnaireId: surveyId,
                                                      clientId: clientId != "" ? int.parse(clientId) : null,
                                                      title: surveyTitle ?? ""))
                                                  .then((value) async {
                                                // после создания опросника - сохраняем результаты на главный бэкенд
                                                if (value.result && value.value != null) {
                                                  final response2 = await questionnaireService.setSurveyResult(QuestionnaireUpdateRequest(
                                                      color: response.value?.currentResult?.color,
                                                      comment: response.value?.currentResult?.comment,
                                                      passed: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                                                      questionnaireId: surveyId,
                                                      result: userResult,
                                                      statusCode: "PASSED",
                                                      statusName: "PASSED",
                                                      id: value.value,
                                                      recommendations: recommendation.isNotEmpty ? recommendation : null,
                                                      title: surveyTitle ?? "",
                                                      text: response.value?.currentResult?.text,
                                                      dass: dassList.isNotEmpty ? dassList : null,
                                                      questionsDates: questionnaireList));
                                                }
                                              });

                                              // if(widget.isFromBranching && widget.branchingCurrentStep != null){
                                              //   bool isChanged = false;
                                              //   SurveyBranchingList? value = await storage.readObject();
                                              //
                                              //   if(value != null && value.list.isNotEmpty){
                                              //     for(var element in value.list){
                                              //       if(element.currentStep == widget.branchingCurrentStep){
                                              //         if(!element.finishedStep.contains(widget.stepId)){
                                              //           element.finishedStep.add(QuestionObject(
                                              //               surveyId: surveyId!,
                                              //               passedQuestions: questions.toList(),
                                              //               stepId: widget.stepId
                                              //           ));
                                              //         }
                                              //         element.lastChanged = DateTime.now().toString();
                                              //         isChanged = true;
                                              //         break;
                                              //       }
                                              //     }
                                              //     if(isChanged){
                                              //       await storage.saveObject(value, "surveyBranching");
                                              //     }
                                              //   }
                                              // }

                                              GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.passSurveyClient);
                                              context.loaderOverlay.hide();

                                              setState(() {
                                                result = userResult;
                                              });

                                              if (response.value != null) {
                                                // идет распределение след шага - branching или next steps, quiz? physical quiz
                                                if (response.value?.nextSteps != null && response.value!.nextSteps!.isNotEmpty) {
                                                  // если больше 1 варианта след шага
                                                  if (response.value!.nextSteps!.length > 1) {
                                                    bool isPhysical = false;
                                                    bool isQuiz = false;
                                                    int? id;

                                                    response.value!.nextSteps!.forEach((element) {
                                                      if (element.id != null) {
                                                        if (element.type == "physical") {
                                                          isPhysical = true;
                                                          id = element.id!;
                                                        } else if (element.type == "quizzes" || element.type == "quizzes_summ") {
                                                          isQuiz = true;
                                                          id = element.id!;
                                                        }
                                                      }
                                                    });

                                                    // переход на след опросник
                                                    if (isQuiz && id != null) {
                                                      setState(() {
                                                        isButtonsNext = false;
                                                        isNextBranching = false;
                                                        isNextPhysical = false;
                                                        isNextStepId = id!;
                                                      });
                                                      return;
                                                    }

                                                    // переход на физ опросник
                                                    else if (isPhysical && id != null) {
                                                      setState(() {
                                                        isNextPhysical = true;
                                                        isButtonsNext = false;
                                                        isNextBranching = false;
                                                        isNextStepId = id!;
                                                      });
                                                      return;
                                                    } else {
                                                      showModalBottomSheet(
                                                        useSafeArea: true,
                                                        backgroundColor: AppColors.basicwhiteColor,
                                                        isScrollControlled: true,
                                                        shape: const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.vertical(
                                                            top: Radius.circular(16),
                                                          ),
                                                        ),
                                                        context: context,
                                                        builder: (context) => ModalSheet(
                                                          title: 'Выберите вариант',
                                                          content:
                                                              ClientTargetNextStepsChoiceBottomSheet(nextStep: response.value!.nextSteps),
                                                        ),
                                                      ).then((value) async {
                                                        if (value != null && value.id != null) {
                                                          if (value.type == "buttons") {
                                                            context.router.popUntilRouteWithName(ClientMainMainRoute.name);
                                                            context.router.push(ClientRecommendationMainRoute(isFormSurvey: true));
                                                          } else if (value.type == "quizzes" || value.type == "quizzes_summ") {
                                                            context.router.popAndPush(ClientSurveyAllInfoRoute(
                                                                stepId: value.id,
                                                                branchingCurrentStep: widget.branchingCurrentStep,
                                                                targetType: widget.targetType,
                                                                isFromBranching: widget.isFromBranching));
                                                          } else if (value.type == "physical") {
                                                            context.router.popAndPush(ClientPhysicalSurveyRoute(stepId: value.id));
                                                          } else if (value.type == "analysis") {
                                                            context.router.popUntilRouteWithName(ClientMainMainRoute.name);
                                                            // context.router.push(ClientAnalyzesMainRoute());
                                                          } else if (value.type == "specialist") {
                                                            context.router.popUntilRouteWithName(ClientMainMainRoute.name);
                                                            // context.router.push(ClientSpecialistsMainRoute());
                                                          }
                                                        }
                                                      });
                                                    }
                                                  } else {
                                                    //переход на физ опросник
                                                    if (response.value!.nextSteps!.first.type == "physical" &&
                                                        response.value!.nextSteps!.first.id != null) {
                                                      setState(() {
                                                        isNextPhysical = true;
                                                        isButtonsNext = false;
                                                        isNextBranching = false;
                                                        isNextStepId = response.value!.nextSteps!.first.id!;
                                                      });
                                                      return;
                                                    }

                                                    //переход в рекоммендации
                                                    else if (response.value!.nextSteps!.first.type == "buttons") {
                                                      setState(() {
                                                        isButtonsNext = true;
                                                      });
                                                      return;
                                                    }

                                                    //переход на след опросник
                                                    else if (response.value!.nextSteps!.first.type == "quizzes" ||
                                                        response.value!.nextSteps!.first.type == "quizzes_summ") {
                                                      if (response.value!.nextSteps!.first.id != null) {
                                                        setState(() {
                                                          isNextBranching = false;
                                                          isNextPhysical = false;
                                                          isButtonsNext = false;
                                                          isNextStepId = response.value!.nextSteps!.first.id!;
                                                        });
                                                        return;
                                                      }
                                                    }

                                                    // переход на страницу со списком след опросников
                                                    else if (response.value?.nextSteps!.first.type == "branching" &&
                                                        response.value!.nextSteps!.first.id != null) {
                                                      setState(() {
                                                        isNextBranching = true;
                                                        isNextPhysical = false;
                                                        isButtonsNext = false;
                                                        isNextStepId = response.value!.nextSteps!.first.id!;
                                                      });
                                                      return;
                                                    } else if (response.value!.nextSteps!.first.type == "message") {
                                                      showModalBottomSheet(
                                                        useSafeArea: true,
                                                        backgroundColor: AppColors.basicwhiteColor,
                                                        isScrollControlled: true,
                                                        shape: const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.vertical(
                                                            top: Radius.circular(16),
                                                          ),
                                                        ),
                                                        context: context,
                                                        builder: (context) => ModalSheet(
                                                          title: 'Сообщение',
                                                          content:
                                                              ClientTargetNextStepsChoiceBottomSheet(nextStep: response.value!.nextSteps),
                                                        ),
                                                      ).then((value) async {
                                                        if (value.type == "analysis") {
                                                          context.router.popUntilRouteWithName(ClientMainMainRoute.name);
                                                          // context.router.push(ClientAnalyzesMainRoute());
                                                        } else if (value.type == "specialist") {
                                                          context.router.popUntilRouteWithName(ClientMainMainRoute.name);
                                                          // context.router.push(ClientSpecialistsMainRoute());
                                                        }
                                                      });
                                                    }
                                                  }
                                                }

                                                // автоматический переход на след опросник - когда цепочка из опросников - Часть 1, Часть 2
                                                if (response.value?.isNextQuiz != null && response.value?.quizzes != null) {
                                                  if (response.value?.resultIds != null && response.value!.resultIds!.isNotEmpty) {
                                                    setState(() {
                                                      result = null;
                                                      isButtonsNext = false;
                                                      questions.clear();
                                                    });

                                                    context.router.popAndPush(ClientSurveyAllInfoRoute(
                                                        stepId: widget.stepId,
                                                        quizzes: response.value?.quizzes,
                                                        resultIds: response.value!.resultIds!,
                                                        isFromBranching: widget.isFromBranching,
                                                        branchingCurrentStep: widget.branchingCurrentStep,
                                                        targetType: widget.targetType));
                                                  }
                                                }

                                                if (response.value?.buttons != null && response.value!.buttons!.isNotEmpty) {
                                                  setState(() {
                                                    isButtonsNext = true;
                                                  });
                                                  return;
                                                }
                                              }
                                            } else {
                                              context.loaderOverlay.hide();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  duration: Duration(seconds: 3),
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
                                      } else {
                                        context.router.maybePop();
                                      }
                                    },
                                    text: 'готово'.toUpperCase(),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is SubscribeErrorState) {
                  return ListView(
                    children: [
                      Container(
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: ErrorWithReload(
                          callback: () {
                            context.read<SubscribeBloc>().add(SubscribeGetEvent(widget.stepId));
                          },
                        ),
                      )
                    ],
                  );
                } else if (state is SubscribeLoadingState) {
                  return ListView(
                    children: [
                      Container(
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
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 1.3, child: ProgressIndicatorWidget())
                    ],
                  );
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

  getList(QuizItem? quizItem) {
    if (quizItem != null) {
      if (quizItem.id != null && quizItem.title != null && quizItem.questions != null && quizItem.questions!.isNotEmpty) {
        surveyId = quizItem.id!;
        surveyTitle = quizItem.title!;
        questionsList = quizItem.questions;

        check(quizItem.questions);
      }
    }
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
