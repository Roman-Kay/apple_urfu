class ItemDrink {
  final String image;
  final String title;
  final int? quantity;
  final List<ItemDrinkItem> addsList;
  final double? calorie;

  ItemDrink({required this.image, required this.title, required this.addsList, this.calorie, this.quantity});
}

class ItemDrinkItem {
  final String title;
  final String type;
  final int ml;
  final double calorie;
  final String? image;
  final String? subTitle;
  final List<ItemWater>? subList;

  ItemDrinkItem({required this.calorie, required this.ml, required this.title, required this.type, this.image, this.subTitle, this.subList});
}

class ItemColor {
  final String text;
  final String imageName;
  final List listOfProducts;
  bool isChoose;
  int id;

  ItemColor({
    required this.text,
    required this.id,
    required this.imageName,
    required this.isChoose,
    required this.listOfProducts,
  });
}

class ItemWater {
  ItemWater({
    required this.text,
    required this.portion,
    required this.calorie,
  });

  String text;
  int portion;
  int calorie;
}

class ItemDrinkAdds {
  final String title;
  final List<ItemDrinkAddsItem> addsList;

  ItemDrinkAdds({
    required this.title,
    required this.addsList,
  });
}

class ItemDrinkAddsItem {
  final String title;
  final int quantity;
  final String measure;
  final double calorie;
  final int? grams;
  final int ml;
  final String? subTitle;

  ItemDrinkAddsItem({required this.title, required this.quantity, required this.measure, required this.calorie, required this.ml, this.grams, this.subTitle});
}

