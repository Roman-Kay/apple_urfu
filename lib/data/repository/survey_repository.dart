
class SurveyRepository{

  int getFirstSurvey(int topicId){
    int id = 0;
    switch (topicId){
      case 1:    // 'Сбросить вес'
        id = 39;
        break;
      case 2:    //'Antyage'
        id = 40;
        break;
      case 3:   //'Поднять энергию'
        id = 23;
        break;
      case 4:   // 'Ментальное здоровье'
        id = 42;
        break;
      case 5:   // 'Здоровая система ЖКТ'
        id = 1;
        break;
      case 6:   // 'Мужское здоровье'
        id = 19;
        break;
      case 7:   // 'Женское здоровье'
        id = 20;
        break;
      case 8:
        id = 36;   // 'Набрать вес' от 1  до 5 кг
        break;
      case 9:     // 'Набрать вес' от 5 кг
        id = 15;
        break;

    }
    return id;
  }
}

