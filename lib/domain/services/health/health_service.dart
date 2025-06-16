import 'package:flutter/material.dart';
import 'package:flutter_health_fit/flutter_health_fit.dart';
import 'package:health/health.dart';

class HealthService {
  static Health health = Health();
  final flutterHealthFit = FlutterHealthFit();

  Future<bool> isAuthHealthFit() async {
    final isAuth = await flutterHealthFit.isAuthorized();
    if (!isAuth) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> getPermissions() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.DISTANCE_WALKING_RUNNING,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.HEART_RATE,
      HealthDataType.WORKOUT,
    ];

    List<HealthDataAccess> permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ,
    ];

    await health.requestAuthorization(types, permissions: permissions);
  }

  Future<bool> isAuthHealth() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.HEART_RATE,
      HealthDataType.WORKOUT,
    ];

    List<HealthDataAccess> permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ,
    ];

    final requested = await health.requestAuthorization(types, permissions: permissions);
    if (requested == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<HealthDataPoint>?> fetchHealthData(
      List<HealthDataType> types, DateTime startDate, DateTime endDate) async {
    // List<HealthDataAccess> permissions = [];
    //
    // for(int index = 0; index < types.length; index++){
    //   permissions.add(HealthDataAccess.READ_WRITE);
    // }

    List<HealthDataPoint> healthData = [];

    try {
      healthData = await health.getHealthDataFromTypes(
        startTime: startDate,
        endTime:   endDate,
        types:   types);
      return healthData;
    } catch (e) {
      debugPrint("Error in health request ${e.toString()}");
      return null;
    }

  }
}
