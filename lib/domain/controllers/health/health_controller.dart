import 'package:flutter/material.dart';
import 'package:flutter_health_fit/flutter_health_fit.dart';
import 'package:flutter_health_fit/workout_sample.dart';
import 'package:garnetbook/data/models/health/health_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/health/health_service.dart';
import 'package:health/health.dart';
import 'dart:io' show Platform;


class HealthServiceController {
  HealthService healthService = HealthService();
  FlutterHealthFit flutterHealthFit = FlutterHealthFit();
  Health health = Health();
  DateTime today = DateTime.now();
  final storage = SharedPreferenceData.getInstance();

  Future<List<UserHealthModel>> getBloodGlucose(DateTime date) async {
    DateTime startDate = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime endDate = DateTime(date.year, date.month, date.day, 23, 59);

    List<UserHealthModel> list = [];

    var types = [HealthDataType.BLOOD_GLUCOSE];

    final response = await healthService.fetchHealthData(types, startDate, endDate);

    if (response != [] && response != null) {
      response.forEach((element) {
        if (element.typeString == "BLOOD_GLUCOSE") {
          double userGlucose = double.parse(element.value.toJson().values.last.toString());
          double resToMl = userGlucose / 18;
          list.add(UserHealthModel(
              value: resToMl,
              dateTo: element.dateTo,
              dateFrom: element.dateFrom));
        }
      });
    }
    return list;
  }

  Future<List<UserHealthModel>> getBloodOxygen(DateTime date) async {
    DateTime startDate = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime endDate = DateTime(date.year, date.month, date.day, 23, 59);

    List<UserHealthModel> list = [];

    var types = [HealthDataType.BLOOD_OXYGEN];

    final response = await healthService.fetchHealthData(types, startDate, endDate);

    if (response != [] && response != null) {
      response.forEach((element) {
        if (element.typeString == "BLOOD_OXYGEN") {
          double userOxygen = double.parse(element.value.toJson().values.last.toString());
          list.add(
            UserHealthModel(
                value: (userOxygen.toDouble() * 100).toInt(),
                dateFrom: element.dateFrom,
                dateTo: element.dateTo),
          );
        }
      });
    }
    return list;
  }

  Future<List<UserHealthModel>> getSteps() async {
    DateTime startDate = DateTime(today.year, today.month, today.day, 0, 0);
    DateTime endDate = DateTime(today.year, today.month, today.day, 23, 59);
    List<UserHealthModel> list = [];

    var types = [HealthDataType.STEPS];

    final response = await healthService.fetchHealthData(types, startDate, endDate);

    if (response != [] && response != null) {
      response.forEach((element) {
        if (element.typeString == "STEPS") {
          double userOxygen = double.parse(element.value.toJson().values.last.toString());
          list.add(UserHealthModel(
              value: userOxygen.toInt(),
              dateFrom: element.dateFrom,
              dateTo: element.dateTo));
        }
      });
    }
    return list;
  }

  Future<int> getStepsToday() async {
    DateTime startDate = DateTime(today.year, today.month, today.day, 0, 0);
    DateTime endDate = DateTime(today.year, today.month, today.day, 23, 59);

    final steps = await health.getTotalStepsInInterval(startDate, endDate);

    return steps == null ? 0 : steps;
  }

  Future<UserHealthSteps> getStepsIndicatorsToday() async {
    DateTime startDate = DateTime(today.year, today.month, today.day, 0, 0);
    DateTime endDate = DateTime(today.year, today.month, today.day, 23, 59);
    List<double> metersList = [];
    List<double> caloriesList = [];

    double calories = 0;
    double meters = 0;

    if (Platform.isAndroid) {
      var types = [
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.DISTANCE_DELTA
      ];

      final response = await healthService.fetchHealthData(types, startDate, endDate);

      if (response != null && response.isNotEmpty) {
        response.forEach((element) {
          if (element.typeString == "DISTANCE_DELTA") {
            double valueDistance = double.parse(element.value.toJson().values.last.toString());
            metersList.add(valueDistance);
          }

          else if (element.typeString == "ACTIVE_ENERGY_BURNED") {
            double valueCalories = double.parse('${element.value.toJson().values.last}');
            debugPrint("CALORIES: ${valueCalories}");
            caloriesList.add(valueCalories);
          }
        });
      }


      if (caloriesList.isNotEmpty) {
        caloriesList.forEach((element) {
          calories = element + calories;
        });
      }
      if (metersList.isNotEmpty) {
        metersList.forEach((element) {
          meters = meters + element;
        });
      }

      return UserHealthSteps(
        distance: meters / 1000,
        calorie: calories.floorToDouble().toInt(),
        dateTo: startDate,
        dateFrom: endDate,
      );
    }
    else {
      var types = [
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.DISTANCE_WALKING_RUNNING,

      ];

      final response = await healthService.fetchHealthData(types, startDate, endDate);

      if (response != null && response.isNotEmpty) {
        response.forEach((element) {
          if (element.typeString == "DISTANCE_WALKING_RUNNING") {
            double valueDistance = double.parse(element.value.toJson().values.last.toString());
            metersList.add(valueDistance);
          } else if (element.typeString == "ACTIVE_ENERGY_BURNED") {
            double valueCalories = double.parse(element.value.toJson().values.last.toString());
            caloriesList.add(valueCalories);
          }
        });
      }

      if (caloriesList.isNotEmpty) {
        caloriesList.forEach((element) {
          calories = element + calories;
        });
      }
      if (metersList.isNotEmpty) {
        metersList.forEach((element) {
          meters = meters + element;
        });
      }

      return UserHealthSteps(
        distance: meters / 1000,
        calorie: calories.floorToDouble().toInt(),
        dateTo: startDate,
        dateFrom: endDate,
      );
    }
  }


