import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/ui/client_category/target/screens/client_set_personal_plan_screen.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:measure_size/measure_size.dart';

class ClientPersonalPlanListView extends StatefulWidget {
  final String name;
  final int indexOfElement;
  final bool? removeName;

  const ClientPersonalPlanListView({
    super.key,
    required this.name,
    required this.indexOfElement,
    this.removeName,
  });

  @override
  State<ClientPersonalPlanListView> createState() => _ClientPersonalPlanListViewState();
}

class _ClientPersonalPlanListViewState extends State<ClientPersonalPlanListView> {
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
          text: 'Ешьте разные цельнозерновые продукты (хлеб, макароны, крупы). Ограничьте употребление очищенных зерен (белый рис, белый хлеб).',
        ),
        RecItem(
          text:
          'Используйте ежедневно растительные нерафинированные  масла (оливковое, льняное, кедровое и т.д) для приготовления салатов и других блюд. Избегайте сливочного масла и транс – жиров.',
        ),
        RecItem(
          text: 'Постарайтесь пить чай или кофе без/или с небольшим количеством сахара. Ограничьте употребление молока и сока. Избегайте сладкие напитки и газировку.',
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
          text: 'Результатом ежедневного употребления теплой воды станет снижение веса, очищение кожи, нормализация работы ЖКТ, артериального давления и общее хорошее самочувствие.',
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
          text: '– проводить время с семьей и заниматься\nвместе любимыми активностями,\n– выходить из общественного транспорта немного раньше и проходить это расстояние пешком',
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
          text: '· Ограничьте количество жидкостей перед сном, чтобы свести к минимуму ночные пробуждения и свести к минимуму нагрузку на почки.',
        )
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.removeName != true)
          SizedBox(
            height: 33.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${widget.indexOfElement + 1}. ${widget.name}',
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
        SizedBox(
          height: recommendations[widget.indexOfElement].hiegth + 24.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            itemCount: recommendations[widget.indexOfElement].listOfRecItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : 24.w,
                  top: 12.h,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: MeasureSize(
                    onChange: (size) {
                      if (size.height > recommendations[widget.indexOfElement].hiegth) {
                        recommendations[widget.indexOfElement] = ListOfRecItem(
                          hiegth: size.height,
                          listOfRecItems: recommendations[widget.indexOfElement].listOfRecItems,
                        );
                        setState(() {});
                      }
                    },
                    child: Container(
                      width: 284.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.basicwhiteColor,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/target/${widget.indexOfElement + 1}/${index + 1}.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 94.h,
                            ),
                            if (recommendations[widget.indexOfElement].listOfRecItems[index].name != null &&
                                recommendations[widget.indexOfElement].listOfRecItems[index].subName != null)
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            recommendations[widget.indexOfElement].listOfRecItems[index].name!.toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.sp,
                                              fontFamily: 'Inter',
                                              color: AppColors.darkGreenColor,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            recommendations[widget.indexOfElement].listOfRecItems[index].subName!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              fontFamily: 'Inter',
                                              color: AppColors.darkGreenColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.gradientTurquoise,
                                    ),
                                  )
                                ],
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                recommendations[widget.indexOfElement].listOfRecItems[index].text,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
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
          ),
        ),
      ],
    );
  }
}