class FoodDiaryStorage {
  final List<ItemDrinkAdds> addsDrinksList = [
    ItemDrinkAdds(
      title: 'Молоко/сливки',
      addsList: [
        ItemDrinkAddsItem(title: "Сливки", quantity: 0, measure: "ст.л.", calorie: 57.96, ml: 15),
        ItemDrinkAddsItem(title: "Молоко коровье 0,5%", quantity: 0, measure: "ст.л.", calorie: 7, ml: 15),
        ItemDrinkAddsItem(title: "Молоко коровье 1%", quantity: 0, measure: "ст.л.", calorie: 8.2, ml: 15),
        ItemDrinkAddsItem(title: "Молоко коровье 1,5%", quantity: 0, measure: "ст.л.", calorie: 8.8, ml: 15),
        ItemDrinkAddsItem(title: "Молоко коровье 2,5%", quantity: 0, measure: "ст.л.", calorie: 10.4, ml: 15),
        ItemDrinkAddsItem(title: "Молоко коровье 3,2%", quantity: 0, measure: "ст.л.", calorie: 11.8, ml: 15),
        ItemDrinkAddsItem(title: "Молоко миндальное", quantity: 0, measure: "ст.л.", calorie: 34, ml: 15),
        ItemDrinkAddsItem(title: "Молоко кокосовое", quantity: 0, measure: "ст.л.", calorie: 38, ml: 15),
        ItemDrinkAddsItem(title: "Молоко овсяное", quantity: 0, measure: "ст.л.", calorie: 16.5, ml: 15),
        ItemDrinkAddsItem(title: "Молоко кедровое", quantity: 0, measure: "ст.л.", calorie: 13.7, ml: 15),
        ItemDrinkAddsItem(title: "Молоко соевое", quantity: 0, measure: "ст.л.", calorie: 13.5, ml: 15),
        ItemDrinkAddsItem(title: "Молоко рисовое", quantity: 0, measure: "ст.л.", calorie: 15, ml: 15),
      ],
    ),
    ItemDrinkAdds(
      title: "орехи/зёрна",
      addsList: [
        ItemDrinkAddsItem(title: "Семена льна", quantity: 0, measure: "ст.л.", calorie: 133.5, ml: 15),
        ItemDrinkAddsItem(title: "Кедровые орехи", quantity: 0, measure: "ст.л.", calorie: 170, ml: 15),
      ],
    ),
    ItemDrinkAdds(
      title: "овощи/зелень",
      addsList: [
        ItemDrinkAddsItem(title: "Морковь", quantity: 0, measure: "шт.", calorie: 75, ml: 140),
        ItemDrinkAddsItem(title: "Огурец", quantity: 0, measure: "шт.", calorie: 15, ml: 120),
        ItemDrinkAddsItem(title: "Имбирь", quantity: 0, measure: "ч.л.", calorie: 10, ml: 5),
        ItemDrinkAddsItem(title: "Сельдерей", quantity: 0, grams: 50, measure: "50 гр.", calorie: 6, ml: 50),
        ItemDrinkAddsItem(title: "Петрушка пучок", quantity: 0, grams: 50, measure: "50 гр.", calorie: 23.5, ml: 50),
        ItemDrinkAddsItem(title: "Укроп пучок", quantity: 0, grams: 50, measure: "50 гр.", calorie: 38, ml: 50),
        ItemDrinkAddsItem(title: "Кинза пучок", quantity: 0, grams: 50, measure: "50 гр.", calorie: 11, ml: 50),
      ],
    ),
    ItemDrinkAdds(
      title: "фрукты/ягоды",
      addsList: [
        ItemDrinkAddsItem(title: "Банан целый", quantity: 0, measure: "шт.", calorie: 104.5, ml: 220),
        ItemDrinkAddsItem(title: "Банан 1/2", quantity: 0, measure: "пол. шт.", calorie: 52.3, ml: 110),
        ItemDrinkAddsItem(title: "Яблоко целое", quantity: 0, measure: "шт.", calorie: 77.6, ml: 242),
        ItemDrinkAddsItem(title: "Яблоко 1/2", quantity: 0, measure: "пол. шт.", calorie: 38.8, ml: 121),
        ItemDrinkAddsItem(title: "Авокадо целое", quantity: 0, measure: "шт.", calorie: 508.8, ml: 110),
        ItemDrinkAddsItem(title: "Авокадо 1/2", quantity: 0, measure: "пол. шт.", calorie: 254.4, ml: 50),
        ItemDrinkAddsItem(title: "Клубника", quantity: 0, grams: 100, measure: "гр.", calorie: 41, ml: 1),
        ItemDrinkAddsItem(title: "Мандарин", quantity: 0, measure: "шт.", calorie: 33, ml: 67),
        ItemDrinkAddsItem(title: "Малина", quantity: 0, grams: 100, measure: "гр.", calorie: 46, ml: 1),
        ItemDrinkAddsItem(title: "Киви", quantity: 0, measure: "шт.", calorie: 50, ml: 75),
      ],
    ),
    ItemDrinkAdds(
      title: "протеин",
      addsList: [
        ItemDrinkAddsItem(title: "Протеин гороховый", quantity: 0, measure: "ст.л.", calorie: 89.2, ml: 15),
        ItemDrinkAddsItem(title: "Протеин сывороточный", quantity: 0, measure: "ст.л.", calorie: 105, ml: 15),
        ItemDrinkAddsItem(title: "Протеин конопляный", quantity: 0, measure: "ст.л.", calorie: 109, ml: 15),
        ItemDrinkAddsItem(title: "Протеин тыквенный", quantity: 0, measure: "ст.л.", calorie: 100, ml: 15),
      ],
    ),
    ItemDrinkAdds(
      title: "другое",
      addsList: [
        ItemDrinkAddsItem(title: "Стевия", quantity: 0, measure: "ч.л.", calorie: 1.44, ml: 1),
        ItemDrinkAddsItem(title: "Проростки", quantity: 0, grams: 100, measure: "гр.", calorie: 110, ml: 1),
        ItemDrinkAddsItem(title: "Псиллиум", quantity: 0, measure: "ч.л.", calorie: 4.2, ml: 5),
      ],
    ),
    ItemDrinkAdds(
      title: "крахмал",
      addsList: [
        ItemDrinkAddsItem(title: "Крахмал тапиоковый", quantity: 0, measure: "ст.л.", calorie: 108, ml: 15),
        ItemDrinkAddsItem(title: "Крахмал картофельный", quantity: 0, measure: "ст.л.", calorie: 90, ml: 15),
        ItemDrinkAddsItem(title: "Крахмал из юкки", quantity: 0, measure: "ст.л.", calorie: 47.7, ml: 15),
      ],
    ),
  ];

