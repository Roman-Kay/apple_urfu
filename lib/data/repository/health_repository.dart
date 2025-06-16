import 'package:flutter/foundation.dart';

class ActivityReference{
  ActivityReference({
    required this.id,
    required this.name
});

  int id;
  String name;
}

class HealthRepository{

  List<ActivityReference> activityFromServer = [
    ActivityReference (
      id: 1,
      name: "Аэробика"
    ),
    ActivityReference(
      id: 2,
      name: 'Бадминтон',
    ),
    ActivityReference(
      id: 3,
      name: "Баскетбол",
    ),
    ActivityReference(
      id: 4,
      name: "Бег",
    ),
    ActivityReference(
      id: 6,
      name: "Биатлон",
    ),
    ActivityReference(
      id: 7,
      name: "Боевые искусства",
    ),
    ActivityReference(
      id: 8,
      name: "Бокс",
    ),
    ActivityReference(
      id: 9,
      name: "Велосипед",
    ),
    ActivityReference(
      id: 10,
      name: "Верховая езда",
    ),
    ActivityReference(
      id: 11,
      name: "Водное поло",
    ),
    ActivityReference(
      id: 12,
      name: "Волейбол",
    ),
    ActivityReference(
      id: 13,
      name: "Гандбол",
    ),
    ActivityReference(
      id: 14,
      name: "Гимнастика",
    ),
    ActivityReference(
      id: 15,
      name: "Гольф",
    ),
    ActivityReference(
      id: 16,
      name: "Зумба",
    ),
    ActivityReference(
      id: 17,
      name: "Йога",
    ),
    ActivityReference(
      id: 18,
      name: "Керлинг",
    ),
    ActivityReference(
      id: 19,
      name: "Коньки",
    ),
    ActivityReference(
      id: 20,
      name: "Кикбоксинг",
    ),
    ActivityReference(
      id: 21,
      name: "Кроссфит",
    ),
    ActivityReference(
      id: 22,
      name: "Горные лыжи",
    ),
    ActivityReference(
      id: 23,
      name: "Медитация",
    ),
    ActivityReference(
      id: 24,
      name: "Парусный спорт",
    ),
    ActivityReference(
      id: 25,
      name: "Пилатес",
    ),
    ActivityReference(
      id: 26,
      name: "Плавание",
    ),
    ActivityReference(
      id: 27,
      name: "Пляжный волейбол",
    ),
    ActivityReference(
      id: 28,
      name: "Подъем по лестнице",
    ),
    ActivityReference(
      id: 30,
      name: "Прыжки через скакалку",
    ),
    ActivityReference(
      id: 32,
      name: "Регби",
    ),
    ActivityReference(
      id: 33,
      name: "Серфинг",
    ),
    ActivityReference(
      id: 34,
      name: "Скалолазание",
    ),
    ActivityReference(
      id: 35,
      name: "Сквош",
    ),
    ActivityReference(
      id: 36,
      name: "Скейтбординг",
    ),
    ActivityReference(
      id: 37,
      name: "Сноуборд",
    ),
    ActivityReference(
      id: 38,
      name: "Танцы",
    ),
    ActivityReference(
      id: 39,
      name: "Теннис",
    ),
    ActivityReference(
      id: 40,
      name: "Тяжелая атлетика",
    ),
    ActivityReference(
      id: 41,
      name: "Фехтование",
    ),
    ActivityReference(
      id: 42,
      name: "Футбол",
    ),
    ActivityReference(
      id: 43,
      name: "Ходьба",
    ),
    ActivityReference(
      id: 44,
      name: "Хоккей",
    ),

    ActivityReference(
      id: 5,
      name: "Зарядка",
    ),
    ActivityReference(
      id: 45,
      name: "Уборка дома",
    ),
    ActivityReference(
      id: 31,
      name: "Работа на даче",
    ),
    ActivityReference(
      id: 46,
      name: "Альпинизм",
    ),
    ActivityReference(
      id: 47,
      name: "Бодифлекс",
    ),
    ActivityReference(
      id: 29,
      name: "Силовая тренировка",
    ),
    ActivityReference(
      id: 48,
      name: "Круговая тренировка",
    ),
    ActivityReference(
      id: 49,
      name: "Кардио тренировка интенсивная",
    ),
    ActivityReference(
      id: 50,
      name: "Кардио тренировка средняя",
    ),
    ActivityReference(
      id: 51,
      name: "Кардио тренировка легкая",
    ),

  ];

