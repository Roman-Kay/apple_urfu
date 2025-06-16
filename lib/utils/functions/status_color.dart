
import 'package:flutter/material.dart';
import 'package:garnetbook/utils/colors.dart';

class StatusColor{

  Color getTrackerStatusColor(String? status){
    Color statusColor = Colors.transparent;

    if(status != null){
      switch (status){
        case "Новое":
          statusColor = AppColors.blueSecondaryColor;
          break;
        case "Выполняю":
          statusColor = AppColors.orangeColor;
          break;
        case "Сделано":
          statusColor = AppColors.grey60Color;
          break;
        case "В архиве":
          statusColor = AppColors.seaweedColor;
          break;
        case "Завершено":
          statusColor = AppColors.greenLightColor;
          break;
        default:
          statusColor = AppColors.blueSecondaryColor;
          break;
      }
    }
    return statusColor;
  }

  Color getStatusColor(String? status){
    Color statusColor = Colors.transparent;

    if(status != null){
      switch (status){
        case "Новое":
          statusColor = AppColors.blueSecondaryColor;
          break;
        case "Новая":
          statusColor = AppColors.blueSecondaryColor;
          break;
        case "В работе":
          statusColor = AppColors.orangeColor;
          break;
        case "Прочитано":
          statusColor = AppColors.orangeColor;
          break;
        case "На рассмотрении":
          statusColor = AppColors.orangeColor;
          break;
        case "На оформлении":
          statusColor = AppColors.orangeColor;
          break;
        case "Ожидает":
          statusColor = AppColors.orangeColor;
          break;
        case "Ожидает оплаты":
          statusColor = AppColors.orangeColor;
          break;
        case "Принята/оплачена":
          statusColor = AppColors.greenLightColor;
          break;
        case "Решена":
          statusColor = AppColors.greenLightColor;
          break;
        case "Выполнено":
          statusColor = AppColors.greenLightColor;
          break;
        case "Закрыта":
          statusColor = AppColors.seaweedColor;
          break;
        case "Просрочено":
          statusColor = AppColors.seaweedColor;
          break;
        case "Отклонена":
          statusColor = AppColors.redColor;
          break;
        case "Отказ":
          statusColor = AppColors.redColor;
          break;
        default:
          statusColor = AppColors.blueSecondaryColor;
          break;
      }
    }
    return statusColor;
  }

  Color getAdditivesStatusColor(String? status){
    Color statusColor = Colors.transparent;

    if(status != null){
      switch (status){
        case "Новая":
          statusColor = AppColors.blueSecondaryColor;
          break;
        case "Принимаю":
          statusColor = AppColors.orangeColor;
          break;
        case "Завершено":
          statusColor = AppColors.greenLightColor;
          break;
        case "В архиве":
          statusColor = AppColors.seaweedColor;
          break;
        case "Прочитано":
          statusColor = AppColors.darkGreenColor;
          break;
        case "Запланировано":
          statusColor = AppColors.purpleColor;
          break;
        case "Отказ":
          statusColor = AppColors.redColor;
          break;
        default:
          statusColor = AppColors.blueSecondaryColor;
          break;
      }
    }
    return statusColor;
  }

  String getAdditivesStatusName(int? id){
    String status = "";

    switch (id) {
      case 1:
        status = "Новое";
        break;
      case 2:
        status = "Принимаю";
        break;
      case 4:
        status = "Завершено";
        break;
      case 6:
        status = "В архиве";
        break;
      case 3:
        status = "Сделано";
        break;
      case 7:
        status = "Запланировано";
        break;
      case 5:
        status = "Отказ";
        break;
      default:
        status = "Новая";
        break;
    }
    return status;
  }

  Color getSurveyStatusColor(String? status){
    Color statusColor = Colors.transparent;

    if(status != null){
      switch (status){
        case "NEW":
          statusColor = AppColors.redColor;
          break;
        case "PASSED":
          statusColor = AppColors.greenLightColor;
          break;
        case "Пройден":
          statusColor = AppColors.greenLightColor;
          break;
        case "В процессе":
          statusColor = AppColors.orangeColor;
          break;
        default:
          statusColor = AppColors.redColor;
          break;
      }
    }
    return statusColor;
  }

  String getSurveyStatusName(String? status){
    String newStatus = "";

    switch (status) {
      case "NEW":
        newStatus = "Не пройден";
        break;
      case "PASSED":
        newStatus = "Пройден";
        break;
      case "Пройден":
        newStatus = "Пройден";
        break;
      case "В процессе":
        newStatus = "В процессе";
        break;
      default:
        newStatus = "Не пройден";
        break;
    }
    return newStatus;
  }
}

