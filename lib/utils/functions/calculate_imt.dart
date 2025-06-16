import 'package:garnetbook/utils/functions/date_formating_functions.dart';

class ImtCalculation {
  int calculateAge(String bday) {
    DateTime birthDate = DateTime.parse(bday);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  double calculateImt(double weight, double height) {
    return weight / (height * height);
  }

  double getIdealImt(int age, int gender) {
    //Мужской пол
    if (gender == 1) {
      if (age <= 24) {
        return 21.4;
      } else if (age >= 25 && age <= 34) {
        return 21.6;
      } else if (age >= 35 && age <= 44) {
        return 22.9;
      } else if (age >= 45 && age <= 54) {
        return 25.8;
      } else if (age >= 55) {
        return 26.6;
      } else {
        return 20;
      }
    }
    //Женский пол
    else {
      if (age <= 24) {
        return 19.5;
      } else if (age >= 25 && age <= 34) {
        return 23.3;
      } else if (age >= 35 && age <= 44) {
        return 23.4;
      } else if (age >= 45 && age <= 54) {
        return 25.2;
      } else if (age >= 55) {
        return 27.3;
      } else {
        return 20;
      }
    }
  }
}
