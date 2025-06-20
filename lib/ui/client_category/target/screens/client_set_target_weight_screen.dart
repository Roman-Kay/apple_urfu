import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/survey/survey_bloc.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_survey.dart';
import 'package:garnetbook/data/models/survey/q_type_view/subsribe_view.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_request.dart';
import 'package:garnetbook/data/models/survey/survey_branching_store/survey_branching_store.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/survey/questionnarie_service.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';
import 'package:garnetbook/ui/client_category/target/bottom_sheet/client_target_weight_bottom_sheet.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/containers/page_contoller_container.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:garnetbook/widgets/containers/target_container.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class ClientSetTargetWeightScreen extends StatefulWidget {
  const ClientSetTargetWeightScreen({super.key, required this.nextStep});
  final List<NextStep> nextStep;

  @override
  State<ClientSetTargetWeightScreen> createState() => _ClientSetTargetWeightScreenState();
}

class _ClientSetTargetWeightScreenState extends State<ClientSetTargetWeightScreen> {
  SurveyBranchingList? branchingList;
  int setTarget = 0;
  int weight = 0;

  @override
  void initState() {
    getWeight();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundgradientColor),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 7.w, top: 199.h),
                      child: SizedBox(
                        height: 83.h,
                        width: 65.w,
                        child: Image.asset(
                          'assets/images/ananas.webp',
                          fit: BoxFit.fill,
                          color: Colors.white24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 200.h, left: 246.w),
                      child: SizedBox(
                        height: 83.h,
                        width: 83.w,
                        child: Image.asset(
                          'assets/images/ananas2.webp',
                          fit: BoxFit.fill,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 566.h, left: 246.w),
                      child: SizedBox(
                        height: 83.h,
                        width: 65.w,
                        child: Image.asset(
                          'assets/images/ananas1.webp',
                          fit: BoxFit.fill,
                          color: Colors.white24,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Column(
                            children: [
                              SizedBox(height: 20.h),
                              SizedBox(
                                width: double.infinity,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                        onPressed: () => context.router.maybePop(),
                                        icon: Image.asset(
                                          AppImeges.arrow_back_png,
                                          color: AppColors.darkGreenColor,
                                          height: 25.h,
                                          width: 25.w,
                                        ),
                                      ),
                                    ),
                                    PageControllerContainer(
                                      choosenIndex: 1,
                                      length: 3,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.h),
                              ShaderMask(
                                shaderCallback: (Rect rect) {
                                  return AppColors.whitegradientColor.createShader(rect);
                                },
                                child: Text(
                                  'Ваша цель',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGreenColor,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: widget.nextStep.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            setTarget = widget.nextStep[index].id ?? 1;
                                          });

                                          if (branchingList != null && branchingList?.list != null && branchingList!.list.isNotEmpty) {
                                            int? nextId;
                                            for (var element in branchingList!.list) {
                                              if (element.targetType == widget.nextStep[index].title) {
                                                nextId = element.currentStep;
                                                break;
                                              }
                                            }
                                            if (nextId != null && widget.nextStep[index].title != null) {
                                              context.router.push(
                                                  ClientSurveyBranchingRoute(stepId: nextId, targetType: widget.nextStep[index].title!));
                                            } else {
                                              validate(widget.nextStep[index].type, widget.nextStep[index].title);
                                            }
                                          } else {
                                            validate(widget.nextStep[index].type, widget.nextStep[index].title);
                                          }
                                        },
                                        child: TargetContainer(text: widget.nextStep[index].title ?? ""),
                                      ),
                                      SizedBox(height: 16.h),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getWeight() async {
    final storage = SharedPreferenceData.getInstance();
    final testWeight = await storage.getItem(SharedPreferenceData.userWeightKey);
    branchingList = await storage.readObject();

    int newWeight = testWeight != "" ? int.parse(testWeight) : 60;

    setState(() {
      weight = newWeight;
    });
  }

  validate(String? type, String? title) {
    if (title != null) {
      if (weight > 80 && title.contains("вес")) {
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
            color: AppColors.darkGreenColor,
            title: 'Зона риска',
            content: ClientTargetWeightBottomSheet(),
          ),
        ).then((value) {
          if (value == true) {}
        });
      }
    }
  }

  getButtons(int stepId, String? title) async {
    context.loaderOverlay.show();

    final service = SurveyServices();
    final questionnaireService = QuestionnaireService();

    final response = await service.getSubscribe(stepId);

    if (response.result) {
      if (response.value != null && response.value?.buttons != null && response.value!.buttons!.isNotEmpty) {
        List<Recommendation> recommendation = [];

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

        if (recommendation.isNotEmpty) {
          final storage = SharedPreferenceData.getInstance();
          final clientId = await storage.getItem(SharedPreferenceData.clientIdKey);

          //создаем опросник на главный бэкенд
          final createSurvey = await questionnaireService.setSurveyToClient(QuestionnaireCreateRequest(
              questionnaireId: stepId, clientId: clientId != "" ? int.parse(clientId) : null, title: title ?? ""));

          if (createSurvey.result) {
            // после создания опросника - сохраняем результаты на главный бэкенд
            if (createSurvey.result && createSurvey.value != null) {
              final response2 = await questionnaireService.setSurveyResult(QuestionnaireUpdateRequest(
                  passed: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                  questionnaireId: stepId,
                  result: 0,
                  statusCode: "PASSED",
                  statusName: "PASSED",
                  id: createSurvey.value,
                  recommendations: recommendation.isNotEmpty ? recommendation : null,
                  title: title ?? ""));

              if (response2.result) {
                context.loaderOverlay.hide();
                context.router.popUntilRouteWithName(ClientMainMainRoute.name);
                context.router.push(ClientRecommendationMainRoute(isFormSurvey: true));
              } else {
                context.loaderOverlay.hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 3),
                    content: Text(
                      "Произошла ошибка. Попробуйте повторить позже",
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
          } else {
            context.loaderOverlay.hide();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 3),
                content: Text(
                  "Произошла ошибка. Попробуйте повторить позже",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            );
          }
        } else {
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 3),
              content: Text(
                "Произошла ошибка. Попробуйте повторить позже",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          );
        }
      } else {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              "Произошла ошибка. Попробуйте повторить позже",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                fontFamily: 'Inter',
              ),
            ),
          ),
        );
      }
    } else {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            "Произошла ошибка. Попробуйте повторить позже",
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
