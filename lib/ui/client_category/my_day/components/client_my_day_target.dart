import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/target/target_bloc.dart';
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/percents/prossent_bar_small.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ClientMyDayTarget extends StatefulWidget {
  const ClientMyDayTarget({Key? key}) : super(key: key);

  @override
  State<ClientMyDayTarget> createState() => _ClientMyDayTargetState();
}

class _ClientMyDayTargetState extends State<ClientMyDayTarget> {
  List<ClientTargetsView> targetsList = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TargetBloc, TargetState>(builder: (context, targetState) {
      if (targetState is TargetLoadedState) {
        getList(targetState.view);

        return GestureDetector(
          onTap: () {
            context.router.navigate(ClientMainContainerRoute(children: [ClientMainMainRoute(), ClientTargetMainRoute()]));
          },
          child: SizedBox(
            height: 212.h,
            width: double.infinity,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/my_day_target_image.webp',
                  height: 212.h,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Text(
                              'Мой день',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18.sp,
                                fontFamily: 'Inter',
                                color: AppColors.darkGreenColor,
                              ),
                            ),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // FormForButton(
                              //   borderRadius: BorderRadius.circular(4.r),
                              //   onPressed: () async {
                              //     context.loaderOverlay.show();

                              //     final service = SurveyServices();

                              //     final response = await service.getSubscribe(8);

                              //     if (response.result) {
                              //       context.loaderOverlay.hide();

                              //       if (response.value?.stepType == "branching") {
                              //         if (response.value?.nextSteps != null && response.value!.nextSteps!.isNotEmpty) {
                              //           context.router.push(ClientSetTargetWeightRoute(nextStep: response.value!.nextSteps!));
                              //         }
                              //       }
                              //     } else {
                              //       context.loaderOverlay.hide();
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //           duration: Duration(seconds: 3),
                              //           content: Text(
                              //             'Произошла ошибка. Попробуйте повторить позже',
                              //             style: TextStyle(
                              //               fontWeight: FontWeight.w400,
                              //               fontSize: 14.sp,
                              //               fontFamily: 'Inter',
                              //             ),
                              //           ),
                              //         ),
                              //       );
                              //     }
                              //   },
                              //   child: Container(
                              //     height: 36.h,
                              //     width: 140.w,
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(4.r),
                              //       border: Border.all(color: AppColors.darkGreenColor, width: 1),
                              //     ),
                              //     child: Row(
                              //       mainAxisSize: MainAxisSize.min,
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         SvgPicture.asset(
                              //           'assets/images/add.svg',
                              //           height: 10.h,
                              //           color: AppColors.darkGreenColor,
                              //         ),
                              //         SizedBox(width: 4.w),
                              //         Text(
                              //           'Добавить цель'.toUpperCase(),
                              //           style: TextStyle(
                              //             fontFamily: 'Inter',
                              //             color: AppColors.darkGreenColor,
                              //             fontSize: 12.sp,
                              //             fontWeight: FontWeight.w700,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              SizedBox(height: 10.h),
                              if (targetsList.isNotEmpty)
                                Column(
                                  children: [
                                    Text(
                                      targetsList[0].target?.name ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.sp,
                                        fontFamily: 'Inter',
                                        color: AppColors.vivaMagentaColor,
                                      ),
                                    ),
                                    Text(
                                      'Ваша текущая цель',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.sp,
                                        fontFamily: 'Inter',
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (targetsList.isNotEmpty)
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(width: 4.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/flag.svg',
                                      height: 24.h,
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Text(
                                          targetsList.first.pointA != null ? targetsList.first.pointA.toString() : "",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.basicwhiteColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          targetsList.first.pointA != null ? "кг" : "",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.basicwhiteColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: 16.w),
                                Column(
                                  children: [
                                    Text(
                                      (targetsList.first.lessPrc ?? 0).toString() + '%',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: AppColors.basicwhiteColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/images/woman_walk.webp',
                                      height: 32.h,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ProssentBarSmall(
                              width: 160.w,
                              backColor: AppColors.darkGreenColor.withOpacity(0.3),
                              prossentWidth: 160.w / 100 * (targetsList.first.lessPrc ?? 0),
                              prossentGradeint: LinearGradient(
                                colors: [
                                  Color(0xFFF0BEC3),
                                  Color(0xFFBE3455),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Выполнено:',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.basicwhiteColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 8.h),
                          ],
                        ),
                    ],
                  ),
                ),
                if (targetsList.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/flag.svg',
                            height: 24.h,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                targetsList.first.pointB != null ? targetsList.first.pointB.toString() : "",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: AppColors.basicwhiteColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                targetsList.first.pointA != null ? "кг" : "",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: AppColors.basicwhiteColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }
      return Container();
    });
  }

  getList(List<ClientTargetsView>? view) {
    targetsList.clear();

    if (view != null && view.isNotEmpty) {
      List<ClientTargetsView> testList = [];
      view.forEach((element) {
        if (element.target?.name != "Удерживать вес") {
          if (element.completed != true) {
            testList.add(element);
          }
        }
      });

      if (testList.isNotEmpty) {
        if (testList.length > 2) {
          testList.forEach((element) {
            if (targetsList.length != 2) {
              targetsList.add(element);
            }
          });
        } else {
          targetsList = testList;
        }
      }
    }
  }

  int getLostDays(int? totalDays, int? lessDays) {
    if (totalDays != null && lessDays != null) {
      return totalDays - lessDays;
    } else if (totalDays != null) {
      return totalDays;
    }
    return 0;
  }
}
