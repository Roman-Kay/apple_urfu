import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

part 'blood_oxygen_state.dart';
part "blood_oxygen_event.dart";

class BloodOxygenBloc extends Bloc<BloodOxygenEvent, BloodOxygenState> {
  BloodOxygenBloc() : super(BloodOxygenState()) {
    on<BloodOxygenGetEvent>(_get);
    on<BloodOxygenUpdateEvent>(_update);
    on<BloodOxygenConnectedEvent>(_connected);
  }

  final service = SensorsService();
  HealthServiceController healthController = HealthServiceController();
  Health health = Health();

  Future<void> _update(BloodOxygenUpdateEvent event, Emitter<BloodOxygenState> emit) async {
    final requested = Platform.isIOS
        ? await health.requestAuthorization([HealthDataType.BLOOD_OXYGEN], permissions: [HealthDataAccess.READ_WRITE])
        : await health.hasPermissions([HealthDataType.BLOOD_OXYGEN], permissions: [HealthDataAccess.READ_WRITE]);

    emit(BloodOxygenLoadingState());

    if(event.value != null){
      event.value!.select(requested ?? false);
    }

    final response = await service.getSensorsForHours(ClientSensorHoursRequest(healthSensorId: 4, date: DateFormat("yyyy-MM-dd").format(event.date)));

    if (response.result) {
      emit(BloodOxygenLoadedState(
          currentVal: response.value?.currentVal, list: response.value?.clientSensors, date: event.date, isRequested: requested ?? false));
    } else {
      emit(BloodOxygenErrorState());
    }
  }

  Future<void> _get(BloodOxygenGetEvent event, Emitter<BloodOxygenState> emit) async {
    final requested = Platform.isIOS
        ? await health.requestAuthorization([HealthDataType.BLOOD_OXYGEN], permissions: [HealthDataAccess.READ_WRITE])
        : await health.hasPermissions([HealthDataType.BLOOD_OXYGEN], permissions: [HealthDataAccess.READ_WRITE]);

    int? valueFromFit;
    DateTime? dateFromFit;

    emit(BloodOxygenLoadingState());

    if(event.value != null){
      event.value!.select(requested ?? false);
    }

    if (requested == true) {
      final valueResponse = await healthController.getBloodOxygen(event.date);
      if (valueResponse.isNotEmpty) {
        valueFromFit = Platform.isIOS ? (valueResponse.first.value! * 100).toInt() : valueResponse.last.value!.toInt();
        dateFromFit = Platform.isIOS ? valueResponse.first.dateTo : valueResponse.last.dateTo;
      }
    }

    final response = await service.getSensorsForHours(ClientSensorHoursRequest(healthSensorId: 4, date: DateFormat("yyyy-MM-dd").format(event.date)));

    if (response.result) {
      if (dateFromFit != null && valueFromFit != null) {
        bool dataFitInService = false;

        if (response.value?.clientSensors != null && response.value!.clientSensors!.isNotEmpty) {
          for (var element in response.value!.clientSensors!) {
            if (element.dateSensor == dateFromFit && element.healthSensorVal == valueFromFit) {
              dataFitInService = true;
              break;
            }
            ;
          }
        }

        if (dataFitInService == true) {
          emit(BloodOxygenLoadedState(
              currentVal: response.value?.currentVal, list: response.value?.clientSensors, date: event.date, isRequested: requested ?? false));
        } else {
          final serviceResponse = await service.createSensorsMeasurement(
            CreateClientSensorsRequest(
              healthSensorId: 4,
              healthSensorVal: valueFromFit.toInt() / 100,
              dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(dateFromFit),
            ),
          );
          if (serviceResponse.result) {
            final valueRequestSecondTime =
                await service.getSensorsForHours(ClientSensorHoursRequest(healthSensorId: 4, date: DateFormat("yyyy-MM-dd").format(event.date)));

            if (valueRequestSecondTime.result) {
              emit(BloodOxygenLoadedState(
                  currentVal: valueRequestSecondTime.value?.currentVal,
                  list: valueRequestSecondTime.value?.clientSensors,
                  date: event.date,
                  isRequested: requested ?? false));
            } else {
              emit(BloodOxygenErrorState());
            }
          } else {
            emit(BloodOxygenErrorState());
          }
        }
      } else {
        emit(BloodOxygenLoadedState(
            currentVal: response.value?.currentVal, list: response.value?.clientSensors, date: event.date, isRequested: requested ?? false));
      }
    } else {
      emit(BloodOxygenErrorState());
    }
  }

  Future<void> _connected(BloodOxygenConnectedEvent event, Emitter<BloodOxygenState> emit) async {
    final requested = await health.requestAuthorization([HealthDataType.BLOOD_OXYGEN], permissions: [HealthDataAccess.READ_WRITE]);

    if(event.value != null){
      event.value!.select(requested ?? false);
    }

    if (requested == true) {
      emit(BloodOxygenLoadingState());

      int? valueFromFit;
      DateTime? dateFromFit;

      final valueResponse = await healthController.getBloodOxygen(event.date);
      if (valueResponse.isNotEmpty) {
        valueFromFit = Platform.isIOS ? (valueResponse.first.value! * 100).toInt() : valueResponse.last.value!.toInt();
        dateFromFit = Platform.isIOS ? valueResponse.first.dateTo : valueResponse.last.dateTo;
      }

      final response =
          await service.getSensorsForHours(ClientSensorHoursRequest(healthSensorId: 4, date: DateFormat("yyyy-MM-dd").format(event.date)));

      if (response.result) {
        if (dateFromFit != null && valueFromFit != null) {
          bool dataFitInService = false;

          if (response.value?.clientSensors != null && response.value!.clientSensors!.isNotEmpty) {
            for (var element in response.value!.clientSensors!) {
              if (element.dateSensor == dateFromFit && element.healthSensorVal == valueFromFit) {
                dataFitInService = true;
                break;
              }
              ;
            }
          }

          if (dataFitInService == true) {
            emit(BloodOxygenLoadedState(
                currentVal: response.value?.currentVal, list: response.value?.clientSensors, date: event.date, isRequested: requested));
          } else {
            final serviceResponse = await service.createSensorsMeasurement(
              CreateClientSensorsRequest(
                healthSensorId: 4,
                healthSensorVal: valueFromFit.toInt() / 100,
                dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(dateFromFit),
              ),
            );
            if (serviceResponse.result) {
              final valueRequestSecondTime =
                  await service.getSensorsForHours(ClientSensorHoursRequest(healthSensorId: 4, date: DateFormat("yyyy-MM-dd").format(event.date)));

              if (valueRequestSecondTime.result) {
                emit(BloodOxygenLoadedState(
                    currentVal: valueRequestSecondTime.value?.currentVal,
                    list: valueRequestSecondTime.value?.clientSensors,
                    date: event.date,
                    isRequested: requested ?? false));
              } else {
                emit(BloodOxygenErrorState());
              }
            } else {
              emit(BloodOxygenErrorState());
            }
          }
        } else {
          emit(BloodOxygenLoadedState(
              currentVal: response.value?.currentVal, list: response.value?.clientSensors, date: event.date, isRequested: requested ?? false));
        }
      } else {
        emit(BloodOxygenErrorState());
      }
    } else {
      emit(BloodOxygenNotConnectedState());
    }
  }
}
