import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

part "pressure_state.dart";
part 'pressure_event.dart';

class PressureBloc extends Bloc<PressureEvent, PressureState> {
  PressureBloc() : super(PressureInitialState()) {
    on<PressureGetEvent>(_get);
    on<PressureUpdateEvent>(_update);
    on<PressuredConnectedEvent>(_connected);
  }

  final service = SensorsService();
  HealthServiceController healthController = HealthServiceController();
  Health health = Health();

  Future<void> _update(PressureUpdateEvent event, Emitter<PressureState> emit) async {
    List<HealthDataType> healthDataType = [HealthDataType.BLOOD_PRESSURE_DIASTOLIC, HealthDataType.BLOOD_PRESSURE_SYSTOLIC];

    List<HealthDataAccess> permissions = [HealthDataAccess.READ_WRITE, HealthDataAccess.READ_WRITE];

    final requested = Platform.isIOS
        ? await health.requestAuthorization(healthDataType, permissions: permissions)
        : await health.hasPermissions(healthDataType, permissions: permissions);

    emit(PressureLoadingState());

    if(event.value != null){
      event.value!.select(requested ?? false);
    }

    final response = await service.getSensorsForHours(ClientSensorHoursRequest(healthSensorId: 7, date: DateFormat("yyyy-MM-dd").format(event.date)));

    if (response.result) {
      emit(
        PressureLoadedState(
          currentVal: response.value?.currentVal,
          list: response.value?.clientSensors,
          date: event.date,
          isRequested: requested ?? false,
        ),
      );
    } else {
      emit(PressureErrorState());
    }
  }

  Future<void> _get(PressureGetEvent event, Emitter<PressureState> emit) async {
    List<HealthDataType> healthDataType = [HealthDataType.BLOOD_PRESSURE_DIASTOLIC, HealthDataType.BLOOD_PRESSURE_SYSTOLIC];

    List<HealthDataAccess> permissions = [HealthDataAccess.READ_WRITE, HealthDataAccess.READ_WRITE];

    final requested = Platform.isIOS
        ? await health.requestAuthorization(healthDataType, permissions: permissions)
        : await health.hasPermissions(healthDataType, permissions: permissions);

    DateTime? dateFromFit;
    int systolicPressure = 0;
    int diastolicPressure = 0;

    emit(PressureLoadingState());

    if(event.value != null){
      event.value!.select(requested ?? false);
    }

    if (requested == true) {
      final valueResponse = await healthController.getPressure(event.date);
      if (valueResponse.isNotEmpty) {
        systolicPressure = valueResponse.last.systolic.toInt();
        diastolicPressure = valueResponse.last.diastolic.toInt();
        dateFromFit = valueResponse.last.dateTo;
      }
    }

    final response = await service.getSensorsForHours(ClientSensorHoursRequest(healthSensorId: 7, date: DateFormat("yyyy-MM-dd").format(event.date)));

    if (response.result) {
      if (dateFromFit != null && diastolicPressure != 0 && systolicPressure != 0) {
        bool dataFitInService = false;

        if (response.value?.clientSensors != null && response.value!.clientSensors!.isNotEmpty) {
          for (var element in response.value!.clientSensors!) {
            if (element.healthSensorVal != null) {
              String test = element.healthSensorVal.toString();

              List values = test.split(".");

              int diastolic = int.parse(values.first);
              int systolic = int.parse(values.last);

              if (element.dateSensor == dateFromFit && diastolic == diastolicPressure && systolic == systolicPressure) {
                dataFitInService = true;
                break;
              }
              ;
            }
          }
        }

        if (dataFitInService == true) {
          emit(PressureLoadedState(
              currentVal: response.value?.currentVal, list: response.value?.clientSensors, date: event.date, isRequested: requested ?? false));
        } else {
          String newPressure = "$diastolicPressure.$systolicPressure";
          final serviceResponse = await service.createSensorsMeasurement(
            CreateClientSensorsRequest(
              healthSensorId: 7,
              healthSensorVal: double.parse(newPressure),
              dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(dateFromFit),
            ),
          );
          if (serviceResponse.result) {
            final valueRequestSecondTime =
                await service.getSensorsForHours(ClientSensorHoursRequest(healthSensorId: 7, date: DateFormat("yyyy-MM-dd").format(event.date)));

            if (valueRequestSecondTime.result) {
              emit(PressureLoadedState(
                  currentVal: valueRequestSecondTime.value?.currentVal,
                  list: valueRequestSecondTime.value?.clientSensors,
                  date: event.date,
                  isRequested: requested ?? false));
            } else {
              emit(PressureErrorState());
            }
          } else {
            emit(PressureErrorState());
          }
        }
      } else {
        emit(PressureLoadedState(
            currentVal: response.value?.currentVal, list: response.value?.clientSensors, date: event.date, isRequested: requested ?? false));
      }
    } else {
      emit(PressureErrorState());
    }
  }

