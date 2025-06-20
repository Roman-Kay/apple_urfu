import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/version/version_cubit.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/containers/target_container.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class ClientMainMainScreen extends StatelessWidget {
  ClientMainMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.gradientTurquoiseReverse,
      ),
      child: Stack(
        children: [
          Image.asset('assets/images/Group 25.webp'),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/images/Group 22.webp',
            ),
          ),
          SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // mainCardContainer(
                //   notificationLength: null,
                //   index: 0,
                //   text: 'Моя цель',
                //   needBlurForFreeVersion: true,
                //   image: 'assets/images/main/target.png',
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
                // ),
                // mainCardContainer(
                //   notificationLength: null,
                //   index: 1,
                //   text: 'Анализы и исследования',
                //   image: 'assets/images/main/analyses.png',
                //   onPressed: () {
                //     context.router.push(ClientAnalyzesMainRoute());
                //   },
                // ),
                // mainCardContainer(
                //   notificationLength: null,
                //   index: 2,
                //   needBlurForFreeVersion: true,
                //   text: 'Добавки',
                //   image: 'assets/images/main/adds.png',
                //   onPressed: () {
                //     context.router.push(ClientAddsMainRoute());
                //   },
                // ),
                // mainCardContainer(
                //   notificationLength: null,
                //   index: 3,
                //   needBlurForFreeVersion: true,
                //   text: 'Опросники',
                //   image: 'assets/images/main/survey.png',
                //   onPressed: () => context.router.push(ClientSurveyMainRoute()),

                mainCardContainer(
                  notificationLength: null,
                  index: 5,
                  text: 'Рекомендации',
                  image: 'assets/images/main/recomendation.png',
                  onPressed: () {
                    context.router.push(ClientRecommendationMainRoute(isFormSurvey: false));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mainCardContainer({
    required int? notificationLength,
    required String text,
    required String image,
    required Function() onPressed,
    required int index,
    bool? needBlurForFreeVersion,
  }) {
    return BlocBuilder<VersionCubit, bool>(
      builder: (context, isFreeVersion) {
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 20.h : 16.h, left: 14.w, right: 14.w, bottom: index == 7 ? 100.h : 0),
          child: SizedBox(
            height: 64.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: needBlurForFreeVersion == true && isFreeVersion == true ? 7 : 0,
                      sigmaY: needBlurForFreeVersion == true && isFreeVersion == true ? 7 : 0,
                    ),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 64.h,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        end: Alignment.centerLeft,
                        begin: Alignment.centerRight,
                        colors: [
                          AppColors.basicblackColor.withOpacity(0),
                          AppColors.basicblackColor.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  if (notificationLength != null && notificationLength != 0)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 6.h,
                        left: 16.w,
                      ),
                      child: CircleAvatar(
                        radius: 10.h,
                        backgroundColor: AppColors.redColor,
                        child: Center(
                          child: Text(
                            notificationLength.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              color: AppColors.basicwhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  FormForButton(
                    borderRadius: BorderRadius.circular(8.r),
                    onPressed: needBlurForFreeVersion == true && isFreeVersion == true ? null : onPressed,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 20.sp,
                            height: 1.2,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            color: needBlurForFreeVersion == true && isFreeVersion == true
                                // ignore: deprecated_member_use
                                ? AppColors.basicwhiteColor.withOpacity(0.5)
                                : AppColors.basicwhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
