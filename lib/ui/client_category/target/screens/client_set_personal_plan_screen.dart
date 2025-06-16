import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/ui/client_category/target/components/client_personal_plan_list_view.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/containers/page_contoller_container.dart';

class ListOfRecItem {
  final double hiegth;
  final List<RecItem> listOfRecItems;

  ListOfRecItem({
    required this.hiegth,
    required this.listOfRecItems,
  });
}

class RecItem {
  final String? name;
  final String? subName;
  final String text;

  RecItem({
    this.name,
    this.subName,
    required this.text,
  });
}

@RoutePage()
class ClientSetPersonalPlanScreen extends StatefulWidget {
  const ClientSetPersonalPlanScreen({super.key, required this.height, required this.weight});

  final int height;
  final int weight;

  @override
  State<ClientSetPersonalPlanScreen> createState() => _ClientSetPersonalPlanScreenState();
}

class _ClientSetPersonalPlanScreenState extends State<ClientSetPersonalPlanScreen> {
  final storage = SharedPreferenceData.getInstance();
  String userName = "";
  double imt = 0;
  int weight = 0;
  double height = 0;
  String target = "";

  List<ListOfRecItem> recommendations = [
    ListOfRecItem(
      hiegth: 0,
      listOfRecItems: [
        RecItem(
          text:
              'Половину Вашего рациона должны составлять зелень и овощи. Чем больше овощей, чем они разнообразнее, тем лучше. Употребляйте больше разных по цвету овощей, фруктов и ягод.',
        ),
        RecItem(
          text:
              'Выбирайте полезные белки для Вашей тарелки – рыбу, птицу, морепродукты, бобы и орехи. Ограничьте сыр и красное мясо. Избегайте бекона, колбас и других переработанных мясных продуктов.',
        ),
        RecItem(
          text:
              'Ешьте разные цельнозерновые продукты (хлеб, макароны, крупы). Ограничьте употребление очищенных зерен (белый рис, белый хлеб).',
        ),
        RecItem(
          text:
              'Используйте ежедневно растительные нерафинированные  масла (оливковое, льняное, кедровое и т.д) для приготовления салатов и других блюд. Избегайте сливочного масла и транс – жиров.',
        ),
        RecItem(
          text:
              'Постарайтесь пить чай или кофе без/или с небольшим количеством сахара. Ограничьте употребление молока и сока. Избегайте сладкие напитки и газировку.',
        ),
      ],
    ),
    ListOfRecItem(
      hiegth: 0,
      listOfRecItems: [
        RecItem(
          name: 'Как рассчитать индивидуальную норму воды?',
          subName: 'Рекомендовано\n30 мл жидкости на\n1 кг идеального веса',
          text: 'Очень важно, чтобы вода была чистой и обогащена необходимыми минеральными веществами.',
        ),
        RecItem(
          text:
              'В настоящее время существует много методов для улучшения качества воды:\n·    Ионизаторы воды\n·    Генераторы водородной воды\n·    Наборы минералов для очистки и структуризации воды.\nМинеральные добавки для питьевой воды',
        ),
        RecItem(
          text:
              'Результатом ежедневного употребления теплой воды станет снижение веса, очищение кожи, нормализация работы ЖКТ, артериального давления и общее хорошее самочувствие.',
        ),
      ],
    ),
    ListOfRecItem(
      hiegth: 0,
      listOfRecItems: [
        RecItem(
          text:
              'Ключом к хорошей форме является физическая активность и правильное питание. Это принесет пользу не только Вашей внешности, но и повлияет на\n общее самочувствие, сон, уровень энергии и эмоциональное состояние.',
        ),
        RecItem(
          text:
              'Самое простое, что Вы можете для себя сделать:\n– проходить ежедневно 10 тысяч шагов\n– делать утреннюю зарядку\n– подниматься по лестнице, вместо использования лифта',
        ),
        RecItem(
          text:
              '– проводить время с семьей и заниматься\nвместе любимыми активностями,\n– выходить из общественного транспорта немного раньше и проходить это расстояние пешком',
        ),
      ],
    ),
    ListOfRecItem(
      hiegth: 0,
      listOfRecItems: [
        RecItem(
          text:
              '· Для взрослого человека оптимальное время сна 7-9 часов.\n· Просыпайтесь в одно и то же время, несмотря на время когда Вы уснули.\n· Ложитесь спать в 22-00 – 22-30.',
        ),
        RecItem(
          text:
              '· Дневной сон при необходимости должен быть не больше 20 минут.\n· Разработайте расслабляющий ритуал перед сном, чтобы сигнализировать своему телу, что пришло время отдыхать.',
        ),
        RecItem(
          text:
              '· Сделайте среду для сна комфортной: убедитесь, что Ваша спальня прохладная, темная и тихая.\n· Избегайте использования электронных устройств со светящимися экранами, таких как телевизор, смартфон, планшет и компьютер, по крайней мере за час до сна.',
        ),
        RecItem(
          text:
              '· Избегайте тяжелой пищи в вечернее время. Старайтесь уменьшить употребление кофе и алкоголя. Откажитесь от курения.\n· Регулярно занимайтесь спортом.\n· Практикуйте техники релаксации, такие как медитация, глубокое дыхание или йога, чтобы помочь уменьшить стресс перед сном.',
        ),
        RecItem(
          text:
              '· Поддерживайте комфортную обстановку для сна: приобретите удобный матрас, подушки и одеяло. Это поможет предотвратить дискомфорт и улучшить качество Вашего сна.\n· Стремитесь к естественному воздействию света в течение дня, это поможет отрегулировать цикл сна и бодрствования.',
        ),
        RecItem(
          text:
              '· Ограничьте количество жидкостей перед сном, чтобы свести к минимуму ночные пробуждения и свести к минимуму нагрузку на почки.',
        )
      ],
    ),
  ];