  List<String> activity = [
    'Аэробика',
    "Альпинизм",
    'Бадминтон',
    "Баскетбол",
    "Бег",
    "Биатлон",
    "Бодифлекс",
    "Боевые искусства",
    "Бокс",
    "Велосипед",
    "Верховая езда",
    "Водное поло",
    "Волейбол",
    "Гандбол",
    "Гимнастика",
    "Гольф",
    "Горные лыжи",
    "Зарядка",
    "Зумба",
    "Йога",
    "Кардио тренировка интенсивная",
    "Кардио тренировка средняя",
    "Кардио тренировка легкая",
    "Керлинг",
    "Коньки",
    "Кикбоксинг",
    "Кроссфит",
    "Круговая тренировка",
    "Медитация",
    "Парусный спорт",
    "Пилатес",
    "Плавание",
    "Пляжный волейбол",
    "Подъем по лестнице",
    "Прыжки через скакалку",
    "Работа на даче",
    "Регби",
    "Серфинг",
    "Силовая тренировка",
    "Скалолазание",
    "Сквош",
    "Скейтбординг",
    "Сноуборд",
    "Танцы",
    "Теннис",
    "Тяжелая атлетика",
    "Уборка дома",
    "Фехтование",
    "Футбол",
    "Ходьба",
    "Хоккей",
  ];

  double getLoadIndex(String activity){
    double index = 0;

    switch (activity){
      case "Аэробика" :
        index = 0.1;
        break;
      case "Бадминтон" :
        index = 0.079;
        break;
      case "Баскетбол" :
        index = 0.114;
        break;
      case "Бег" :
        index = 0.1409;
        break;
      case "Биатлон" :
        index = 0.134;
        break;
      case "Боевые искусства" :
        index = 0.106;
        break;
      case "Бокс" :
        index = 0.158;
        break;
      case "Велосипед" :
        index = 0.1409;
        break;
      case "Верховая езда" :
        index = 0.07;
        break;
      case "Водное поло" :
        index = 0.1759;
        break;
      case "Волейбол" :
        index = 0.053;
        break;
      case "Гандбол" :
        index = 0.211;
        break;
      case "Гимнастика" :
        index = 0.079;
        break;
      case "Гольф" :
        index = 0.097;
        break;
      case "Зумба" :
        index = 0.12;
        break;
      case "Йога" :
        index = 0.07;
        break;
      case "Керлинг" :
        index = 0.07;
        break;
      case "Коньки" :
        index = 0.12;
        break;
      case "Кикбоксинг" :
        index = 0.1;
        break;
      case "Кроссфит" :
        index = 0.14;
        break;
      case "Горные лыжи" :
        index = 0.106;
        break;
      case "Медитация" :
        index = 0.02;
        break;
      case "Парусный спорт" :
        index = 0.08;
        break;
      case "Пилатес" :
        index = 0.03;
        break;
      case "Плавание" :
        index = 0.106;
        break;
      case "Пляжный волейбол" :
        index = 0.1409;
        break;
      case "Подъем по лестнице" :
        index = 0.13;
        break;
      case "Прыжки через скакалку" :
        index = 0.17;
        break;
      case "Регби" :
        index = 0.17;
        break;
      case "Серфинг" :
        index = 0.05;
        break;
      case "Скалолазание" :
        index = 0.13;
        break;
      case "Сквош" :
        index = 0.11;
        break;
      case "Скейтбординг" :
        index = 0.08;
        break;
      case "Сноуборд" :
        index = 0.12;
        break;
      case "Танцы" :
        index = 0.1;
        break;
      case "Теннис" :
        index = 0.123;
        break;
      case "Тяжелая атлетика" :
        index = 0.15;
        break;
      case "Фехтование" :
        index = 0.106;
        break;
      case "Футбол" :
        index = 0.123;
        break;
      case "Ходьба" :
        index = 0.07;
        break;
      case "Хоккей" :
        index = 0.14;
        break;

      case "Зарядка" :
        index = 0.05;
        break;
      case "Уборка дома" :
        index = 0.079;
        break;
      case "Работа на даче" :
        index = 0.079;
        break;
      case "Альпинизм" :
        index = 0.194;
        break;
      case "Бодифлекс" :
        index = 0.166;
        break;
      case "Силовая тренировка" :
        index = 0.12;
        break;
      case "Круговая тренировка" :
        index = 0.18;
        break;
      case "Кардио тренировка интенсивная" :
        index = 0.18;
        break;
      case "Кардио тренировка средняя" :
        index = 0.123;
        break;
      case "Кардио тренировка легкая" :
        index = 0.08;
        break;
      default:
        index = 0.11;
    }
    return index;
  }