  final List<ItemDrink> listOfItemDrink = [
    ItemDrink(
      image: 'assets/images/drink/coffee.jpg',
      title: 'Кофе',
      calorie: 5,
      addsList: [
        ItemDrinkItem(calorie: 12, ml: 100, title: "Кофе латте", type: "латте".toUpperCase(), image: 'assets/images/drink/coffee_adds/coffee_add_late.png', subList: [
          ItemWater(text: "Коффе латте на коровьем молоке", portion: 100, calorie: 40),
          ItemWater(text: "Коффе латте на кокосовом молоке", portion: 100, calorie: 71),
          ItemWater(text: "Коффе латте на миндальном молоке", portion: 100, calorie: 63),
        ]),
        ItemDrinkItem(calorie: 32, ml: 100, title: "Кофе капучино", type: "капучино".toUpperCase(), image: 'assets/images/drink/coffee_adds/coffee_add_capuchino.png', subList: [
          ItemWater(text: "Коффе капучино на коровьем молоке", portion: 100, calorie: 32),
          ItemWater(text: "Коффе капучино на кокосовом молоке", portion: 100, calorie: 106),
          ItemWater(text: "Коффе капучино на миндальном молоке", portion: 100, calorie: 57),
        ]),
        ItemDrinkItem(calorie: 5, ml: 100, title: "Кофе американо", type: "американо".toUpperCase(), image: 'assets/images/drink/coffee_adds/coffee_add_americano.png'),
        ItemDrinkItem(calorie: 2, ml: 100, title: "Кофе эспрессо", type: "эспрессо".toUpperCase(), image: 'assets/images/drink/coffee_adds/coffee_add_exspresso.png'),
        ItemDrinkItem(calorie: 125, ml: 100, title: "Кофе гляссе", type: "гляссе".toUpperCase(), image: 'assets/images/drink/coffee_adds/coffee_add_glace.png'),
        ItemDrinkItem(calorie: 289, ml: 100, title: "Кофе моккаччино", type: "моккаччино".toUpperCase(), image: 'assets/images/drink/coffee_adds/coffee_add_mochaccino.png', subList: [
          ItemWater(text: "Коффе моккаччино на коровьем молоке", portion: 100, calorie: 80),
          ItemWater(text: "Коффе моккаччино на кокосовом молоке", portion: 100, calorie: 68),
          ItemWater(text: "Коффе моккаччино на миндальном молоке", portion: 100, calorie: 63),
        ]),
        ItemDrinkItem(calorie: 70, ml: 100, title: "Кофе по-венски", type: "по-венски".toUpperCase(), image: 'assets/images/drink/coffee_adds/coffee_add_po_venski.png'),
        ItemDrinkItem(calorie: 21.9, ml: 100, title: "Кофе по-восточному", type: "по-восточному".toUpperCase(), image: 'assets/images/drink/coffee_adds/coffee_add_vostok.png'),
      ],
    ),

    ItemDrink(
      image: 'assets/images/drink/tea.jpg',
      title: 'Чай',
      calorie: 1,
      addsList: [
        ItemDrinkItem(calorie: 1, ml: 100, title: "Чай чёрный", type: "чёрный".toUpperCase(), image: 'assets/images/drink/tea_adds/tea_add_black.png'),
        ItemDrinkItem(calorie: 1, ml: 100, title: "Чай зеленый", type: "зеленый".toUpperCase(), image: 'assets/images/drink/tea_adds/tea_add_green.png'),
        ItemDrinkItem(calorie: 2, ml: 100, title: "Чай травяной", type: "травяной".toUpperCase(), image: 'assets/images/drink/tea_adds/tea_add_herbal.png'),
        ItemDrinkItem(calorie: 50, ml: 100, title: "Чай матча", type: "матча", image: 'assets/images/drink/tea_adds/tea_add_matcha.png', subList: [
          ItemWater(text: "Чай матча на коровьем молоке", portion: 100, calorie: 50),
          ItemWater(text: "Чай матча на кокосовом молоке", portion: 100, calorie: 71),
          ItemWater(text: "Чай матча на миндальном молоке", portion: 100, calorie: 63),
        ]),
        ItemDrinkItem(calorie: 8, ml: 100, title: "Чай облепиховый", type: "облепиховый".toUpperCase(), image: 'assets/images/drink/tea_adds/tea_add_sea_buckthorn.png')
      ],
    ),

    ItemDrink(image: 'assets/images/drink/freshly_squeezed_juice.jpg', title: 'Сок фруктовый пакетированный', calorie: 45, addsList: []),

    ItemDrink(image: 'assets/images/drink/fruit_juice_bagged.jpg', title: 'Свежевыжатый сок', addsList: [
      ItemDrinkItem(calorie: 15.5, ml: 50, title: "Сок из сельдерея", type: "Сок из сельдерея".toUpperCase(), image: 'assets/images/drink/juice_adds/juice_add_zucchini.png'),
      ItemDrinkItem(calorie: 21, ml: 50, title: "Сок яблочный", type: "яблочный".toUpperCase(), image: 'assets/images/drink/juice_adds/juice_add_apple.png'),
      ItemDrinkItem(calorie: 18, ml: 50, title: "Сок апельсиновый", type: "апельсиновый".toUpperCase(), image: 'assets/images/drink/juice_adds/juice_add_orange.png'),
      ItemDrinkItem(calorie: 15, ml: 50, title: "Сок грейпфрутовый", type: "грейпфрутовый".toUpperCase(), image: 'assets/images/drink/juice_adds/juice_add_grapefruite.png'),
      ItemDrinkItem(calorie: 14, ml: 50, title: "Сок морковный", type: "морковный".toUpperCase(), image: 'assets/images/drink/juice_adds/juice_add_carrot.png'),
      ItemDrinkItem(calorie: 21, ml: 50, title: "Сок свекольный", type: "свекольный".toUpperCase(), image: 'assets/images/drink/juice_adds/juice_add_beetroot.png'),
      ItemDrinkItem(calorie: 7, ml: 50, title: "Сок огуречный", type: "огуречный".toUpperCase(), image: 'assets/images/drink/juice_adds/juice_add_cocumber.png'),
      ItemDrinkItem(calorie: 22, ml: 50, title: "Сок капустный", type: "капустный".toUpperCase(), image: 'assets/images/drink/juice_adds/juice_add_cabbage.png'),
      ItemDrinkItem(calorie: 22, ml: 50, title: "Сок из кабачка", type: "из кабачка".toUpperCase(), image: 'assets/images/drink/juice_adds/juice_add_zucchini.png'),
      ItemDrinkItem(calorie: 38, ml: 50, title: "Сок из тыквы", type: "из тыквы".toUpperCase(), image: 'assets/images/drink/juice_adds/juice_add_pumpkin.png'),
      ItemDrinkItem(calorie: 27, ml: 50, title: "Сок виноградный", type: "виноградный".toUpperCase(), image: 'assets/images/drink/juice_adds/juice_add_grape.png'),
    ]),

    ItemDrink(image: 'assets/images/drink/carbonated_drink.jpg', title: 'Газированные напитки', calorie: 45, addsList: []),

    ItemDrink(image: 'assets/images/drink/factory_milk_2,5%.jpg', title: 'Молоко', addsList: [
      ItemDrinkItem(calorie: 87.5, ml: 250, title: "Молоко коровье 0,5%", type: "коровье 0,5%".toUpperCase()),
      ItemDrinkItem(calorie: 102.5, ml: 250, title: "Молоко коровье 1%", type: "коровье 1%".toUpperCase()),
      ItemDrinkItem(calorie: 110, ml: 250, title: "Молоко коровье 1,5%", type: "коровье 1,5%".toUpperCase()),
      ItemDrinkItem(calorie: 130, ml: 250, title: "Молоко коровье 2,5%", type: "коровье 2,5%".toUpperCase()),
      ItemDrinkItem(calorie: 147.5, ml: 250, title: "Молоко коровье 3,2%", type: "коровье 3,2%".toUpperCase()),
      ItemDrinkItem(calorie: 340, ml: 250, title: "Молоко миндальное", type: "миндальное".toUpperCase()),
      ItemDrinkItem(calorie: 308, ml: 250, title: "Молоко кокосовое", type: "кокосовое".toUpperCase()),
      ItemDrinkItem(calorie: 165, ml: 250, title: "Молоко овсяное", type: "овсяное".toUpperCase()),
      ItemDrinkItem(calorie: 137, ml: 250, title: "Молоко кедровое", type: "кедровое".toUpperCase()),
      ItemDrinkItem(calorie: 135, ml: 250, title: "Молоко соевое", type: "соевое".toUpperCase()),
      ItemDrinkItem(calorie: 150, ml: 250, title: "Молоко рисовое", type: "рисовое".toUpperCase()),
      ItemDrinkItem(calorie: 170, ml: 250, title: "Молоко козье", type: "козье".toUpperCase()),
      ItemDrinkItem(calorie: 275.5, ml: 250, title: "Фруктовый молочный коктейль", type: "фруктовое".toUpperCase()),
    ]),

    ItemDrink(image: 'assets/images/drink/fermented_milk.jpg', title: 'Ферментированные напитки', addsList: [
      ItemDrinkItem(
        calorie: 85,
        ml: 100,
        title: "Йогурт",
        type: "Йогурт",
        image: 'assets/images/drink/fermented_drink_adds/fermented_drink_add_yogurt.png',
        subList: [
          ItemWater(text: "Йогурт фруктовый из коровьего молока 3,2%", portion: 100, calorie: 85),
          ItemWater(text: "Йогурт натуральный из коровьего молока", portion: 100, calorie: 66),
          ItemWater(text: "Йогурт греческий", portion: 100, calorie: 66),
          ItemWater(text: "Йогурт фруктовый из коровьего молока 1,5%", portion: 100, calorie: 63),
          ItemWater(text: "Йогурт кокосовый", portion: 100, calorie: 173),
          ItemWater(text: "Миндальный йогурт", portion: 100, calorie: 10),
        ],
      ),

      ItemDrinkItem(calorie: 57, ml: 100, title: "Ряженка", type: "Ряженка", image: 'assets/images/drink/fermented_drink_adds/fermented_drink_add_ryazhenka.png', subList: [
        ItemWater(text: "Ряженка из коровьего молока 1%", portion: 100, calorie: 40),
        ItemWater(text: "Ряженка из коровьего молока 2,5%", portion: 100, calorie: 54),
        ItemWater(text: "Ряженка из коровьего молока 3,2%", portion: 100, calorie: 57),
        ItemWater(text: "Ряженка из коровьего молока 4%", portion: 100, calorie: 67),
        ItemWater(text: "Ряженка из коровьего молока 6%", portion: 100, calorie: 84),
      ]),

      ItemDrinkItem(calorie: 77, ml: 100, title: "Снежок", type: "Снежок", subTitle: 'из коровьего молока', image: 'assets/images/drink/fermented_drink_adds/fermented_drink_add_snezhok.png'),

      ItemDrinkItem(calorie: 56, ml: 100, title: "Кефир", type: "Кефир", image: 'assets/images/drink/fermented_drink_adds/fermented_drink_add_kefir.png', subList: [
        ItemWater(text: "Кефир из коровьего молока 0%", portion: 100, calorie: 30),
        ItemWater(text: "Кефир из коровьего молока 1%", portion: 100, calorie: 40),
        ItemWater(text: "Кефир из коровьего молока 2,5%", portion: 100, calorie: 50),
      ]),

      ItemDrinkItem(calorie: 64, ml: 100, title: "Мацони", type: "Мацони", subTitle: 'из коровьего молока', image: 'assets/images/drink/fermented_drink_adds/fermented_drink_add_maconi.png'),
      ItemDrinkItem(calorie: 53, ml: 100, title: "Простокваша", type: "Простокваша", subTitle: 'из коровьего молока', image: 'assets/images/drink/fermented_drink_adds/fermented_drink_add_clabber.png'),
      ItemDrinkItem(calorie: 24, ml: 100, title: "Айран (тан)", type: 'Айран (тан)', subTitle: "газированный", image: 'assets/images/drink/fermented_drink_adds/fermented_drink_add_tan.png'),
      ItemDrinkItem(calorie: 36, ml: 100, title: "Комбуча", type: "Комбуча", image: 'assets/images/drink/fermented_drink_adds/fermented_drink_add_kombucha.png'),
      ItemDrinkItem(calorie: 30, ml: 100, title: "Чайный гриб", type: "Чайный гриб", subTitle: 'напиток', image: 'assets/images/drink/fermented_drink_adds/fermented_drink_add_tea_mushroom.png'),
      ItemDrinkItem(calorie: 19.6, ml: 100, title: "Водный кефир", type: "Водный кефир", image: 'assets/images/drink/fermented_drink_adds/fermented_drink_add_water_kefir.png'),
    ]),

    ItemDrink(image: 'assets/images/drink/smoothie.png', title: 'Смузи', calorie: 60, addsList: []),

    ItemDrink(image: 'assets/images/drink/strong_alcohol.jpg', title: 'Алкоголь', addsList: [
      ItemDrinkItem(calorie: 66, ml: 100, title: "Вино белое сухое", type: "Вино белое сухое"),
      ItemDrinkItem(calorie: 82, ml: 100, title: "Вино белое полусухое", type: "Вино белое полусухое"),
      ItemDrinkItem(calorie: 130, ml: 100, title: "Вино белое полусладкое", type: "Вино белое полусладкое"),
      ItemDrinkItem(calorie: 170, ml: 100, title: "Вино красное сладкое", type: "Вино красное сладкое"),
      ItemDrinkItem(calorie: 68, ml: 100, title: "Вино красное сухое", type: "Вино красное сухое"),
      ItemDrinkItem(calorie: 105, ml: 100, title: "Вино красное полусухое", type: "Вино красное полусухое"),
      ItemDrinkItem(calorie: 147, ml: 100, title: "Вино красное полусладкое", type: "Вино красное полусладкое"),
      ItemDrinkItem(calorie: 172, ml: 100, title: "Вино красное сладкое", type: "Вино красное сладкое"),
      ItemDrinkItem(calorie: 88, ml: 100, title: "Шампанское", type: "Шампанское"),
      ItemDrinkItem(calorie: 45, ml: 100, title: "Пиво", type: "Пиво"),
      ItemDrinkItem(calorie: 33, ml: 100, title: "Безалкогольное пиво", type: "Безалкогольное пиво"),
      ItemDrinkItem(calorie: 239, ml: 100, title: "Крепкий алкоголь", type: "Крепкий алкоголь"),
      ItemDrinkItem(calorie: 68, ml: 100, title: "Просеко", type: "Просеко"),
      ItemDrinkItem(calorie: 160, ml: 100, title: "Апероль", type: "Апероль"),
      ItemDrinkItem(calorie: 77, ml: 100, title: "Коктейль Беллини", type: "Коктейль Беллини"),
      ItemDrinkItem(calorie: 153, ml: 100, title: "Коктейль Сауэр", type: "Коктейль Сауэр"),
    ]),

    ItemDrink(image: 'assets/images/drink/compote.png', title: 'Компот', calorie: 15, addsList: [
      ItemDrinkItem(calorie: 27, ml: 100, title: "Компот из сухофруктов", type: "из сухофруктов", subTitle: 'без сахара', image: 'assets/images/drink/compote_adds/compot_add_dried_fruits.png'),
      ItemDrinkItem(calorie: 11, ml: 100, title: "Компот ягодный", type: "ягодный", subTitle: 'без сахара', image: 'assets/images/drink/compote_adds/compot_add_berries.png'),
    ]),

    ItemDrink(image: 'assets/images/drink/kvass.png', title: 'Квас', calorie: 30, addsList: [
      ItemDrinkItem(calorie: 36, ml: 100, title: "Квас ржаной домашний", type: "ржаной", subTitle: "домашний", image: 'assets/images/drink/kvass_adds/kvass_add_rye.png'),
      ItemDrinkItem(calorie: 30, ml: 100, title: "Квас фабричный", type: "фабричный", image: 'assets/images/drink/kvass_adds/kvas_add_fabric.png'),
    ]),

    ItemDrink(
      image: 'assets/images/drink/cranberry_juice_no_sugar.jpg',
      title: 'Морс',
      calorie: 32,
      addsList: [
        ItemDrinkItem(calorie: 32, ml: 100, title: "Морс клюквенный", type: "клюквенный", image: 'assets/images/drink/mors_adds/mors_add_kranberry.png'),
        ItemDrinkItem(calorie: 42, ml: 100, title: "Морс ягодный", type: "ягодный", image: 'assets/images/drink/mors_adds/mors_add_berry.png'),
      ],
    ),

    ItemDrink(image: 'assets/images/drink/jelly.png', title: "Кисель", calorie: 58, addsList: [
      ItemDrinkItem(calorie: 58, ml: 100, title: "Кисель ягодный", type: "ягодный".toUpperCase(), image: 'assets/images/drink/jelly_adds/jelly_add_berry.png'),
      ItemDrinkItem(calorie: 97, ml: 100, title: "Кисель фруктовый", type: "фруктовый".toUpperCase(), image: 'assets/images/drink/jelly_adds/jelly_add_juice.png'),
      ItemDrinkItem(calorie: 7.9, ml: 100, title: "Кисель овсяный", type: "овсяный".toUpperCase(), image: 'assets/images/drink/jelly_adds/jelly_add_oat.png'),
      ItemDrinkItem(calorie: 106.6, ml: 100, title: "Кисель молочный", type: "молочный".toUpperCase(), image: 'assets/images/drink/jelly_adds/jelly_add_milk.png'),
    ]),

    ItemDrink(image: 'assets/images/drink/cacao.png', title: "Какао", addsList: [
      ItemDrinkItem(calorie: 379, ml: 100, title: "Какао быстрорастворимый", type: "быстрорастворимый".toUpperCase(), image: 'assets/images/drink/cacao_adds/cacao_add_quickly_soluble.png'),
      ItemDrinkItem(calorie: 64.2, ml: 100, title: "Какао с молоком", type: "с молоком".toUpperCase(), image: 'assets/images/drink/cacao_adds/cacao_add_milk.png', subList: [
        ItemWater(text: "Какао на коровьем молоке", portion: 100, calorie: 64),
        ItemWater(text: "Какао на кокосовом молоке", portion: 100, calorie: 134),
        ItemWater(text: "Какао на миндальном молоке", portion: 100, calorie: 102),
      ]),
      ItemDrinkItem(calorie: 77, ml: 100, title: "Горячий шоколад", type: "горячий шоколад".toUpperCase(), image: 'assets/images/drink/cacao_adds/cacao_add_hot_chocalate.png'),
      ItemDrinkItem(calorie: 222, ml: 100, title: "Кероб", type: "кероб".toUpperCase(), image: 'assets/images/drink/cacao_adds/cacao_mil_herob.png'),
    ]),

    ItemDrink(image: 'assets/images/drink/limonade.png', title: "Лимонад", calorie: 45, addsList: [
      ItemDrinkItem(calorie: 44.8, ml: 100, title: "Лимонад манго-маракуйя", type: "манго-маракуйя".toUpperCase(), image: 'assets/images/drink/lemonade_adds/lemonade_add_mango_passion_fruite.png'),
      ItemDrinkItem(calorie: 57, ml: 100, title: "Лимонад лайм-маракуйя", type: "лайм-маракуйя".toUpperCase(), image: 'assets/images/drink/lemonade_adds/lemonade_add_lime_passion_fruite.png'),
      ItemDrinkItem(calorie: 40, ml: 100, title: "Лимонад мохито", type: "мохито".toUpperCase(), image: 'assets/images/drink/lemonade_adds/lemonade_add_mojito_passion_fruite.png'),
      ItemDrinkItem(calorie: 45, ml: 100, title: "Лимонад малина-грейпфрут", type: "малина-грейпфрут".toUpperCase(), image: 'assets/images/drink/lemonade_adds/lemonade_add_raspberry_grapefruit.png'),
      ItemDrinkItem(calorie: 20.5, ml: 100, title: "Лимонад облепиха-апельсин", type: "облепиха-апельсин".toUpperCase(), image: 'assets/images/drink/lemonade_adds/lemonade_add_sea​_buckthorn_orange.png'),
    ]),

    // КАЛЛОРИИ ВОДЫ
    //      {'Вода с лимоном': 0},
    //     {'Вода с ягодами': 3},
    //     {'Вода с имбирем': 3},
    //     {'Вода минеральная': 0},
  ];

