import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/survey/q_type_list/q_type_list_cubit.dart';
import 'package:garnetbook/data/models/survey/q_type_view/q_type_view.dart';
import 'package:garnetbook/data/models/survey/survey_branching_store/survey_branching_store.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/containers/page_contoller_container.dart';
import 'package:garnetbook/widgets/containers/target_container.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class ClientSetTargetScreen extends StatefulWidget {
  const ClientSetTargetScreen({super.key});

  @override
  State<ClientSetTargetScreen> createState() => _ClientSetTargetScreenState();
}

class _ClientSetTargetScreenState extends State<ClientSetTargetScreen> {
  List<QTypeView> list = [];
  SurveyBranchingList? branchingList;

  @override
  void initState() {
    //check();
    context.read<QTypeListCubit>().check();
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
              SingleChildScrollView(
                child: Padding(
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
                              child: PageControllerContainer(
                                choosenIndex: 0,
                                length: 3,
                              ),
                            )
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
                      SizedBox(height: 26.h),
                      BlocBuilder<QTypeListCubit, QTypeListState>(
                        builder: (context, state) {
                          if (state is QTypeListLoadedState) {
                            getList(state.view);

                            if (list.isNotEmpty) {
                              return Column(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            FormForButton(
                                              borderRadius: BorderRadius.circular(8.r),
                                              onPressed: () async {
                                                if (branchingList != null &&
                                                    branchingList?.list != null &&
                                                    branchingList!.list.isNotEmpty) {
                                                  int? nextId;
                                                  for (var element in branchingList!.list) {
                                                    if (element.targetType == list[index].title) {
                                                      nextId = element.currentStep;
                                                      break;
                                                    }
                                                  }
                                                }

                                                if (list[index].firstStep != null && list[index].id != null) {
                                                  context.loaderOverlay.show();

                                                  final service = SurveyServices();

                                                  final response = await service.getSubscribe(list[index].firstStep!);

                                                  if (response.result) {
                                                    context.loaderOverlay.hide();

                                                    if (response.value?.stepType == "branching") {
                                                      if (response.value?.nextSteps != null && response.value!.nextSteps!.isNotEmpty) {
                                                        context.router
                                                            .push(ClientSetTargetWeightRoute(nextStep: response.value!.nextSteps!));
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
                                              },
                                              child: TargetContainer(
                                                text: list[index].title!,
                                              ),
                                            ),
                                            SizedBox(height: 16.h),
                                          ],
                                        );
                                      }),
                                  SizedBox(height: 30.h),
                                ],
                              );
                            } else {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height / 1.8,
                                child: Center(
                                  child: Text(
                                    "Данные скоро появятся",
                                    style: TextStyle(
                                        color: AppColors.darkGreenColor, fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              );
                            }
                          } else if (state is QTypeListErrorState) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 1.8,
                              child: ErrorWithReload(
                                callback: () {
                                  context.read<QTypeListCubit>().check();
                                },
                              ),
                            );
                          } else if (state is QTypeListLoadingState) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 1.8,
                              child: Center(
                                child: ProgressIndicatorWidget(),
                              ),
                            );
                          }
                          return Container();
                        },
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

  check() async {
    final storage = SharedPreferenceData.getInstance();

    SurveyBranchingList? value = await storage.readObject();
    List<SurveyBranchingStoreView> deletedIndex = [];

    if (value != null && value.list.isNotEmpty) {
      for (var element in value.list) {
        DateTime newDate = DateTime.parse(element.lastChanged);

        debugPrint("AMA HERE");
        debugPrint(newDate.difference(DateTime.now()).inDays.toString());

        if (newDate.difference(DateTime.now()).inDays > 1) {
          deletedIndex.add(element);
        }

        if (element.allStep.isNotEmpty && element.finishedStep.isNotEmpty) {
          List<int> newList = [];

          element.finishedStep.forEach((element) {
            newList.add(element.stepId);
          });

          element.allStep.sort((a, b) => a.compareTo(b));
          newList.sort((a, b) => a.compareTo(b));

          debugPrint(element.allStep.toString());
          debugPrint(newList.toString());

          if (listEquals(newList, element.allStep) == true) {
            deletedIndex.add(element);
          }
        }
      }

      if (deletedIndex.isNotEmpty) {
        deletedIndex.forEach((element) {
          value.list.remove(element);
        });
        await storage.saveObject(value, "surveyBranching");
      }
    }
    branchingList = value;
  }

  getList(List<QTypeView>? view) {
    list.clear();

    if (view != null && view.isNotEmpty) {
      view.forEach((element) {
        if (element.id != null && element.title != null) {
          list.add(element);
        }
      });
    }
  }
}