  String getActivityName(String englishName){
    String name = "";
    switch (englishName){
      case "aerobics" :
        name = 'Аэробика';
        break;
      case "badminton" :
        name = 'Бадминтон';
        break;
      case "basketball" :
        name = "Баскетбол";
        break;
      case "running" :
        name = "Бег";
        break;
      case "biathlon" :
        name = "Биатлон";
        break;
      case "martialArts" :
        name = "Боевые искусства";
        break;
      case "boxing" :
        name = "Бокс";
        break;
      case "cycling" :
        name = "Велосипед";
        break;
      case "horsebackRiding" :
        name = "Верховая езда";
        break;
      case "waterPolo" :
        name = "Водное поло";
        break;
      case "volleyball" :
        name = "Волейбол";
        break;
      case "handball" :
        name = "Гандбол";
        break;
      case "gymnastics" :
        name = "Гимнастика";
        break;
      case "golf" :
        name = "Гольф";
        break;
      case "zumba" :
        name = "Зумба";
        break;
      case "yoga" :
        name = "Йога";
        break;
      case "curling" :
        name = "Керлинг";
        break;
      case "skatingSports" :
        name = "Коньки";
        break;
      case "kickboxing" :
        name = "Кикбоксинг";
        break;
      case "crossTraining" :
        name = "Кроссфит";
        break;
      case "skiing" :
        name = "Лыжный спорт";
        break;
      case "meditation" :
        name = "Медитация";
        break;
      case "sailing" :
        name = "Парусный спорт";
        break;
      case "pilates" :
        name = "Пилатес";
        break;
      case "swimming" :
        name = "Плавание";
        break;
      case "waterPolo" :
        name = "Пляжный волейбол";
        break;
      case "stairClimbing" :
        name = "Подъем по лестнице";
        break;
      case "jumpingRope" :
        name = "Прыжки через скакалку";
        break;
      case "rugby" :
        name = "Регби";
        break;
      case "surfingSports" :
        name = "Серфинг";
        break;
      case "climbing" :
        name = "Скалолазание";
        break;
      case "squash" :
        name = "Сквош";
        break;
      case "skatingSports" :
        name = "Скейтбординг";
        break;
      case "snowboarding" :
        name = "Сноуборд";
        break;
      case "dance" :
        name = "Танцы";
        break;
      case "tennis" :
        name = "Теннис";
        break;
      case "weightlifting" :
        name = "Тяжелая атлетика";
        break;
      case "fencing" :
        name = "Фехтование";
        break;
      case "soccer" :
        name = "Футбол";
        break;
      case "walking" :
        name = "Ходьба";
        break;
      case "hockey" :
        name = "Хоккей";
        break;
      default:
        name = "";
    }
    return name;
  }
}

class RequestedValue extends ChangeNotifier{
  bool _isNotRequested = false;

  bool get isNotRequested => _isNotRequested;

  bool getValue(){
    return _isNotRequested;
  }

  void select(bool isRequested) {
    _isNotRequested = isRequested;
    notifyListeners();
  }
}


class SelectedDate extends ChangeNotifier {
  DateTime _date = DateTime.now();

  DateTime get date => _date;

  DateTime getDate(){
    return _date;
  }

  void select(DateTime newDate) {
    _date = newDate;
    notifyListeners();
  }
}

class SurveyName extends ChangeNotifier {
  String _name = "";

  String get name => _name;

  String getDate(){
    return _name;
  }

  void select(String name) {
    _name = name;
    //notifyListeners();
  }
}

class SelectedPeriod extends ChangeNotifier {
  DateTime _startDate = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  DateTime _endDate = DateTime.now();

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;


  void select(DateTime newStartDate, DateTime newEndDate) {
    _endDate = newStartDate;
    _endDate = newEndDate;
    notifyListeners();
  }
}

class SelectedBool extends ChangeNotifier {
  bool _isInit = false;

  bool get isInit => _isInit;

  bool getIsInit(){
    return _isInit;
  }

  void select(bool init) {
    _isInit = init;
    notifyListeners();
  }
}

class SelectedBool2 extends ChangeNotifier {
  bool _isInit = false;

  bool get isInit => _isInit;

  bool getIsInit(){
    return _isInit;
  }

  void select(bool init) {
    _isInit = init;
    notifyListeners();
  }
}