  final List<String> items = [
    '30',
    '50',
    '100',
    '150',
    '200',
    '250',
    '300',
    '330',
    '400',
    '500',
    '600',
    '800',
    '1000',
  ];

  final List<ItemColor> listOfItemColor = [
    ItemColor(
      id: 1,
      text: 'Красные',
      imageName: 'red',
      isChoose: false,
      listOfProducts: [
        'Алыча (красная)',
        'Арбуз',
        'Барбарис',
        'Боярышник',
        'Виноград (красный)',
        'Вишня',
        'Гранат',
        'Гуава (розовая)',
        'Земляника',
        'Кизил',
        'Клубника',
        'Клюква',
        'Личи',
        'Малина',
        'Перец',
        'Помело',
        'Редиска',
        'Ревень',
        'Свекла',
        'Сливы',
        'Смородина',
        'Томаты',
        'Финик (свежий)',
        'Черешня',
        'Яблоки (красные)',
        'Ягоды'
      ],
    ),
    ItemColor(
      id: 2,
      listOfProducts: [
        'Айва',
        'Абрикосы',
        'Ананас',
        'Апельсины',
        'Бананы (желтые)',
        'Барбарис (желтый)',
        'Батат (сладкий картофель)',
        'Бобовые (желтые сорта фасоли и гороха)',
        'Дыня',
        'Кабачки (желтые)',
        'Какао-масло',
        'Картофель (желтые сорта)',
        'Кукуруза',
        'Куркума (корень)',
        'Лимоны',
        'Лимонник (травяная специя)',
        'Маракуйя',
        'Мандарин',
        'Манго',
        'Морковь',
        'Нектарины (желтые)',
        'Папайя',
        'Персики (желтые)',
        'Патиссоны (желтые)',
        'Перец',
        'Томаты (желтые сорта)',
        'Тыква',
        'Хурма',
        'Шафран (специя)',
        'Яблоки (желтые)'
      ],
      imageName: 'orange',
      text: 'Оранжевые и желтые',
      isChoose: false,
    ),
    ItemColor(
      id: 3,
      imageName: 'green',
      text: 'Зеленые',
      isChoose: false,
      listOfProducts: [
        'Авокадо',
        'Артишок',
        'Бананы зеленые',
        'Базилик (зеленый)',
        'Бобы',
        'Эдамаме',
        'Брюссельская капуста',
        'Брокколи',
        'Виноград (зеленый)',
        'Горох',
        'Гуава (зеленая)',
        'Капуста (зеленая)',
        'Киви',
        'Кинза',
        'Кресс-салат',
        'Лайм',
        'Лук',
        'зеленый (шалот)',
        'Лук-порей',
        'Мангольд',
        'Мелисса',
        'Огурец',
        'Оливки (зеленые)',
        'Пастернак (зелень)',
        'Перец (сладкий и чили)',
        'Петрушка',
        'Розмарин (свежий)',
        'Руккола',
        'Салатная зелень',
        'Сельдерей',
        'Спаржа',
        'Слива',
        'Спирулина',
        'Тимьян (свежий)',
        'Тмин (зелень)',
        'Укроп',
        'Фенхель (зелень)',
        'Фисташки',
        'Шпинат',
        'Щавель',
        'Яблоки (зеленые)'
      ],
    ),
    ItemColor(
      id: 4,
      imageName: 'blue_purple',
      text: 'Синие и фиолетовые',
      isChoose: false,
      listOfProducts: [
        'Асаи',
        'Баклажаны',
        'Батат (фиолетовый)',
        'Базилик (фиолетовый)',
        'Виноград',
        'Голубика',
        'Ежевика',
        'Инжир',
        'Краснокочанная капуста',
        'Маслины',
        'Личи (черные сорта)',
        'Питахайя',
        'Сливы',
        'Смородина черная',
        'Свекла',
        'Щелковица',
        'Тутовник',
        'Фасоль (фиолетовая)'
      ],
    ),
    ItemColor(
      id: 5,
      imageName: 'brown',
      text: 'Коричневые',
      isChoose: false,
      listOfProducts: [
        'Грибы',
        'Груши',
        'Имбирь',
        'Картофель (сорта с коричневой кожурой)',
        'Какао',
        'Кешью',
        'Кокос',
        'Кофе',
        'Лук',
        'Лук-шалот',
        'Миндаль',
        'Орехи',
        'Пастернак',
        'Репа',
        'Семена (льна, конопли, тыква)',
        'Соя (сушеная, коричневая)',
        'Тахини',
        'Топинамбур',
        'Чай (черный)'
      ],
    ),
    ItemColor(
      id: 6,
      imageName: 'white',
      text: 'Белые',
      isChoose: false,
      listOfProducts: [
        'Аспарагус (белая спаржа)',
        'Брюква',
        'Грибы (шампиньоны, белые грибы)',
        'Кокос',
        'Лук (белый)',
        'Лук-шалот (белый)',
        'Миндаль (очищенный)',
        'Кешью',
        'Патиссоны (белые)',
        'Семена (кунжут, подсолнечные)',
        'Соя (белая)',
        'Трюфели (белые)',
        'Цветная капуста',
        'Чай (белый)',
        'Чеснок',
        'Шелковица'
      ],
    ),
  ];
}