  Future<void> _connected(PressuredConnectedEvent event, Emitter<PressureState> emit) async {
    List<HealthDataType> healthDataType = [HealthDataType.BLOOD_PRESSURE_DIASTOLIC, HealthDataType.BLOOD_PRESSURE_SYSTOLIC];

    List<HealthDataAccess> permissions = [HealthDataAccess.READ_WRITE, HealthDataAccess.READ_WRITE];

    final requested = await health.requestAuthorization(healthDataType, permissions: permissions);

    if(event.value != null){
      event.value!.select(requested ?? false);
    }

    if (requested == true) {
      emit(PressureLoadingState());

      DateTime? dateFromFit;
      int systolicPressure = 0;
      int diastolicPressure = 0;

      final valueResponse = await healthController.getPressure(event.date);

      if (valueResponse.isNotEmpty) {
        systolicPressure = Platform.isIOS ? valueResponse.first.systolic.toInt() : valueResponse.last.systolic.toInt();
        diastolicPressure = Platform.isIOS ? valueResponse.first.diastolic.toInt() : valueResponse.last.diastolic.toInt();
        dateFromFit = Platform.isIOS ? valueResponse.first.dateTo : valueResponse.last.dateTo;
      }

      final response =
          await service.getSensorsForHours(ClientSensorHoursRequest(healthSensorId: 7, date: DateFormat("yyyy-MM-dd").format(event.date)));

      if (response.result) {
        if (dateFromFit != null && diastolicPressure != 0 && systolicPressure != 0) {
          bool dataFitInService = false;

          if (response.value?.clientSensors != null && response.value!.clientSensors!.isNotEmpty) {
            for (var element in response.value!.clientSensors!) {
              if (element.healthSensorVal != null) {
                String test = element.healthSensorVal.toString();

                List values = test.split(".");

                int diastolic = int.parse(values.first);
                int systolic = int.parse(values.last);

                if (element.dateSensor == dateFromFit && diastolic == diastolicPressure && systolic == systolicPressure) {
                  dataFitInService = true;
                  break;
                }
                ;
              }
            }
          }

          if (dataFitInService == true) {
            emit(PressureLoadedState(
                currentVal: response.value?.currentVal, list: response.value?.clientSensors, date: event.date, isRequested: requested));
          } else {
            String newPressure = "$diastolicPressure.$systolicPressure";
            final serviceResponse = await service.createSensorsMeasurement(
              CreateClientSensorsRequest(
                healthSensorId: 7,
                healthSensorVal: double.parse(newPressure),
                dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(dateFromFit),
              ),
            );
            if (serviceResponse.result) {
              final valueRequestSecondTime =
                  await service.getSensorsForHours(ClientSensorHoursRequest(healthSensorId: 7, date: DateFormat("yyyy-MM-dd").format(event.date)));

              if (valueRequestSecondTime.result) {
                emit(PressureLoadedState(
                    currentVal: valueRequestSecondTime.value?.currentVal,
                    list: valueRequestSecondTime.value?.clientSensors,
                    date: event.date,
                    isRequested: requested ?? false));
              } else {
                emit(PressureErrorState());
              }
            } else {
              emit(PressureErrorState());
            }
          }
        } else {
          emit(PressureLoadedState(
              currentVal: response.value?.currentVal, list: response.value?.clientSensors, date: event.date, isRequested: requested ?? false));
        }
      } else {
        emit(PressureErrorState());
      }
    } else {
      emit(PressureNotConnectedState());
    }
  }
}
