import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/survey/survey_branching/survey_branching_bloc.dart';
import 'package:garnetbook/data/models/survey/q_type_view/subsribe_view.dart';
import 'package:garnetbook/data/models/survey/survey_branching_store/survey_branching_store.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';


@RoutePage()
class ClientSurveyBranchingScreen extends StatefulWidget {
  const ClientSurveyBranchingScreen({super.key, required this.stepId, required this.targetType});
  final int stepId;
  final String targetType;

  @override
  State<ClientSurveyBranchingScreen> createState() => _ClientSurveyBranchingScreenState();
}

class _ClientSurveyBranchingScreenState extends State<ClientSurveyBranchingScreen> {
  final storage = SharedPreferenceData.getInstance();
  NextStep? setTarget;
  List<QuestionObject> finishedSurveyId = [];
  bool isInit = false;

  @override
  void initState() {
    check();
    context.read<SurveyBranchingBloc>().add(SurveyBranchingGeEvent(widget.stepId));
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
              RefreshIndicator(
                color: AppColors.darkGreenColor,
                onRefresh: () {
                  context.read<SurveyBranchingBloc>().add(SurveyBranchingGeEvent(widget.stepId));
                  return Future.delayed(const Duration(seconds: 1));
                },
                child: ListView(
                  children: [
                    BlocBuilder<SurveyBranchingBloc, SurveyBranchingState>(
                        builder: (context, state) {
                          if(state is SurveyBranchingLoadedState){
                            setNextStepsToLocal(state.nextStep);


                            return Column(
                              children: [
                                SizedBox(height: (56 + 20).h),

                                if(state.message != null && state.message != "")
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 14.w),
                                        padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: AppColors.limeColor,
                                          ),
                                          borderRadius: BorderRadius.circular(8.r),
                                          gradient: AppColors.gradientTurquoise,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(width: 16.w),
                                            SvgPicture.asset(
                                              'assets/images/info.svg',
                                              height: 24.h,
                                              // ignore: deprecated_member_use
                                              color: AppColors.vivaMagentaColor,
                                            ),
                                            SizedBox(width: 12.w),
                                            Flexible(
                                              child: Text(
                                                state.message ?? "",
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.darkGreenColor
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        decoration: BoxDecoration(
                                          gradient: AppColors.gradientTurquoise,
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                    ],
                                  ),

                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: state.nextStep.length,
                                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                                  itemBuilder: (context, index){
                                    final item = state.nextStep[index];
                                    bool isFinish = finishedSurveyId.any((data) => data.stepId == item.id);

                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if(isFinish){
                                              QuestionObject object = finishedSurveyId.firstWhere((data) => data.stepId == item.id);

                                              context.router.push(ClientSurveyDoneRoute(
                                                surveyId: object.surveyId,
                                                questions: object.passedQuestions ?? []
                                              ));
                                            }
                                            else{
                                              validate(item.type, item.title, item.id ?? 1);
                                            }
                                          },
                                          child: Container(
                                            height: 64.h,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.r),
                                              color: isFinish
                                                  ? AppColors.grey50Color.withOpacity(0.1)
                                                  : AppColors.basicwhiteColor,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      item.title ?? "",
                                                      style: TextStyle(
                                                        fontSize: 18.sp,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Inter',
                                                        color: AppColors.darkGreenColor,
                                                      ),
                                                    ),
                                                  ),
                                                  isFinish
                                                    ? Icon(
                                                    Icons.done,
                                                    color: AppColors.greenColor,
                                                    size: 24.r,
                                                  )
                                                    : SvgPicture.asset(
                                                    'assets/images/arrow_black.svg',
                                                    width: 24.w,
                                                    height: 24.h,
                                                    color: AppColors.vivaMagentaColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 18.h),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                          else if(state is SurveyBranchingErrorState){
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 1.3,
                              child: ErrorWithReload(
                                callback: () {
                                  context.read<SurveyBranchingBloc>().add(SurveyBranchingGeEvent(widget.stepId));
                                },
                              ),
                            );
                          }
                          else if(state is SurveyBranchingLoadingState){
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 1.3,
                              child: Center(
                                child: ProgressIndicatorWidget(),
                              ),
                            );
                          }
                          return Container();
                      }
                    ),
                  ],
                ),
              ),
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

  check() async{
    SurveyBranchingList? value = await storage.readObject();

    if(value != null && value.list.isNotEmpty){
      value.list.forEach((element){
        if(element.currentStep == widget.stepId){
          if(element.finishedStep.isNotEmpty){
            finishedSurveyId = element.finishedStep;
          }
        }
      });
    }
  }

  setNextStepsToLocal(List<NextStep>? nextStep) async{
    if(nextStep != null && nextStep.isNotEmpty ){
      List<int> steps = [];

      bool isExist = nextStep.any((data) => data.type != "quizzes");

      debugPrint(isExist.toString());

      nextStep.forEach((element){
        if(element.id != null && !steps.contains(element.id!) && !isExist){
          steps.add(element.id!);
        }
      });

      SurveyBranchingList? value = await storage.readObject();

      debugPrint("STEPS  $steps");

      if(value != null && value.list.isNotEmpty){
        bool isExist = value.list.any((data) => data.currentStep == widget.stepId);

        if(!isExist && steps.isNotEmpty){
          value.list.add(SurveyBranchingStoreView(
              currentStep: widget.stepId,
              targetType: widget.targetType,
              lastChanged: DateTime.now().toString(),
              finishedStep: [],
              allStep: steps
          ));

          await storage.saveObject(value, "surveyBranching");
        }
      }
      else if(steps.isNotEmpty){
        await storage.saveObject(SurveyBranchingList(
            list: [SurveyBranchingStoreView(
                currentStep: widget.stepId,
                targetType: widget.targetType,
                lastChanged: DateTime.now().toString(),
                finishedStep: [],
                allStep: steps
            )]
        ), "surveyBranching");
      }

      isInit = true;
    }
  }

  validate(String? type, String? title, int nextStepId){
    if(type == "branching"){
      debugPrint("BRANCHIINNNNNNNNNNNNNG");

      context.router.popAndPush(ClientSurveyBranchingRoute(
        targetType: widget.targetType,
        stepId: nextStepId
      ));
    }
    else if(type == "quizzes" || (type != null && type.contains("quizzes"))){
      context.router.push(ClientSurveyAllInfoRoute(
        stepId: nextStepId,
        isFromBranching: true,
        targetType: widget.targetType,
        branchingCurrentStep: widget.stepId
      ));
    }
  }

}
