
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/survey/survey_bloc.dart';
import 'package:garnetbook/data/models/survey/quiz_model.dart';
import 'package:garnetbook/data/models/survey/survey_branching_store/survey_branching_store.dart';
import 'package:garnetbook/ui/client_category/survey/components/survey_element_widget.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';


@RoutePage()
class ClientSurveyDoneScreen extends StatefulWidget {
  const ClientSurveyDoneScreen({super.key, required this.questions, required this.surveyId});
  final List<QuestionItem> questions;
  final int surveyId;

  @override
  State<ClientSurveyDoneScreen> createState() => _ClientSurveyDoneScreenState();
}

class _ClientSurveyDoneScreenState extends State<ClientSurveyDoneScreen> {
  Set<QuestionItem> questions = {};

  @override
  void initState() {
    questions = widget.questions.toSet();
    context.read<SurveyBloc>().add(SurveyGetEvent(widget.surveyId));
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
              BlocBuilder<SurveyBloc, SurveyState>(
                builder: (context, state) {
                  if (state is SurveyLoadedState) {
                    check(state.quizItem?.questions);

                    return RefreshIndicator(
                      color: AppColors.darkGreenColor,
                      onRefresh: () {
                        context.read<SurveyBloc>().add(SurveyGetEvent(widget.surveyId));
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
                                  SizedBox(height: 56.h + 24.h),

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
                                            answers: widget.questions.toSet(),
                                            isEdit: false,
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
                          ],
                        ),
                      ),
                    );
                  }

                  else if(state is SurveyLoadingState){
                    return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: ProgressIndicatorWidget()
                    );
                  }
                  else if(state is SurveyErrorState){
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: ErrorWithReload(
                        callback: () {
                          context.read<SurveyBloc>().add(SurveyGetEvent(widget.surveyId));
                        },
                      ),
                    );
                  }
                  return Container();
                }
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
    }
  }
}

