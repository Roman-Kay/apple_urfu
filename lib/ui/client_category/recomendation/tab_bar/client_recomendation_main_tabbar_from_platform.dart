import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/recommendation/platform_recommendation/platform_recommendation_cubit.dart';
import 'package:garnetbook/bloc/client/version/version_cubit.dart';
import 'package:garnetbook/data/models/client/recommendation/platform_recommendation.dart';
import 'package:garnetbook/data/repository/recommendation_repository.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/ui/client_category/recomendation/screens/client_recomedation_free_screen.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/description_with_links.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';

class ClientRecommendationMainTabBarFromPlatform extends StatefulWidget {
  const ClientRecommendationMainTabBarFromPlatform({super.key});

  @override
  State<ClientRecommendationMainTabBarFromPlatform> createState() => _ClientRecommendationMainTabBarFromPlatformState();
}

class _ClientRecommendationMainTabBarFromPlatformState extends State<ClientRecommendationMainTabBarFromPlatform>
    with AutomaticKeepAliveClientMixin {
  List<String> recommendationTitle = ["Питание", "Вода", "Активность", "Антистресс", "Сон", "Рецепты", "Коррекция"];

  Map<String, List<Recommendation2>> list = {};
  RecommendationRepository recommendationRepository = RecommendationRepository();

  @override
  bool get wantKeepAlive => true;
//  15.99 30 18.5 25 30

  double imt = 35;
  String? userName;
  double? weight;
  double? height;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  final storage = SharedPreferenceData.getInstance();

  Future<void> _loadInfo() async {
    final weightString = await storage.getItem(SharedPreferenceData.userWeightKey);
    userName = await storage.getItem(SharedPreferenceData.userNameKey);
    final heightString = await storage.getItem(SharedPreferenceData.userHeightKey);

    if (weightString != "") {
      weight = double.tryParse(weightString) ?? 0.0;
    } else {
      weight = 0.0;
    }
    if (heightString != "") {
      height = double.tryParse(heightString) ?? 0.0;
    } else {
      height = 0.0;
    }
    // if (weight != null && height != null) {
    //   imt = weight! / (height! * height!);
    // }

    setState(() {}); // если вес влияет на UI
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print(weight);
    return BlocBuilder<VersionCubit, bool>(
      builder: (context, isFreeVersion) {
        return RefreshIndicator(
          color: AppColors.darkGreenColor,
          onRefresh: () {
            context.read<PlatformRecommendationCubit>().check();
            return Future.delayed(const Duration(seconds: 1));
          },
          child: ListView(padding: EdgeInsets.symmetric(horizontal: 14.w), children: [
            SizedBox(height: 24.h),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.gradientTurquoise,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: userName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGreenColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                      TextSpan(
                        text: imt <= 15.99
                            ? ', по результатам анализа Ваш индекс массы тела (ИМТ) составляет $imt. Такой показатель может указывать на состояние истощения организма. Это не повод для тревоги — скорее, это сигнал организма о том, что ему нужна поддержка и забота.'
                            : imt <= 18.5
                                ? ', по результатам анализа ваш индекс массы тела (ИМТ) составляет $imt'
                                : imt <= 25
                                    ? ', анализ показывает, что Ваш индекс массы тела (ИМТ) равен $imt, что соответствует здоровым нормам. '
                                    : imt <= 30
                                        ? ', анализ показывает, что Ваш индекс массы тела (ИМТ) равен $imt, что указывает на наличие избыточного веса. Но не переживайте — это всего лишь отправная точка для позитивных изменений!'
                                        : ', анализ показывает, что Ваш индекс массы тела (ИМТ) равен $imt, что указывает на наличие ожирения. Но не отчаивайтесь — это повод сделать первый шаг к позитивным изменениям и улучшению здоровья!',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.darkGreenColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.basicwhiteColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(width: 1, color: AppColors.limeColor),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 16.w),
                        SvgPicture.asset(
                          'assets/images/info.svg',
                          height: 20.h,
                          // ignore: deprecated_member_use
                          color: AppColors.vivaMagentaColor,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'ИМТ:',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          imt != null ? imt!.toStringAsFixed(2) : "0",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 32.w),
                Expanded(
                  child: Container(
                    height: 40.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.basicwhiteColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(width: 1, color: AppColors.limeColor),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 16.w),
                        SvgPicture.asset(
                          'assets/images/weight_black.svg',
                          height: 22.h,
                          // ignore: deprecated_member_use
                          color: AppColors.vivaMagentaColor,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Вес:',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          weight.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'кг',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 1,
            ),
            SizedBox(height: 18.h),
            Text(
              'Результат и путь к цели',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                fontFamily: 'Inter',
                color: AppColors.darkGreenColor,
              ),
            ),
            SizedBox(height: 5.h),
            DescriptionWithLinks(
              text: imt <= 15.99
                  ? 'Такой показатель может указывать на состояние истощения организма. Это не повод для тревоги — скорее, это сигнал организма о том, что ему нужна поддержка и забота. \n\nМы уже подготовили для Вас рекомендации, которые помогут мягко и безопасно восстановить силы, улучшить общее состояние и набрать недостающий вес.'
                  : imt <= 18.5
                      ? 'Такой показатель говорит о необходимости набрать недостающий вес. Это не повод для тревоги — скорее, это сигнал организма о том, что ему нужна поддержка и забота.\n\nМы уже подготовили для Вас рекомендации, которые помогут мягко и безопасно восстановить силы, улучшить общее состояние и набрать недостающий вес.\n\nС помощью Apple Вы сможете не только отслеживать прогресс. \n\nМы рядом — шаг за шагом, к лучшему самочувствию.'
                      : imt <= 25
                          ? 'Сохранение оптимального веса требует постоянного внимания к трем ключевым аспектам: питанию, физической активности и режиму дня.'
                          : imt <= 30
                              ? 'Снижение веса — это не спринт, а марафон, который требует внимания к трем ключевым аспектам: питанию , физической активности и режиму дня . Помните: каждое небольшое усилие приближает Вас к желаемому результату.'
                              : 'Ожирение — это состояние, которое требует особого внимания и комплексного подхода. Это не просто вопрос внешнего вида, а важный фактор, влияющий на Ваше здоровье. Лишний вес может увеличивать риск сердечно-сосудистых заболеваний, диабета, проблем с суставами и других состояний. Однако хорошая новость заключается в том, что Вы можете начать действовать уже сегодня, чтобы улучшить свое самочувствие и снизить эти риски.',
            ),
            ListView.builder(
              itemCount: RecommendationRepository.listOfItemRecommendationPlatform.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                final itemRecommendation = RecommendationRepository.listOfItemRecommendationPlatform[index];
                final bool isDisabled = index > 3;

                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 24.h,
                      bottom: index + 1 == RecommendationRepository.listOfItemRecommendationPlatform.length ? 250.h : 0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        height: 64.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientThird,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Stack(
                          children: [
                            Image.asset(
                              itemRecommendation.imageName,
                              height: 64.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            if (isDisabled)
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: AppColors.basicwhiteColor.withOpacity(0.6),
                                ),
                              ),
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.basicblackColor.withOpacity(0.6),
                                    AppColors.basicblackColor.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                            FormForButton(
                              borderRadius: BorderRadius.circular(4.r),
                              onPressed: isDisabled
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ClientRecomedationFreeScreen(
                                            name: itemRecommendation.name,
                                            index: imt <= 15.99
                                                ? 0
                                                : imt <= 18.5
                                                    ? 1
                                                    : imt <= 25
                                                        ? 2
                                                        : imt <= 30
                                                            ? 3
                                                            : 4,
                                          ),
                                        ),
                                      );
                                    },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    itemRecommendation.name,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.basicwhiteColor,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ]),
        );
      },
    );
  }

  getList(Map<String, List<Recommendation2>>? view) {
    list.clear();

    if (view != null && view.isNotEmpty) {
      view.forEach((key, value) {
        if (value.isNotEmpty) {
          if (key == "recipe") {
            list.putIfAbsent("Рецепты", () => []);
          } else if (key == "recommendation") {
            value.forEach((element) {
              if (element.remoteName != null && recommendationTitle.contains(element.remoteName!)) {
                if (element.remoteTitle == "recipe" && element.remoteName != "Рецепты") {
                } else {
                  if (list.containsKey(element.remoteName)) {
                  } else {
                    list.putIfAbsent(element.remoteName!, () => [element]);
                  }
                }
              }
            });
          }
        }
      });
    }
  }
}
