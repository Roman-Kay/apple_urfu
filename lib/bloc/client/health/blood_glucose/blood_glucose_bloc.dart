import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

part 'blood_glucose_state.dart';
part 'blood_glucose_event.dart';

class BloodGlucoseBloc extends Bloc<BloodGlucoseEvent, BloodGlucoseState> {
  BloodGlucoseBloc() : super(BloodGlucoseInitialState()) {
    on<BloodGlucoseGetEvent>(_get);
    on<BloodGlucoseUpdateEvent>(_update);
    on<BloodGlucoseConnectedEvent>(_connected);
  }

  final service = SensorsService();
  HealthServiceController healthController = HealthServiceController();
  Health health = Health();

  Future<void> _update(BloodGlucoseUpdateEvent event, Emitter<BloodGlucoseState> emit) async {

    final requested = Platform.isIOS
        ? await health.requestAuthorization([HealthDataType.BLOOD_GLUCOSE], permissions: [HealthDataAccess.READ_WRITE])
        : await health.hasPermissions([HealthDataType.BLOOD_GLUCOSE], permissions: [HealthDataAccess.READ_WRITE]);

    emit(BloodGlucoseLoadingState());

    final response = await service.getSensorsForHours(ClientSensorHoursRequest(
        healthSensorId: 6,
        date: DateFormat("yyyy-MM-dd").format(event.date)));

    if(event.value != null){
      event.value!.select(requested ?? false);
    }

    if (response.result) {
      emit(BloodGlucoseLoadedState(
          currentVal: response.value?.currentVal,
          list: response.value?.clientSensors,
          date: event.date,
          isRequested: requested ?? false));
    }
    else {
      emit(BloodGlucoseErrorState());
    }
  }

  Future<void> _get(BloodGlucoseGetEvent event, Emitter<BloodGlucoseState> emit) async {
    final requested = Platform.isIOS
        ? await health.requestAuthorization([HealthDataType.BLOOD_GLUCOSE], permissions: [HealthDataAccess.READ_WRITE])
        : await health.hasPermissions([HealthDataType.BLOOD_GLUCOSE], permissions: [HealthDataAccess.READ_WRITE]);

    double? valueFromFit;
    DateTime? dateFromFit;

    emit(BloodGlucoseLoadingState());

    if(event.value != null){
      event.value!.select(requested ?? false);
    }

    if (requested == true) {
      final valueResponse = await healthController.getBloodGlucose(event.date);

      if (valueResponse.isNotEmpty) {
        valueFromFit = Platform.isIOS ? valueResponse.first.value!.toDouble() : valueResponse.last.value!.toDouble();
        dateFromFit = Platform.isIOS ? valueResponse.first.dateTo : valueResponse.last.dateTo;
      }
    }

    final response = await service.getSensorsForHours(ClientSensorHoursRequest(healthSensorId: 6, date: DateFormat("yyyy-MM-dd").format(event.date)));

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
          emit(BloodGlucoseLoadedState(
              currentVal: response.value?.currentVal,
              list: response.value?.clientSensors,
              date: event.date,
              isRequested: requested ?? false));
        }
        else {
          final serviceResponse = await service.createSensorsMeasurement(
            CreateClientSensorsRequest(
              healthSensorId: 6,
              healthSensorVal: valueFromFit.toDouble(),
              dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(dateFromFit),
            ),
          );

          if (serviceResponse.result) {
            final valueRequestSecondTime = await service.getSensorsForHours(ClientSensorHoursRequest(
                healthSensorId: 6,
                date: DateFormat("yyyy-MM-dd").format(event.date)));

            if (valueRequestSecondTime.result) {
              emit(BloodGlucoseLoadedState(
                  currentVal: valueRequestSecondTime.value?.currentVal,
                  list: valueRequestSecondTime.value?.clientSensors,
                  date: event.date,
                  isRequested: requested ?? false));
            }
            else {
              emit(BloodGlucoseErrorState());
            }
          }
          else {
            emit(BloodGlucoseErrorState());
          }
        }
      }
      else {
        emit(BloodGlucoseLoadedState(
            currentVal: response.value?.currentVal,
            list: response.value?.clientSensors,
            date: event.date,
            isRequested: requested ?? false));
      }
    }
    else {
      emit(BloodGlucoseErrorState());
    }
  }


  Future<void> _connected(BloodGlucoseConnectedEvent event, Emitter<BloodGlucoseState> emit) async {
    final requested = await health.requestAuthorization([HealthDataType.BLOOD_GLUCOSE],
        permissions: [HealthDataAccess.READ_WRITE]);

    if(event.value != null){
      event.value!.select(requested ?? false);
    }

    if (requested == true) {
      emit(BloodGlucoseLoadingState());

      double? valueFromFit;
      DateTime? dateFromFit;

      final valueResponse = await healthController.getBloodGlucose(event.date);

      if (valueResponse.isNotEmpty) {
        valueFromFit = Platform.isIOS ? valueResponse.first.value!.toDouble() : valueResponse.last.value!.toDouble();
        dateFromFit = Platform.isIOS ? valueResponse.first.dateTo : valueResponse.last.dateTo;
      }

      final response = await service.getSensorsForHours(ClientSensorHoursRequest(
          healthSensorId: 6,
          date: DateFormat("yyyy-MM-dd").format(event.date)));

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
            emit(BloodGlucoseLoadedState(
                currentVal: response.value?.currentVal, list: response.value?.clientSensors, date: event.date, isRequested: requested ?? false));
          } else {
            final serviceResponse = await service.createSensorsMeasurement(
              CreateClientSensorsRequest(
                healthSensorId: 6,
                healthSensorVal: valueFromFit.toDouble(),
                dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(dateFromFit),
              ),
            );

            if (serviceResponse.result) {
              final valueRequestSecondTime =
                  await service.getSensorsForHours(ClientSensorHoursRequest(healthSensorId: 6, date: DateFormat("yyyy-MM-dd").format(event.date)));

              if (valueRequestSecondTime.result) {
                emit(BloodGlucoseLoadedState(
                    currentVal: valueRequestSecondTime.value?.currentVal,
                    list: valueRequestSecondTime.value?.clientSensors,
                    date: event.date,
                    isRequested: requested ?? false));
              } else {
                emit(BloodGlucoseErrorState());
              }
            } else {
              emit(BloodGlucoseErrorState());
            }
          }
        } else {
          emit(BloodGlucoseLoadedState(
              currentVal: response.value?.currentVal, list: response.value?.clientSensors, date: event.date, isRequested: requested ?? false));
        }
      } else {
        emit(BloodGlucoseErrorState());
      }
    }
    else {
      emit(BloodGlucoseNotConnectedState());
    }
  }
}
