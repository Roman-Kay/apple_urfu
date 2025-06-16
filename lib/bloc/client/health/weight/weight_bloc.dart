import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

part 'weight_state.dart';
part 'weight_event.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  WeightBloc() : super(WeightInitialState()) {
    on<WeightGetEvent>(_get);
    on<WeightUpdateEvent>(_update);
    on<WeightConnectedEvent>(_connected);
  }

  final service = SensorsService();
  HealthServiceController healthController = HealthServiceController();
  Health health = Health();

  Future<void> _update(WeightUpdateEvent event, Emitter<WeightState> emit) async {
    emit(WeightLoadingState());

    int value = event.dayQuantity == 7 ? 6 : event.dayQuantity;


    final response = await service.getSensorsForDay(ClientSensorDayRequest(
        healthSensorId: 9,
        dateStart: DateFormat("yyyy-MM-dd").format(event.date.subtract(Duration(days: value))),
        dateEnd: DateFormat("yyyy-MM-dd").format(event.date)));

    if (response.result) {
      emit(WeightLoadedState(
        currentVal: response.value?.currentVal,
        list: response.value?.clientSensors,
        targetView: response.value?.target,
      ));
    } else {
      emit(WeightErrorState());
    }
  }

  Future<void> _get(WeightGetEvent event, Emitter<WeightState> emit) async {
    emit(WeightLoadingState());

    int value = event.dayQuantity == 7 ? 5 : event.dayQuantity;

    final requested = Platform.isIOS
        ? await health.requestAuthorization([HealthDataType.WEIGHT], permissions: [HealthDataAccess.READ_WRITE])
        : await health.hasPermissions([HealthDataType.WEIGHT], permissions: [HealthDataAccess.READ_WRITE]);

    int? valueFromFit;
    DateTime? dateFromFit;

    if (requested == true) {
      final valueRequest = await healthController.getWeight();

      if (valueRequest.isNotEmpty) {
        valueFromFit = Platform.isIOS ? valueRequest.first.value!.toInt() : valueRequest.last.value!.toInt();
        dateFromFit = Platform.isIOS ? valueRequest.first.dateTo : valueRequest.last.dateTo;
      }
    }

    DateTime today = DateTime.now();

    final response = await service.getSensorsForDay(
      ClientSensorDayRequest(
        healthSensorId: 9,
        dateStart: DateFormat("yyyy-MM-dd").format(event.date.subtract(Duration(days: value))),
        dateEnd: DateFormat("yyyy-MM-dd").format(event.date),
      ),
    );

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
          emit(WeightLoadedState(
            targetView: response.value?.target,
            currentVal: response.value?.currentVal,
            list: response.value?.clientSensors,
          ));
        } else {
          final serviceResponse = await service.createSensorsMeasurement(
            CreateClientSensorsRequest(
              healthSensorId: 9,
              healthSensorVal: valueFromFit.toInt(),
              dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(dateFromFit),
            ),
          );

          if (serviceResponse.result) {
            final valueRequestSecondTime = await service.getSensorsForDay(
              ClientSensorDayRequest(
                healthSensorId: 9,
                dateStart: DateFormat("yyyy-MM-dd").format(event.date.subtract(Duration(days: value))),
                dateEnd: DateFormat("yyyy-MM-dd").format(event.date),
              ),
            );

            if (valueRequestSecondTime.result) {
              emit(WeightLoadedState(
                targetView: valueRequestSecondTime.value?.target,
                currentVal: valueRequestSecondTime.value?.currentVal,
                list: valueRequestSecondTime.value?.clientSensors,
              ));
            } else {
              emit(WeightErrorState());
            }
          } else {
            emit(WeightErrorState());
          }
        }
      } else {
        emit(WeightLoadedState(
          targetView: response.value?.target,
          currentVal: response.value?.currentVal,
          list: response.value?.clientSensors,
        ));
      }
    } else {
      emit(WeightErrorState());
    }
  }

  Future<void> _connected(WeightConnectedEvent event, Emitter<WeightState> emit) async {
    int value = event.dayQuantity == 7 ? 6 : event.dayQuantity;

    final requested = await health.requestAuthorization([HealthDataType.WEIGHT], permissions: [HealthDataAccess.READ_WRITE]);

    if (requested == true) {
      emit(WeightLoadingState());

      int? valueFromFit;
      DateTime? dateFromFit;

      final valueRequest = await healthController.getWeight();

      if (valueRequest.isNotEmpty) {
        valueFromFit = Platform.isIOS ? valueRequest.first.value!.toInt() : valueRequest.last.value!.toInt();
        dateFromFit = Platform.isIOS ? valueRequest.first.dateTo : valueRequest.last.dateTo;
      }

      final response = await service.getSensorsForDay(
        ClientSensorDayRequest(
          healthSensorId: 9,
          dateStart: DateFormat("yyyy-MM-dd").format(event.date.subtract(Duration(days: value))),
          dateEnd: DateFormat("yyyy-MM-dd").format(event.date),
        ),
      );

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
            emit(WeightLoadedState(
              targetView: response.value?.target,
              currentVal: response.value?.currentVal,
              list: response.value?.clientSensors,
            ));
          } else {
            final serviceResponse = await service.createSensorsMeasurement(
              CreateClientSensorsRequest(
                healthSensorId: 9,
                healthSensorVal: valueFromFit.toInt(),
                dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(dateFromFit),
              ),
            );

            if (serviceResponse.result) {
              final valueRequestSecondTime = await service.getSensorsForDay(
                ClientSensorDayRequest(
                  healthSensorId: 9,
                  dateStart: DateFormat("yyyy-MM-dd").format(event.date.subtract(Duration(days: value))),
                  dateEnd: DateFormat("yyyy-MM-dd").format(event.date),
                ),
              );

              if (valueRequestSecondTime.result) {
                emit(WeightLoadedState(
                  targetView: valueRequestSecondTime.value?.target,
                  currentVal: valueRequestSecondTime.value?.currentVal,
                  list: valueRequestSecondTime.value?.clientSensors,
                ));
              } else {
                emit(WeightErrorState());
              }
            } else {
              emit(WeightErrorState());
            }
          }
        } else {
          emit(WeightLoadedState(
            targetView: response.value?.target,
            currentVal: response.value?.currentVal,
            list: response.value?.clientSensors,
          ));
        }
      }
      else {
        emit(WeightErrorState());
      }
    }

    else {
      emit(WeightLoadingState());

      final response = await service.getSensorsForDay(
        ClientSensorDayRequest(
          healthSensorId: 9,
          dateStart: DateFormat("yyyy-MM-dd").format(event.date.subtract(Duration(days: value))),
          dateEnd: DateFormat("yyyy-MM-dd").format(event.date),
        ),
      );

      if (response.result) {
        emit(WeightNotConnectedState(
          targetView: response.value?.target,
          currentVal: response.value?.currentVal,
          list: response.value?.clientSensors,
        ));
      }
      else {
        emit(WeightErrorState());
      }

    }
  }
}