  Future<List<UserHealthModel>> getWeight() async {
    final types = [HealthDataType.WEIGHT];
    List<UserHealthModel> list = [];
    DateTime startDate = DateTime(today.year, today.month, today.day - 20);

    final response = await healthService.fetchHealthData(types, startDate, today);

    if (response != [] && response != null) {
      response.forEach((element) {
        if (element.typeString == "WEIGHT") {
          double userWeight = double.parse(element.value.toJson().values.last.toString());

          list.add(UserHealthModel(
              value: userWeight.toInt(),
              dateFrom: element.dateFrom,
              dateTo: element.dateTo));
        }
      });
    }

    return list;
  }

  Future<List?> getSleep(startDay, endDay) async {
    final workoutsData = Platform.isIOS ?
      await flutterHealthFit.getSleepIOS(
        startDay.millisecondsSinceEpoch,
        endDay.millisecondsSinceEpoch,
      )
      : await flutterHealthFit.getSleepAndroid(
        startDay.millisecondsSinceEpoch,
        endDay.millisecondsSinceEpoch,
      );
    return workoutsData;
  }

  Future<List<WorkoutSample>?> getWorkouts(startDay, endDay) async {
    final workoutsData = await flutterHealthFit.getWorkoutsBySegment(
      startDay.millisecondsSinceEpoch,
      endDay.millisecondsSinceEpoch,
    );
    return workoutsData;
  }

  Future<List<UserHealthPressure>> getPressure(DateTime date) async {
    DateTime startDate = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime endDate = DateTime(date.year, date.month, date.day, 23, 59);

    var types = [
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.HEART_RATE
    ];

    final response = await healthService.fetchHealthData(types, startDate, endDate);

    List<UserHealthPressure> list = [];

    if (response != [] && response != null) {
      response.forEach((element) {

        if(list.isNotEmpty){
          bool isExist = list.any((item) => item.dateFrom == element.dateFrom && item.dateTo == element.dateTo);

          if(isExist){
            for(var item in list){
              if(item.dateFrom == element.dateFrom && item.dateTo == element.dateTo){

                if(element.typeString == "BLOOD_PRESSURE_DIASTOLIC"){
                  item.diastolic = double.parse(element.value.toJson().values.last.toString());
                }
                else if(element.typeString == "BLOOD_PRESSURE_SYSTOLIC"){
                  item.systolic = double.parse(element.value.toJson().values.last.toString());
                }
                break;
              }
            }
          }
          else{
            list.add(UserHealthPressure(
                pulse: element.typeString == "HEART_RATE" ? double.parse(element.value.toJson().values.last.toString()) : 0,
                dateFrom: element.dateFrom,
                dateTo: element.dateTo,
                diastolic: element.typeString == "BLOOD_PRESSURE_DIASTOLIC" ? double.parse(element.value.toJson().values.last.toString()) : 0,
                systolic: element.typeString == "BLOOD_PRESSURE_SYSTOLIC" ? double.parse(element.value.toJson().values.last.toString()) : 0)
            );
          }
        }
        else{
          list.add(UserHealthPressure(
              pulse: element.typeString == "HEART_RATE" ? double.parse(element.value.toJson().values.last.toString()) : 0,
              dateFrom: element.dateFrom,
              dateTo: element.dateTo,
              diastolic: element.typeString == "BLOOD_PRESSURE_DIASTOLIC" ? double.parse(element.value.toJson().values.last.toString()) : 0,
              systolic: element.typeString == "BLOOD_PRESSURE_SYSTOLIC" ? double.parse(element.value.toJson().values.last.toString()) : 0)
          );
        }

      });
    }

    if(list.isNotEmpty){
      list.sort((a,b) {
        return a.dateTo.compareTo(b.dateTo);
      });
    }

    return list;
  }


  Future<bool> addBloodGlucose(double item, DateTime dateStart, DateTime dateEnd) async {
    try {
      bool response = await health.writeHealthData(
          value: item,
          type: HealthDataType.BLOOD_GLUCOSE,
          startTime: dateStart,
          endTime: dateEnd);

      if (response) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> addPressure(int systolic, int diastolic, DateTime dateStart, DateTime dateEnd) async {
    try {
      bool response = await health.writeBloodPressure(
        systolic: systolic,
        diastolic: diastolic,
        startTime: dateStart,
        endTime: dateEnd
      );

      if (response) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> addPulse(double item, DateTime dateStart, DateTime dateEnd) async {
    try {
      bool response = await health.writeHealthData(
        value: item,
        type: HealthDataType.HEART_RATE,
        startTime: dateStart,
        endTime: dateEnd);

      if (response) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> addBloodOxygen(double item, DateTime dateStart, DateTime dateEnd) async {
    final earlier = dateEnd.subtract(Duration(minutes: 10));
    try {
      bool response = await health.writeBloodOxygen(
              saturation: item,
              startTime: earlier,
              endTime: dateEnd);

      if (response) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> addWeight(double item, DateTime dateStart, DateTime dateEnd) async {
    try {
      bool response = await health.writeHealthData(
         value: item,
         type: HealthDataType.WEIGHT,
         startTime: dateStart,
         endTime: dateEnd);

      if (response) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