  @override
  void initState() {
    check();
    super.initState();
  }

  check() async {
    userName = await storage.getItem(SharedPreferenceData.userNameKey);
    height = widget.height / 100;
    imt = widget.weight / (height * height);

    if (imt <= 18.5) {
      target = "Набрать вес";
    } else if (imt >= 25.1) {
      target = "Сбросить вес";
    } else {
      target = "Удержать вес";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.gradientTurquoiseReverse,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 200.w),
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
                padding: EdgeInsets.only(left: 70.w, top: 300.h),
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
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/images/Ellipse 4.webp',
                  height: 600.h,
                  fit: BoxFit.fill,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 56.h,
                      width: double.infinity,
                      child: Center(
                        child: PageControllerContainer(
                          choosenIndex: 2,
                          length: 3,
                        ),
                      ),
                    ),
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
                                text:
                                    ', мы проанализировали Ваши показатели и согласно рекомендациям ВОЗ рассчитали индекс массы тела (ИМТ) и идеальный вес',
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
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.basicwhiteColor,
                                borderRadius: BorderRadius.circular(8.r),
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
                                    imt.toStringAsFixed(2),
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
                                    widget.weight.toString(),
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
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientTurquoise,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h),
                          Text(
                            'Результат и путь к цели',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Вам стоит обратить внимание на Ваш образ жизни, выше указанные параметры, говорят о том, что Вам необходимо позаботиться о своем здоровье, а именно сбросить лишний вес.',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Container(
                            width: double.infinity,
                            height: 64.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: AppColors.limeColor,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                children: [
                                  Text(
                                    target,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.sp,
                                      fontFamily: 'Inter',
                                      color: AppColors.darkGreenColor,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    '-  рекомендуемая цель',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      fontFamily: 'Inter',
                                      color: AppColors.darkGreenColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'Рекомендации',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'для достижения идеального веса и направленные на оздоровление организма',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                    ClientPersonalPlanListView(
                      name: 'Принципы здорового питания',
                      indexOfElement: 0,
                    ),
                    SizedBox(height: 8.h),
                    gradientCon(
                      'Важным фактором соблюдения здорового питания, является активный образ жизни: регулярные физические нагрузки, прогулки на свежем воздухе, интересная социальная жизнь.\n\nПозитивное общение во время приема пищи - уменьшает эмоциональное напряжение, улучшает пищеварение и дает позитивный жизненный настрой.',
                    ),
                    SizedBox(height: 10.h),
                    ClientPersonalPlanListView(
                      name: 'Питьевой режим',
                      indexOfElement: 1,
                    ),
                    ClientPersonalPlanListView(
                      name: 'Ежедневная активность',
                      indexOfElement: 2,
                    ),
                    SizedBox(
                      height: 33.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '4. Нормы часов сна',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              color: AppColors.vivaMagentaColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    gradientCon(
                      'Сон имеет важнейшее значение для нормализации веса.\nЗнание  циркадных ритмов, соблюдение режима сна и бодрствования необходимо для поддержания физического и психологического здоровья.',
                    ),
                    SizedBox(height: 10.h),
                    ClientPersonalPlanListView(
                      name: '',
                      removeName: true,
                      indexOfElement: 3,
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'В бесплатной версии',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Вы можете отслеживать выпитое количество воды, изменения веса, количество пройденных шагов и видеть свою динамику.\n\nТакже Вы можете хранить результаты анализов, исследований своих и членов Вашей семьи в одном месте в приложении Garnetbook, что позволяет быстро находить нужные данные.\n\nВы получите отличную возможность следить за своим здоровьем, как самостоятельно, так и под руководством специалиста.',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    gradientCon(
                      'Если Вы хотите получить более расширенный функционал приложения, вы можете оформить подписку и получить более персональные рекомендации!',
                    ),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: WidgetButton(
                        onTap: () async {
                          await context.router.pushAndPopUntil(
                            const DashboardContainerRoute(),
                            predicate: (_) => false,
                          );
                        },
                        text: 'Больше о приложении'.toUpperCase(),
                        color: AppColors.darkGreenColor,
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gradientCon(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.limeColor,
          ),
          borderRadius: BorderRadius.circular(8.r),
          gradient: AppColors.gradientTurquoise,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              fontFamily: 'Inter',
              color: AppColors.darkGreenColor,
            ),
          ),
        ),
      ),
    );
  }
}
