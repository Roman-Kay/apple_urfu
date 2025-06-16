import 'package:flutter/cupertino.dart';

class TreeSurveyView {
  int id;
  String section;
  String title;
  String prefixFirstString;
  String prefixSecondString;
  String postfixString;
  List<TreeSurveyItemView> questionsList;
  List<TreeSurveyLineItem>? lineList;

  TreeSurveyView(
      {required this.title,
      required this.id,
      required this.postfixString,
      required this.prefixFirstString,
      required this.prefixSecondString,
      required this.section,
      this.lineList,
      required this.questionsList});
}

class TreeSurveyItemView {
  final String title;
  final int id;
  List<TreeSurveyAnswerView> answersList;
  final int num;
  final bool isMultipleChoice;
  bool isOneQuestion;
  TextEditingController? otherController;
  String? otherControllerText;
  int? serverId;

  TreeSurveyItemView({
    required this.num,
    required this.id,
    required this.title,
    required this.answersList,
    required this.isMultipleChoice,
    this.isOneQuestion = false,
    this.otherController,
    this.otherControllerText,
    this.serverId
  });
}

class TreeSurveyAnswerView {
  final String text;
  String? additionalText;
  String? additionalPostfixText;
  String? additionalPrefixText;
  final bool isOther;
  final bool clarifyShow;
  String? otherText;
  String? otherTitle;
  String? clarifyTitle;
  bool isSelected;
  bool? isClarifyNumber;
  bool isGreen;
  bool isShowInLine;
  final int result;
  int? serverId;

  TreeSurveyAnswerView(
      {required this.text,
      required this.isGreen,
      required this.result,
      this.isShowInLine = true,
      this.isOther = false,
      this.clarifyShow = false,
      this.otherText,
      this.additionalText,
      this.otherTitle,
      this.clarifyTitle,
      this.serverId,
      this.isSelected = false,
      this.additionalPostfixText,
      this.additionalPrefixText,
      this.isClarifyNumber});
}


class TreeSurveyLineItem {
  bool isNegative;
  String text;
  int? extId;

  TreeSurveyLineItem({required this.isNegative, required this.text, this.extId});
}

