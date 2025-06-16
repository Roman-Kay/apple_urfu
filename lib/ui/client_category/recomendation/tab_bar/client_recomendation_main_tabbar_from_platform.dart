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

  double imt = 0;
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
    if(weight != null && height != null){
      imt = weight! / (height! * height!);
    }

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
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            children: isFreeVersion
                ? [
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
                          ? 'Такой показатель может указывать на состояние истощения организма. Это не повод для тревоги — скорее, это сигнал организма о том, что ему нужна поддержка и забота. \n\nМы уже подготовили для Вас рекомендации, которые помогут мягко и безопасно восстановить силы, улучшить общее состояние и набрать недостающий вес. \n\nЧтобы процесс восстановления был максимально точным и индивидуальным, мы рекомендуем Вам обратиться к специалисту на нашей платформе (ССЫЛКА). Он детально изучит Ваши анализы, определит возможные дефициты и подберёт необходимые добавки.\n\nС помощью Garnetbook Вы сможете не только отслеживать прогресс, но и удобно выстроить график приёма добавок в специальном разделе (ССЫЛКА).\n\nМы рядом — шаг за шагом, к лучшему самочувствию.'
                          : imt <= 18.5
                              ? 'Такой показатель говорит о необходимости набрать недостающий вес. Это не повод для тревоги — скорее, это сигнал организма о том, что ему нужна поддержка и забота.\n\nМы уже подготовили для Вас рекомендации, которые помогут мягко и безопасно восстановить силы, улучшить общее состояние и набрать недостающий вес.\n\nС помощью Garnetbook Вы сможете не только отслеживать прогресс, но и удобно выстроить график приёма необходимых добавок в специальном разделе (ССЫЛКА на видео на добавки). \n\nМы рядом — шаг за шагом, к лучшему самочувствию.'
                              : imt <= 25
                                  ? 'Сохранение оптимального веса требует постоянного внимания к трем ключевым аспектам: питанию, физической активности и режиму дня. Мы разработали для Вас индивидуальную программу, которая поможет:\n•	Поддерживать баланс энергии в организме\n•	Сохранять стабильный обмен веществ \n•	Контролировать качество рациона\n•	Оптимизировать уровень двигательной активности\n\nПриложение Garnetbook станет Вашим надежным помощником, предлагая следующие возможности: \n•	Мониторинг изменений веса и корректировка привычек при необходимости (ссылка на видео "Вес")\n•	Ведение дневника питания для поддержания правильного уровня калорий (ссылка на видео "Дневник питания")\n•	Планирование физических нагрузок с учетом Ваших потребностей (ссылка на видео "Активность")\n•	Контроль качества сна и достаточного потребления воды (ссылка на видео "Сон и Вода")\n\nМы будем сопровождать Вас на каждом этапе пути к здоровому образу жизни, помогая поддерживать достигнутые результаты. Шаг за шагом мы вместе движемся к улучшению самочувствия и качества жизни. '
                                  : imt <= 30
                                      ? 'Снижение веса — это не спринт, а марафон, который требует внимания к трем ключевым аспектам: питанию , физической активности и режиму дня . Мы разработали для Вас индивидуальную программу, которая поможет достичь Ваших целей уверенно и комфортно. Вместе мы сможем:\n• Создать дефицит калорий для эффективного снижения веса\n• Ускорить обмен веществ за счет правильного питания и активности\n• Улучшить качество рациона , исключив вредные продукты\n• Постепенно увеличить двигательную активность , чтобы сделать физические нагрузки частью Вашей жизни \n\nПриложение Garnetbook станет Вашим надежным помощником на пути к новой версии себя. Вот как оно может помочь: \n•	Контроль веса : Отслеживайте динамику изменений и корректируйте свои привычки для достижения результата. (ссылка на видео с прокруткой Веса) \n•	Дневник питания : Учитывайте калории, балансируйте питание и следите за тем, что Вы едите. Это проще, чем кажется! (ссылка на видео Дневник питания) \n•	Планирование активности : Начните с малого и постепенно увеличивайте нагрузки, чтобы организм адаптировался. (ссылка на видео Шаги) \n•	Здоровый сон и гидратация : Качественный сон и достаточное потребление воды — основа успеха в снижении веса. (ссылка на видео Сон и Вода)\n\nМы будем сопровождать Вас на каждом этапе этого увлекательного путешествия. Вы не одни! Шаг за шагом мы вместе движемся к лучшему самочувствию , здоровью и новому качеству жизни . \n\nНачните прямо сейчас — первый шаг самый важный! Помните: каждое небольшое усилие приближает Вас к желаемому результату.'
                                      : 'Ожирение — это состояние, которое требует особого внимания и комплексного подхода. Это не просто вопрос внешнего вида, а важный фактор, влияющий на Ваше здоровье. Лишний вес может увеличивать риск сердечно-сосудистых заболеваний, диабета, проблем с суставами и других состояний. Однако хорошая новость заключается в том, что Вы можете начать действовать уже сегодня, чтобы улучшить свое самочувствие и снизить эти риски. \nМы разработали для Вас персонализированную программу, которая поможет Вам безопасно и эффективно снизить вес, улучшить здоровье и повысить качество жизни. Вместе мы сможем: \n\n•	Создать значительный дефицит калорий , чтобы запустить процесс снижения веса. \n\n•	Ускорить метаболизм за счет правильного питания и регулярной физической активности. \n\n•	Улучшить качество рациона , исключив вредные продукты и добавив полезные. \n\n•	Постепенно увеличить физическую активность , адаптируя нагрузки под Ваши возможности и цели.\nПриложение Garnetbook станет Вашим надежным помощником на пути к здоровью и стройности. Вот как оно может помочь: \n•	Контроль веса: Отслеживайте динамику изменений и корректируйте свои привычки для достижения результата. (ССЫЛКА) \n•	Дневник питания: Учитывайте калории, балансируйте питание и следите за тем, что Вы едите. Это проще, чем кажется! (ССЫЛКА") \n•	Планирование активности: Начните с малых нагрузок, таких как ходьба или легкая гимнастика, и постепенно увеличивайте интенсивность. (ССЫЛКА") \n•	Здоровый сон и гидратация: Качественный сон и достаточное потребление воды — основа успеха в снижении веса. (ССЫЛКА)\nПочему важно начать прямо сейчас? \nОжирение — это не только эстетическая проблема, но и серьезный фактор риска для Вашего здоровья. Чем раньше Вы начнете действовать, тем быстрее сможете: \n•	Снизить риск развития хронических заболеваний. \n•	Уменьшить нагрузку на суставы и позвоночник. \n•	Улучшить работу сердца и сосудов. \n•	Повысить уровень энергии и улучшить настроение.',
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
                  ]
                : [
                    BlocBuilder<PlatformRecommendationCubit, PlatformRecommendationState>(
                      builder: (context, state) {
                        if (state is PlatformRecommendationLoadedState) {
                          getList(state.view);
                          if (list.isNotEmpty) {
                            return ListView.builder(
                              itemCount: list.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final recommendation = list.values.toList()[index];
                                final title = list.keys.toList()[index];
                                final itemRecommendation = recommendationRepository.getButtons(title);
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 24.h,
                                      bottom: index + 1 == list.length ? 250.h : 0,
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
                                        child: FormForButton(
                                          borderRadius: BorderRadius.circular(4.r),
                                          onPressed: () {
                                            if (title == "Рецепты") {
                                              context.router.push(ClientRecipesMainRoute());
                                            } else {
                                              if (recommendation.first.remoteTitle != null &&
                                                  recommendation.first.remoteId != null &&
                                                  recommendation.first.remoteType != null) {
                                                if (recommendation.first.remoteType == "recipe") {
                                                  context.router.push(ClientRecipesMainRoute());
                                                } else {
                                                  context.router.push(
                                                    ClientRecommendationPlatformSingleRoute(
                                                      id: recommendation.first.remoteId!,
                                                      name: title,
                                                      type: recommendation.first.remoteType!,
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          child: Stack(
                                            alignment: Alignment.centerRight,
                                            children: [
                                              Image.asset(
                                                itemRecommendation.imageName,
                                                height: 64.h,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
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
                                              Padding(
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 1.6,
                              child: Center(
                                child: Text(
                                  "Данные отсутствуют",
                                  style: TextStyle(
                                      color: AppColors.darkGreenColor, fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          }
                        } else if (state is PlatformRecommendationLoadingState) {
                          return SizedBox(height: MediaQuery.of(context).size.height / 1.6, child: ProgressIndicatorWidget());
                        } else if (state is PlatformRecommendationErrorState) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height / 1.6,
                            child: ErrorWithReload(
                              callback: () {
                                context.read<PlatformRecommendationCubit>().check();
                              },
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
          ),
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
