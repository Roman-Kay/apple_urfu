
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

import 'package:permission_handler/permission_handler.dart';

part 'health_step_state.dart';
part 'health_step_event.dart';

class HealthStepBloc extends Bloc<HealthStepEvent, HealthStepState> {
  HealthStepBloc() : super(HealthStepInitialState()) {
    on<HealthStepGetEvent>(_get);
  }

  HealthServiceController healthController = HealthServiceController();
  Health health = Health();
  final service = SensorsService();
  final storage = SharedPreferenceData.getInstance();

  Future<void> _get(HealthStepGetEvent event, Emitter<HealthStepState> emit) async {
    emit(HealthStepLoadingState());

    var permissions = [HealthDataAccess.READ, HealthDataAccess.READ, HealthDataAccess.READ];
    var iosTypes = [HealthDataType.STEPS, HealthDataType.ACTIVE_ENERGY_BURNED, HealthDataType.DISTANCE_WALKING_RUNNING];
    var androidTypes = [HealthDataType.STEPS, HealthDataType.ACTIVE_ENERGY_BURNED, HealthDataType.DISTANCE_DELTA];
    final requested = Platform.isIOS

        ? await health.requestAuthorization(iosTypes, permissions: permissions)
        : await health.hasPermissions(androidTypes, permissions: permissions);

    final isStepRequested = await Permission.activityRecognition.isGranted;

    if (!isStepRequested) {
      await Permission.activityRecognition.request();
    }

    if (requested == true) {
      var userSteps;
      int time = 0;
      var steps;
      var stepsIndicators;

      userSteps = await healthController.getStepsToday();
      stepsIndicators = await healthController.getStepsIndicatorsToday();
      steps = await healthController.getSteps();

      final response = await service.getSensorsForDay(ClientSensorDayRequest(
          healthSensorId: 1,
          dateStart: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          dateEnd: DateFormat("yyyy-MM-dd").format(DateTime.now())));

      if (response.result) {
        double distance = stepsIndicators != null && stepsIndicators.distance != 0 ? stepsIndicators.distance!.toDouble() : 0;

        if (steps != null && steps.isNotEmpty) {
          steps.forEach((element) {
            if (element.dateFrom != null && element.dateTo != null) {
              DateTime start = element.dateFrom!;
              DateTime end = element.dateTo!;

              int difference = end.difference(start).inMinutes;
              if (difference != 1) {
                time = difference + time;
              }
            }
          });
        }

        final userWeight = await storage.getItem(SharedPreferenceData.userWeightKey);
        int weight = userWeight != "" ? int.parse(userWeight) : 0;


        if (userSteps != null && userSteps != 0 && userSteps != response.value?.currentVal?.healthSensorVal) {

          final response2 = await service.createSensorsMeasurement(CreateClientSensorsRequest(
              healthSensorId: 1,
              healthSensorVal: userSteps,
              dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())));

          if (response2.result) {
            final response3 = await service.getSensorsForDay(ClientSensorDayRequest(
                healthSensorId: 1,
                dateStart: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                dateEnd: DateFormat("yyyy-MM-dd").format(DateTime.now())));

            if (response3.result) {
              int newTime = time != 0
                  ? time
                  : response3.value?.currentVal?.comment != null ? int.parse(response3.value!.currentVal!.comment!) : 0;

              int calorie = time != 0 ? (time * weight * 0.07).toInt() : 0;

              double newDistance = distance != 0
                  ? distance : response3.value?.currentVal?.health != null ? double.parse(response3.value!.currentVal!.health!)
                  : 0;

              emit(HealthStepLoadedState(
                  connected: true,
                  steps: response3.value?.currentVal?.healthSensorVal?.toInt() ?? 0,
                  calorie: calorie,
                  distance: newDistance,
                  hours: newTime));
            }
            else {
              emit(HealthStepErrorState());
            }
          }
          else {
            emit(HealthStepErrorState());
          }
        }

        else {

          int newTime = time != 0
              ? time
              : response.value?.currentVal?.comment != null ? int.parse(response.value!.currentVal!.comment!) : 0;

          int calorie = newTime != 0 ? (newTime * weight * 0.07).toInt() : 0;

          double newDistance = distance != 0
              ? distance : response.value?.currentVal?.health != null ? double.parse(response.value!.currentVal!.health!)
              : 0;

          emit(HealthStepLoadedState(
              steps: response.value?.currentVal?.healthSensorVal?.toInt() ?? 0,
              calorie: calorie,
              connected: true,
              distance: newDistance,
              hours: newTime
          ));
        }
      }
      else {
        emit(HealthStepErrorState());
      }
    }

    else{
      final response = await service.getSensorsForDay(ClientSensorDayRequest(
          healthSensorId: 1,
          dateStart: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          dateEnd: DateFormat("yyyy-MM-dd").format(DateTime.now())));

      if (response.result) {
        final userWeight = await storage.getItem(SharedPreferenceData.userWeightKey);
        int weight = userWeight != "" ? int.parse(userWeight) : 0;

        int time = response.value?.currentVal?.comment != null ? int.parse(response.value!.currentVal!.comment!) : 0;

        int calorie = time != 0 ? (time * weight * 0.07).toInt() : 0;

        emit(HealthStepLoadedState(
            steps: response.value?.currentVal?.healthSensorVal?.toInt() ?? 0,
            calorie: calorie,
            distance: response.value?.currentVal?.health != null ? double.parse(response.value!.currentVal!.health!) : 0,
            hours: time,
            connected: false
        ));
      }
      else {
        emit(HealthStepErrorState());
      }
    }


  }

}
