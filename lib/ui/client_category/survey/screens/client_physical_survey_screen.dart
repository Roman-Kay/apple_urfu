import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/physical_survey/physical_survey_bloc.dart';
import 'package:garnetbook/data/models/survey/q_type_view/subsribe_view.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';
import 'package:garnetbook/ui/client_category/survey/bottom_sheet/client_physical_survey_sheet.dart';
import 'package:garnetbook/ui/client_category/target/bottom_sheet/client_target_next_steps_choice_bottom_sheet.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/extension/string_externsions.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/containers/page_contoller_container.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class ClientPhysicalSurveyScreen extends StatefulWidget {
  const ClientPhysicalSurveyScreen({super.key, required this.stepId});
  final int stepId;

  @override
  State<ClientPhysicalSurveyScreen> createState() => _ClientPhysicalSurveyScreenState();
}

class _ClientPhysicalSurveyScreenState extends State<ClientPhysicalSurveyScreen> {
  int chooseIndex = 0;
  List<int> answerList = [];
  bool isFinish = false;
  static List<String> physicalSurveyList = [
    "Волосы",
    "Кожа",
    "Слизистые. Язык. Зубы",
    "Ногти",
    "Глаза",
    "Скелетно-мышечная система",
    "Случайные находки"
  ];

  @override
  void initState() {
    context.read<PhysicalSurveyBloc>().add(PhysicalSurveyGetEvent(chooseIndex + 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundgradientColor),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 90.h),
                child: Image.asset(
                  'assets/images/Ellipse_hair.webp',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h, left: 210.w),
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
                padding: EdgeInsets.only(top: 80.h, left: 280.w),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  children: [
                    SizedBox(height: 60.h),
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 1,
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
                          PageControllerContainer(
                            choosenIndex: chooseIndex,
                            length: physicalSurveyList.length,
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
                        physicalSurveyList[chooseIndex],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGreenColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    BlocBuilder<PhysicalSurveyBloc, PhysicalSurveyState>(builder: (context, state) {
                      if (state is PhysicalSurveyLoadedState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: state.view?.questions?.length,
                              itemBuilder: (context, index) {
                                final item = state.view!.questions![index];

                                return Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: AppColors.basicwhiteColor,
                                  ),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.zero,
                                      side: BorderSide(
                                        width: 0,
                                        color: Color(0x000000),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (item.id != null) {
                                        if (!answerList.contains(item.id)) {
                                          setState(() {
                                            answerList.add(item.id!);
                                          });
                                        } else {
                                          setState(() {
                                            answerList.remove(item.id!);
                                          });
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 16.w, left: 5.w),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 5.h),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Row(
                                                  children: [
                                                    item.images != null && item.description != null
                                                        ? IconButton(
                                                            onPressed: () {
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
                                                                  title: item.title!.capitalize(),
                                                                  content: PhysicalSurveyBottomSheet(
                                                                      text: item.description!, image: item.images!),
                                                                ),
                                                              );
                                                            },
                                                            icon: SvgPicture.asset(
                                                              'assets/images/info.svg',
                                                              color: AppColors.vivaMagentaColor,
                                                            ),
                                                          )
                                                        : SizedBox(width: 13.w),
                                                    Flexible(
                                                      child: Text(
                                                        item.title ?? "",
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: 'Inter',
                                                          color: AppColors.darkGreenColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 5.w),
                                              answerList.contains(item.id)
                                                  ? CircleAvatar(
                                                      radius: 12.r,
                                                      backgroundColor: AppColors.darkGreenColor,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.check,
                                                          color: AppColors.basicwhiteColor,
                                                          size: 15.r,
                                                        ),
                                                      ),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 12.r,
                                                      backgroundColor: AppColors.limeColor,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 30.h),
                            Row(
                              children: [
                                Expanded(
                                  child: WidgetButton(
                                    onTap: () => context.router.maybePop(),
                                    color: AppColors.basicwhiteColor,
                                    child: Text(
                                      "отмена".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Inter',
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                Expanded(
                                  child: WidgetButton(
                                    onTap: () async {
                                      if (isFinish) {
                                        context.router.maybePop();
                                      } else {
                                        FocusScope.of(context).unfocus();
                                        context.loaderOverlay.show();

                                        final service = SurveyServices();
                                        final storage = SharedPreferenceData.getInstance();
                                        final userId = await storage.getUserId();

                                        final response = await service.saveSubscribeResult(
                                          widget.stepId, // айди шага
                                          SubscribeResult(
                                            userId: int.parse(userId),
                                            fquizzes: [
                                              Fquizz(
                                                  status: answerList.isNotEmpty ? 1 : 0, faqId: chooseIndex + 1, questionsData: answerList)
                                            ],
                                          ),
                                        );

                                        if (response.result) {
                                          context.loaderOverlay.hide();

                                          if (chooseIndex + 1 < physicalSurveyList.length) {
                                            setState(() {
                                              chooseIndex = chooseIndex + 1;
                                              answerList.clear();
                                            });
                                            context.read<PhysicalSurveyBloc>().add(PhysicalSurveyGetEvent(chooseIndex + 1));
                                          } else {
                                            setState(() {
                                              isFinish = true;
                                            });

                                            if (response.value?.nextSteps != null && response.value!.nextSteps!.isNotEmpty) {
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
                                                  content: ClientTargetNextStepsChoiceBottomSheet(nextStep: response.value!.nextSteps),
                                                ),
                                              ).then((value) async {
                                                if (value != null && value.id != null) {
                                                  if (value.type == "buttons") {
                                                    context.router.popUntilRouteWithName(ClientMainMainRoute.name);
                                                    context.router.push(ClientRecommendationMainRoute(isFormSurvey: true));
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
                                          }
                                        } else {
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
                                    },
                                    color: AppColors.darkGreenColor,
                                    boxShadow: true,
                                    child: Text(
                                      !isFinish ? 'ДАЛЕЕ' : "ГОТОВО",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Inter',
                                        color: AppColors.basicwhiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),
                          ],
                        );
                      } else if (state is PhysicalSurveyErrorState) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.6,
                          child: ErrorWithReload(
                            callback: () {
                              context.read<PhysicalSurveyBloc>().add(PhysicalSurveyGetEvent(chooseIndex + 1));
                            },
                          ),
                        );
                      } else if (state is PhysicalSurveyLoadingState) {
                        return SizedBox(height: MediaQuery.of(context).size.height / 1.6, child: ProgressIndicatorWidget());
                      }
                      return Container();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