class TreeSurveyRepository {
  List<TreeSurveyView> treeSurveyList = [
    // 1-7
    TreeSurveyView(id: 1, section: "A", postfixString: "мес", prefixFirstString: "0", prefixSecondString: "9", title: "Беременность и роды Вашей матери", questionsList: [
      TreeSurveyItemView(
        id: 1,
        num: 1,
        title: "Беременность Вашей матери",
        isMultipleChoice: true,
        answersList: [
          TreeSurveyAnswerView(result: 1, text: "протекала легко", isGreen: true),
          TreeSurveyAnswerView(result: 2, text: "протекала сложно-сильный токсикоз", isGreen: false),
          TreeSurveyAnswerView(result: 3, text: "угроза выкидыша", isGreen: false),
          TreeSurveyAnswerView(result: 4, text: "лежала на сохранении", isGreen: false),
          TreeSurveyAnswerView(result: 5, text: "голодала", isGreen: false),
          TreeSurveyAnswerView(result: 6, text: "курила", isGreen: false),
          TreeSurveyAnswerView(result: 7, text: "употребляла алкоголь", isGreen: false),
          TreeSurveyAnswerView(result: 8, text: "наркотики", isGreen: false),
          TreeSurveyAnswerView(result: 9, text: "не знаю", isGreen: false, isShowInLine: false),
          TreeSurveyAnswerView(result: 10, text: "другое", isOther: true, isGreen: false),
        ],
      ),
      TreeSurveyItemView(
        id: 2,
        num: 2,
        title: "Проживание матери во время беременности в неблагоприятной экологической обстановке",
        isMultipleChoice: false,
        answersList: [
          TreeSurveyAnswerView(result: 1, text: "да", isGreen: false, clarifyShow: true, otherTitle: "Опишите подробности", additionalPrefixText: "-", isClarifyNumber: false),
          TreeSurveyAnswerView(result: 2, text: "нет", isGreen: true, isShowInLine: false),
          TreeSurveyAnswerView(result: 3, text: "не знаю", isGreen: false, isShowInLine: false),
        ],
      ),
      TreeSurveyItemView(id: 3, num: 3, title: "Беременность Вашей матери проходила вполне благополучно, психологически и физиологически", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(result: 1, text: "да", isGreen: true),
        TreeSurveyAnswerView(result: 2, text: "нет", isGreen: false),
        TreeSurveyAnswerView(result: 3, text: "не знаю", isGreen: false, isShowInLine: false),
        TreeSurveyAnswerView(result: 4, text: "другое", isOther: true, isGreen: false),
      ]),
      TreeSurveyItemView(id: 4, num: 4, title: "Вес Вашей матери во время беременности", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(result: 1, text: "нормальный", isGreen: true),
        TreeSurveyAnswerView(result: 2, text: "недостаточный", isGreen: false),
        TreeSurveyAnswerView(result: 3, text: "избыточный", isGreen: false),
        TreeSurveyAnswerView(result: 4, text: "ожирение", isGreen: false),
        TreeSurveyAnswerView(result: 5, text: "не знаю", isGreen: false, isShowInLine: false),
      ]),
      TreeSurveyItemView(id: 5, num: 5, title: "Были ли у Вашей матери психологические проблемы во время беременности", isMultipleChoice: true, answersList: [
        TreeSurveyAnswerView(result: 1, text: "стресс", isGreen: false),
        TreeSurveyAnswerView(result: 2, text: "расставание с партнером", isGreen: false),
        TreeSurveyAnswerView(result: 3, text: "беременность протекала без поддержки мужчины", isGreen: false),
        TreeSurveyAnswerView(result: 4, text: "беременность протекала без поддержки близких людей", isGreen: false),
        TreeSurveyAnswerView(result: 5, text: "не было", isGreen: true, isShowInLine: false),
        TreeSurveyAnswerView(result: 6, text: "не знаю", isShowInLine: false, isGreen: false),
        TreeSurveyAnswerView(result: 7, text: "другое", isOther: true, isGreen: false),
      ]),
      TreeSurveyItemView(id: 6, num: 6, title: "Роды были", isMultipleChoice: true, answersList: [
        TreeSurveyAnswerView(
            result: 1,
            text: "преждевременными",
            isGreen: false,
            clarifyShow: true,
            clarifyTitle: "Укажите срок (дней)",
            additionalPostfixText: "день",
            additionalPrefixText: "-",
            isClarifyNumber: true),
        TreeSurveyAnswerView(result: 2, text: "своевременными", isGreen: true),
        TreeSurveyAnswerView(result: 3, text: "длительными", isGreen: false),
        TreeSurveyAnswerView(result: 4, text: "стремительными", isGreen: false),
        TreeSurveyAnswerView(
            result: 5,
            text: "с задержкой рождения",
            isGreen: false,
            clarifyShow: true,
            clarifyTitle: "Укажите срок задержки (недель)",
            additionalPostfixText: "недель",
            additionalPrefixText: "-",
            isClarifyNumber: true),
        TreeSurveyAnswerView(result: 6, text: "самостоятельные", isGreen: true),
        TreeSurveyAnswerView(result: 7, text: "кесарево сечение", isGreen: false),
        TreeSurveyAnswerView(result: 8, text: "не знаю", isGreen: false, isShowInLine: false),
        TreeSurveyAnswerView(result: 9, text: "другое", isOther: true, isGreen: false),
      ]),
      TreeSurveyItemView(id: 7, num: 7, title: "Ваши особенности при рождении", isMultipleChoice: true, answersList: [
        TreeSurveyAnswerView(result: 1, text: "все нормально", isGreen: true, isShowInLine: false),
        TreeSurveyAnswerView(result: 2, text: "обвитие пуповиной", isGreen: false),
        TreeSurveyAnswerView(result: 3, text: "асфиксия", isGreen: false),
        TreeSurveyAnswerView(result: 4, text: "вывих", isGreen: false),
        TreeSurveyAnswerView(result: 5, text: "перелом", isGreen: false),
        TreeSurveyAnswerView(result: 6, text: "не знаю", isShowInLine: false, isGreen: false),
        TreeSurveyAnswerView(result: 7, text: "другое", isOther: true, isGreen: false),
      ]),
    ]),

    // 8- 19
    TreeSurveyView(id: 2, section: "Б", postfixString: "лет", prefixFirstString: "0", prefixSecondString: "6", title: "Период дошкольный (0-6 лет)", questionsList: [
      TreeSurveyItemView(id: 8, num: 1, title: "Была ли у Вашей матери послеродовая депрессия", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(result: 1, text: "да", isGreen: false),
        TreeSurveyAnswerView(result: 2, text: "нет", isGreen: true, isShowInLine: false),
        TreeSurveyAnswerView(result: 3, text: "не знаю", isShowInLine: false, isGreen: false),
      ]),
      TreeSurveyItemView(id: 9, num: 2, title: "Предпринимались ли в отношении Вас при рождении", isMultipleChoice: true, answersList: [
        TreeSurveyAnswerView(result: 1, text: "реанимационные мероприятия", isGreen: false),
        TreeSurveyAnswerView(result: 2, text: "находились ли Вы в отделении патологии новорожденных", isGreen: false),
        TreeSurveyAnswerView(result: 3, text: "содержались ли в специальном кювете для ослабленных новорожденных", isGreen: false),
        TreeSurveyAnswerView(result: 4, text: "нет", isGreen: true, isShowInLine: false),
        TreeSurveyAnswerView(result: 5, text: "не знаю", isGreen: false, isShowInLine: false),
        TreeSurveyAnswerView(result: 6, text: "другое", isOther: true, isGreen: false),
      ]),
      TreeSurveyItemView(id: 10, num: 3, title: "Вскармливание", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(
            result: 1,
            text: "грудное",
            isGreen: true,
            clarifyShow: true,
            clarifyTitle: "До какого месяца",
            additionalPostfixText: "месяца",
            additionalPrefixText: "до",
            isClarifyNumber: false),
        TreeSurveyAnswerView(result: 2, text: "искусственное", isGreen: false),
        TreeSurveyAnswerView(result: 3, text: "непереносимость каких-либо продуктов", isGreen: false, isOther: true),
        TreeSurveyAnswerView(result: 4, text: "не знаю", isGreen: false, isShowInLine: false),
      ]),
      TreeSurveyItemView(id: 11, num: 4, title: "Делались ли общепринятые прививки", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(
            result: 1,
            text: "да",
            isGreen: true,
            clarifyShow: true,
            clarifyTitle: "С какими сложностями или особенностями сталкивались от действия прививок",
            additionalPrefixText: "-",
            isClarifyNumber: false),
        TreeSurveyAnswerView(result: 2, text: "нет", isGreen: false, isShowInLine: false),
        TreeSurveyAnswerView(result: 3, text: "не знаю", isGreen: false, isShowInLine: false),
      ]),
      TreeSurveyItemView(id: 12, num: 5, title: "Развитие", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(result: 1, text: "раннее", isGreen: true),
        TreeSurveyAnswerView(result: 2, text: "позднее", isGreen: false),
        TreeSurveyAnswerView(
            result: 3, text: "трудности развития", isGreen: false, clarifyShow: true, clarifyTitle: "Опишите подробности", additionalPrefixText: "-", isClarifyNumber: false),
        TreeSurveyAnswerView(result: 4, text: "не знаю", isGreen: false, isShowInLine: false),
      ]),
      TreeSurveyItemView(id: 13, num: 6, title: "Масса тела", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(result: 1, text: "дистрофия", isGreen: false),
        TreeSurveyAnswerView(result: 2, text: "недостаток веса", isGreen: false),
        TreeSurveyAnswerView(result: 3, text: "нормальный вес", isGreen: true),
        TreeSurveyAnswerView(result: 4, text: "избыточный вес", isGreen: false),
        TreeSurveyAnswerView(result: 5, text: "ожирение", isGreen: false),
        TreeSurveyAnswerView(result: 6, text: "не знаю", isGreen: false, isShowInLine: false),
      ]),
      TreeSurveyItemView(id: 14, num: 7, title: "Перенесенные детские заболевания/операции", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(result: 1, text: "было", isGreen: false, clarifyShow: true, clarifyTitle: "Во сколько лет, какие", additionalPrefixText: "-", isClarifyNumber: false),
        TreeSurveyAnswerView(result: 2, text: "не было", isGreen: true, isShowInLine: false),
        TreeSurveyAnswerView(result: 3, text: "не знаю", isGreen: false, isShowInLine: false),
      ]),
      TreeSurveyItemView(id: 15, num: 8, title: "Физические травмы", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(result: 1, text: "было", isGreen: false, clarifyShow: true, clarifyTitle: "Во сколько лет, какие", additionalPrefixText: "-", isClarifyNumber: false),
        TreeSurveyAnswerView(result: 2, text: "не было", isGreen: true, isShowInLine: false),
        TreeSurveyAnswerView(result: 3, text: "не знаю", isGreen: false, isShowInLine: false),
      ]),
      TreeSurveyItemView(id: 16, num: 9, title: "Ходили ли Вы в", isMultipleChoice: true, answersList: [
        TreeSurveyAnswerView(result: 1, text: "ясли", isGreen: true),
        TreeSurveyAnswerView(result: 2, text: "детский сад", isGreen: true),
        TreeSurveyAnswerView(result: 3, text: "спортивные секции", isGreen: true),
        TreeSurveyAnswerView(result: 4, text: "нет", isGreen: true, isShowInLine: false),
        TreeSurveyAnswerView(result: 5, text: "не знаю", isGreen: true, isShowInLine: false),
        TreeSurveyAnswerView(result: 6, text: "другие дошкольные группы", isOther: true, isGreen: true),
      ]),
      TreeSurveyItemView(id: 17, num: 10, title: "Психотравмирующие события", isMultipleChoice: true, answersList: [
        TreeSurveyAnswerView(result: 1, text: "развод родителей", isGreen: false),
        TreeSurveyAnswerView(result: 2, text: "смерть родственника", isGreen: false),
        TreeSurveyAnswerView(result: 3, text: "насилие в семье", isGreen: false),
        TreeSurveyAnswerView(result: 4, text: "пребывание в Доме ребенка", isGreen: false),
        TreeSurveyAnswerView(result: 5, text: "пребывание в приюте", isGreen: false),
        TreeSurveyAnswerView(result: 6, text: "пребывание в интернате", isGreen: false),
        TreeSurveyAnswerView(result: 7, text: "пребывание в приемной семье", isGreen: false),
        TreeSurveyAnswerView(result: 8, text: "не было", isGreen: true, isShowInLine: false),
        TreeSurveyAnswerView(result: 9, text: "не знаю", isGreen: false, isShowInLine: false),
        TreeSurveyAnswerView(result: 10, text: "другое", isOther: true, isGreen: false),
      ]),
      TreeSurveyItemView(id: 18, num: 11, title: "Проживание в неблагоприятной экологической обстановке", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(result: 1, text: "да", isGreen: false, clarifyShow: true, clarifyTitle: "Опишите подробности", additionalPrefixText: "-", isClarifyNumber: false),
        TreeSurveyAnswerView(result: 2, text: "нет", isGreen: true, isShowInLine: false),
        TreeSurveyAnswerView(result: 3, text: "не знаю", isGreen: false, isShowInLine: false),
      ]),
      TreeSurveyItemView(id: 19, num: 12, title: "Помните ли Вы успехи, достижения, награды, другие значимые приятные события", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(result: 1, text: "да", isGreen: true, clarifyShow: true, clarifyTitle: "Опишите подробности", additionalPrefixText: "-", isClarifyNumber: false),
        TreeSurveyAnswerView(result: 2, text: "нет", isGreen: false, isShowInLine: false),
        TreeSurveyAnswerView(result: 3, text: "не знаю", isGreen: false, isShowInLine: false),
      ]),
    ]),

    // 20-29
    TreeSurveyView(
        id: 3,
        section: "В",
        postfixString: "лет",
        prefixFirstString: "6\n(7)",
        prefixSecondString: "16\n(17)",
        title: "Школьный период (с 6-7 лет до 16-17 лет)",
        questionsList: [
          TreeSurveyItemView(id: 20, num: 1, title: "Учеба давалась Вам", isMultipleChoice: true, answersList: [
            TreeSurveyAnswerView(result: 1, text: "легко", isGreen: true),
            TreeSurveyAnswerView(result: 2, text: "трудно", isGreen: false),
            TreeSurveyAnswerView(result: 3, text: "была психотравмирующим мероприятием", isGreen: false),
            TreeSurveyAnswerView(result: 4, text: "учились в школе для детей с особенностями развития", isGreen: false),
            TreeSurveyAnswerView(result: 5, text: "другое", isOther: true, isGreen: false),
          ]),
          TreeSurveyItemView(id: 21, num: 2, title: "Возникали ли у Вас конфликты с другими учениками, учителями", isMultipleChoice: false, answersList: [
            TreeSurveyAnswerView(result: 1, text: "никогда", isGreen: true),
            TreeSurveyAnswerView(result: 2, text: "иногда", isGreen: false),
            TreeSurveyAnswerView(result: 3, text: "часто", isGreen: false),
            TreeSurveyAnswerView(result: 4, text: "всегда", isGreen: false),
          ]),
          TreeSurveyItemView(id: 22, num: 3, title: "Масса тела", isMultipleChoice: false, answersList: [
            TreeSurveyAnswerView(result: 1, text: "дистрофия", isGreen: false),
            TreeSurveyAnswerView(result: 2, text: "недостаток веса", isGreen: false),
            TreeSurveyAnswerView(result: 3, text: "нормальный вес", isGreen: true),
            TreeSurveyAnswerView(result: 4, text: "избыточный вес", isGreen: false),
            TreeSurveyAnswerView(result: 5, text: "ожирение", isGreen: false),
          ]),
          TreeSurveyItemView(id: 23, num: 4, title: "Перенесенные заболевания/операции в этот период", isMultipleChoice: false, answersList: [
            TreeSurveyAnswerView(
                result: 1, text: "было", isGreen: false, clarifyShow: true, clarifyTitle: "Во сколько лет, какие", additionalPrefixText: "-", isClarifyNumber: false),
            TreeSurveyAnswerView(result: 2, text: "не было", isGreen: true, isShowInLine: false),
          ]),
          TreeSurveyItemView(id: 24, num: 5, title: "Травмы, полученные в этот период", isMultipleChoice: false, answersList: [
            TreeSurveyAnswerView(
                result: 1, text: "было", isGreen: false, clarifyShow: true, clarifyTitle: "Во сколько лет, какие", additionalPrefixText: "-", isClarifyNumber: false),
            TreeSurveyAnswerView(result: 2, text: "не было", isGreen: true, isShowInLine: false),
          ]),
          TreeSurveyItemView(id: 25, num: 6, title: "Посещали ли в этот период", isMultipleChoice: true, answersList: [
            TreeSurveyAnswerView(result: 1, text: "спортивные секции", isGreen: true),
            TreeSurveyAnswerView(result: 2, text: "музыкальную школу", isGreen: true),
            TreeSurveyAnswerView(result: 3, text: "детского психолога", isGreen: true),
            TreeSurveyAnswerView(result: 4, text: "нет", isGreen: true, isShowInLine: false),
            TreeSurveyAnswerView(result: 5, text: "другие образовательные и развивающие проекты", isOther: true, isGreen: true),
          ]),
          TreeSurveyItemView(id: 26, num: 7, title: "Психотравмирующие события", isMultipleChoice: true, answersList: [
            TreeSurveyAnswerView(result: 1, text: "развод родителей", isGreen: false),
            TreeSurveyAnswerView(result: 2, text: "смерть родственника", isGreen: false),
            TreeSurveyAnswerView(result: 3, text: "насилие в семье", isGreen: false),
            TreeSurveyAnswerView(result: 4, text: "нахождение в интернате", isGreen: false),
            TreeSurveyAnswerView(result: 5, text: "нахождение в семье с приемными родителями", isGreen: false),
            TreeSurveyAnswerView(result: 6, text: "не было", isGreen: true, isShowInLine: false),
            TreeSurveyAnswerView(result: 7, text: "другое", isOther: true, isGreen: false),
          ]),
          TreeSurveyItemView(id: 27, num: 8, title: "Зависимости", isMultipleChoice: true, answersList: [
            TreeSurveyAnswerView(result: 1, text: "алкогольная", isGreen: false),
            TreeSurveyAnswerView(result: 2, text: "табакокурение", isGreen: false),
            TreeSurveyAnswerView(result: 3, text: "наркотики", isGreen: false),
            TreeSurveyAnswerView(result: 4, text: "игровая", isGreen: false),
            TreeSurveyAnswerView(result: 5, text: "интернет", isGreen: false),
            TreeSurveyAnswerView(result: 6, text: "пищевая", isGreen: false),
            TreeSurveyAnswerView(result: 7, text: "нет", isGreen: true, isShowInLine: false),
            TreeSurveyAnswerView(result: 8, text: "другое", isOther: true, isGreen: false),
          ]),
          TreeSurveyItemView(id: 28, num: 9, title: "Проживание в неблагоприятной экологической обстановке", isMultipleChoice: false, answersList: [
            TreeSurveyAnswerView(result: 1, text: "да", isGreen: false, clarifyTitle: "Опишите подробности", clarifyShow: true, additionalPrefixText: "-", isClarifyNumber: false),
            TreeSurveyAnswerView(result: 2, text: "нет", isGreen: true, isShowInLine: false),
          ]),
          TreeSurveyItemView(id: 29, num: 10, title: "Помните ли Вы успехи, достижения, награды и другие значимые приятные события", isMultipleChoice: false, answersList: [
            TreeSurveyAnswerView(result: 1, text: "да", isGreen: true, clarifyTitle: "Опишите подробности", clarifyShow: true, additionalPrefixText: "-", isClarifyNumber: false),
            TreeSurveyAnswerView(result: 2, text: "нет", isGreen: true, isShowInLine: false),
          ]),
        ]),

    // 30-37
    TreeSurveyView(id: 4, postfixString: "лет", prefixFirstString: "18", prefixSecondString: "...", section: "Г", title: "Период взрослой жизни (с 18 лет)", questionsList: [
      TreeSurveyItemView(id: 30, num: 1, title: "Значимые события в жизни", isMultipleChoice: true, answersList: [
        TreeSurveyAnswerView(
            result: 1,
            isGreen: true,
            text: "вступление в брак, в т.ч., в гражданский",
            clarifyShow: true,
            additionalPrefixText: "- в",
            additionalPostfixText: "лет",
            clarifyTitle: "Во сколько лет",
            isClarifyNumber: true),
        TreeSurveyAnswerView(
            result: 2,
            isGreen: true,
            text: "рождение детей",
            clarifyTitle: "Во сколько лет, кого",
            clarifyShow: true, additionalPrefixText: "-", isClarifyNumber: false),
        TreeSurveyAnswerView(
            result: 3,
            isGreen: true,
            text: "получение образования",
            clarifyShow: true,
            clarifyTitle: "Во сколько лет, какое(ие)",
            additionalPrefixText: "-",
            isClarifyNumber: false),
        TreeSurveyAnswerView(result: 4, isGreen: true, isShowInLine: false, text: "не было"),
        TreeSurveyAnswerView(result: 5, isGreen: true, text: "другое", isOther: true, otherTitle: "Во сколько лет, какое(ие)"),
      ]),
      TreeSurveyItemView(id: 31, num: 2, title: "Перенесенные заболевания/операции в этот период", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(
            result: 1,
            text: "было",
            isGreen: false,
            clarifyShow: true,
            clarifyTitle: "Во сколько лет, какие", additionalPrefixText: "-", isClarifyNumber: false),
        TreeSurveyAnswerView(result: 2, text: "не было", isGreen: true, isShowInLine: false),
      ]),
      TreeSurveyItemView(id: 32, num: 3, title: "Возрастные гормональные изменения", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(
            result: 1,
            text: "климакс",
            isGreen: false,
            clarifyShow: true,
            clarifyTitle: "Во сколько лет",
            additionalPrefixText: "- в",
            additionalPostfixText: "лет",
            isClarifyNumber: true
        ),
        TreeSurveyAnswerView(
            result: 2,
            text: "искуственный климакс, в т.ч., вызванный удалением репродуктивных органов",
            isGreen: false,
            additionalPrefixText: "- в",
            additionalPostfixText: "лет",
            isClarifyNumber: true,
            clarifyShow: true,
            clarifyTitle: "Во сколько лет"),
        TreeSurveyAnswerView(result: 3, text: "не было", isGreen: true, isShowInLine: false),
      ]),
      TreeSurveyItemView(id: 33, num: 4, title: "Физические травмы, полученные в этот период", isMultipleChoice: false, answersList: [
        TreeSurveyAnswerView(
            result: 1,
            text: "было",
            isGreen: false,
            clarifyShow: true,
            clarifyTitle: "Во сколько лет, какие", additionalPrefixText: "-", isClarifyNumber: false),
        TreeSurveyAnswerView(result: 2, text: "не было", isGreen: true, isShowInLine: false),
      ]),
      TreeSurveyItemView(id: 34, num: 5, title: "Психотравмирующие события", isMultipleChoice: true, answersList: [
        TreeSurveyAnswerView(result: 1, isGreen: false, text: "развод", clarifyShow: true, clarifyTitle: "Во сколько лет", additionalPrefixText: "- в",
            additionalPostfixText: "лет",
            isClarifyNumber: true),
        TreeSurveyAnswerView(
            result: 2, isGreen: false, text: "смерть родственника", clarifyShow: true, clarifyTitle: "Во сколько лет, кого", additionalPrefixText: "-", isClarifyNumber: false),
        TreeSurveyAnswerView(
            result: 3, isGreen: false, text: "насилие в семье", clarifyShow: true, clarifyTitle: "Во сколько лет", additionalPrefixText: "- в",
            additionalPostfixText: "лет",
            isClarifyNumber: true),
        TreeSurveyAnswerView(result: 4, text: "не было", isGreen: true, isShowInLine: false),
        TreeSurveyAnswerView(result: 5, text: "другое", isOther: true, isGreen: false),
      ]),
      TreeSurveyItemView(id: 35, num: 6, title: "Зависимости", isMultipleChoice: true, answersList: [
        TreeSurveyAnswerView(result: 1, isGreen: false, text: "алкогольная"),
        TreeSurveyAnswerView(result: 2, isGreen: false, text: "табакокурение"),
        TreeSurveyAnswerView(result: 3, isGreen: false, text: "наркотики"),
        TreeSurveyAnswerView(result: 4, isGreen: false, text: "игровая"),
        TreeSurveyAnswerView(result: 5, isGreen: false, text: "интернет"),
        TreeSurveyAnswerView(result: 6, isGreen: false, text: "пищевая"),
        TreeSurveyAnswerView(result: 7, isGreen: true, text: "нет", isShowInLine: false),
        TreeSurveyAnswerView(result: 8, isGreen: false, text: "другое", isOther: true),
      ]),
      TreeSurveyItemView(id: 36, num: 7, title: "Проживание в неблагоприятной экологической обстановке", isMultipleChoice: true, answersList: [
        TreeSurveyAnswerView(result: 1, text: "да", isGreen: false, clarifyTitle: "Опишите подробности", additionalPrefixText: "-", clarifyShow: true, isClarifyNumber: false),
        TreeSurveyAnswerView(result: 2, text: "нет", isGreen: true, isShowInLine: false),
      ]),
      TreeSurveyItemView(
          id: 37, num: 8, title: "Ваши успехи, достижения, награды, другие значимые приятные события", isMultipleChoice: false, isOneQuestion: true, answersList: []),
    ]),
  ];
}
