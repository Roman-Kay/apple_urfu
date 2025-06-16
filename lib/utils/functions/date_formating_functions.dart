import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatting{

  // форматы дат с точкой
  DateFormat dateFormat = DateFormat("dd.MM.yyyy");
  DateFormat timeFormat = DateFormat('HH:mm');
  DateFormat dateAndTimeFormat = DateFormat('dd.MM.yyyy HH:mm');
  DateFormat dateAndTimeFormatWSeconds = DateFormat('dd.MM.yyyy HH:mm:ss');

  // форматы дат через тире
  DateFormat dateISOFormat = DateFormat('yyyy-MM-dd');
  DateFormat dateISOFormatWithTime = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateFormat dateISOTimezoneFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

  // форматы дат, с развернутым месяцем => 5 мая 2021
  DateFormat dateFormatRU = DateFormat('d MMMM', 'ru_RU');
  DateFormat dateFormatRUwithYear = DateFormat('d MMMM yyyy', 'ru_RU');
  DateFormat dateFormatRUwithTime = DateFormat('d MMMM yyyy, HH:mm', 'ru_RU');


  ////////////////////////////////////////////     получаем с бэкенда, используем в приложении

  // если нужно получить String в формате "dd.MM.yyyy"  =>  принимает параметр в формате String или DateTime
  //    из этого "2023-05-29 16:58:00.000"   ==>  в это "29.05.2023" ==>> из формата ISO с тире, в формат с точками
  //    исп. при получении даты из бэкенда и выведении на экран приложения
  String formatDate(dynamic date){
    if(date is String){
      var date1 = DateTime.parse(date);
      return dateFormat.format(date1);
    }else{
      return dateFormat.format(date);
    }
  }

  // если нужно получить String в формате "HH:mm"  =>  принимает параметр в формате String или DateTime
  //    из этого "2023-05-29 16:58:00.000"   ==>  в это "16:58" ==>> из формата ISO с тире, в формат с точками
  //    исп. при получении даты из бэкенда и выведении на экран приложения
  String formatTime(dynamic time){
    if(time is String){
      var date1 = DateTime.parse(time);
      return timeFormat.format(date1);
    }else{
      return timeFormat.format(time);
    }
  }


  // если нужно получить String в формате "d MMMM', 'ru_RU"  =>  принимает параметр в формате String или DateTime
  //       !!!!  принимает параметр в формате ISO через тире, формат с точкой не принимает !!!!
  //    из этого "2023-05-29 16:58:00.000"   ==>  в это "29 May"
  //    исп. при получении даты из бэкенда и выведении на экран приложения
  String formatDateRU(dynamic date){
    if(date is String){
      var date1 = DateTime.parse(date);
      return dateFormatRU.format(date1);
    }else{
      return dateFormatRU.format(date);
    }
  }


  // если нужно получить String в формате "d MMMM yyyy', 'ru_RU"  =>  принимает параметр в формате String или DateTime
  //       !!!!  принимает параметр в формате ISO через тире, формат с точкой не принимает !!!!
  //    из этого "2023-05-29 16:58:00.000"   ==>  в это "29 May 2023"
  //    исп. при получении даты из бэкенда и выведении на экран приложения
  String formatDateRUWithYear(dynamic date){
    if(date is String){
      var date1 = DateTime.parse(date);
      return dateFormatRUwithYear.format(date1);
    }else{
      return dateFormatRUwithYear.format(date);
    }
  }


  // если нужно получить String в формате "d MMMM yyyy, HH:mm', 'ru_RU"  =>  принимает параметр в формате String или DateTime
  //       !!!!  принимает параметр в формате ISO через тире, формат с точкой не принимает !!!!
  //    из этого "2023-05-29 16:58:00.000"   ==>  в это "29 May 2023, 16:58"
  //    если время не было указано, поставит сам время ==>> из этого "2023-05-29" ==>  в это "29 May 2023, 00:00"
  //    исп. при получении даты из бэкенда и выведении на экран приложения
  String formatDateRUWithTime(dynamic date){
    if(date is String){
      var date1 = DateTime.parse(date);
      return dateFormatRUwithTime.format(date1);
    }else{
      return dateFormatRUwithTime.format(date);
    }
  }




  ////////////////////////////////////////////     оправляем на бэкенд


  // если нужно получить String в формате "yyyy-MM-dd"  =>  принимает параметр в формате String
  //  передаем только дату без времени
  //       !!!!  принимает параметр в формате с точкой, в формате с развернутым месяцем не принимает !!!!
  //  из этого "30.05.2023"   ==>  в это "2023-05-30" ==>> из формата с точками, в формат ISO с тире
  String formatISODate(dynamic date){
    if(date is String){
      var date1 = dateAndTimeFormat.parse('$date 00:00');
      return dateISOFormat.format(date1);
    }else{
      return dateISOFormat.format(date);
    }
  }


  // если нужно получить String в формате "yyyy-MM-dd HH:mm:ss"  =>  принимает параметр в формате String
  //       !!!!  принимает параметр в формате с точкой, в формате с развернутым месяцем не принимает !!!!
  //  из этого "30.05.2023 05:55:00"   ==>  в это "2023-05-30 05:55:00" ==>> из формата с точками, в формат ISO с тире
  String formatISODateWithTime(String date, String time){
    var date1 = dateAndTimeFormat.parse('$date $time');
    return dateISOFormatWithTime.format(date1);
  }

  String formatISODateWithTime2(String date){
    var date1 = dateAndTimeFormat.parse(date);
    return dateISOFormatWithTime.format(date1);
  }


  // если нужен DateTime в формате "yyyy-MM-dd" => принимает только String
  //  из этого "30.05.2023"   ==>  в это "2023-05-30"
  //       !!!!  принимает параметр в формате с точкой, формат ISO не принимает !!!!
  //  похоже на formatISODate() но возвращаем DateTime, а не String
  DateTime parseDate(String date){
    return dateFormat.parse(date);
  }

  // если нужен DateTime в формате "yyyy-MM-dd HH:mm:ss.SSS" => принимает только String
  //  из этого "30.05.2023"   ==>  в это "2023-05-30 05:55:00.000"
  //       !!!!  принимает параметр в формате с точкой, формат ISO не принимает !!!!
  //  похоже на formatISODate() но возвращаем DateTime, а не String
  DateTime parseDateAndTime(String date, String time){
    var date1 = "$date $time";
    return dateAndTimeFormat.parse(date1);
  }


  // если нужно получить String в формате "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"  =>  принимает параметр в формате String
  String formatDateAndTime(String date, String time){
    var date1 = '$date $time:00';
    DateTime parseDate = dateAndTimeFormatWSeconds.parse(date1);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputDate = dateISOTimezoneFormat.format(inputDate);
    return outputDate;
  }



  ////////////////////////////////////////////     текущие даты

  // получить текущую дату в формате "dd.MM.yyyy"
  String getNowDate(){
    return dateFormat.format(DateTime.now());
  }

  // получить текущее время в формате "HH:mm"
  String getNowTime(){
    return DateFormat.Hm().format(DateTime.now());
  }

  // получить текущую дату и время в формате "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
  String getDateISOTimezoneNow(){
    return dateISOTimezoneFormat.format(DateTime.now());
  }
}
