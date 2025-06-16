
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_fit/flutter_health_fit.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/health/health_service.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';

part 'health_sleep_event.dart';
part 'health_sleep_state.dart';

class HealthSleepBloc extends Bloc<HealthSleepEvent, HealthSleepState>{
  HealthSleepBloc() : super(HealthSleepInitialState()){
    on<HealthSleepCheckEvent>(_check);
    on<HealthConnectedEvent>(_connected);
  }

  final service = SensorsService();
  HealthService healthService = HealthService();
  HealthServiceController healthController = HealthServiceController();
  final flutterHealthFit = FlutterHealthFit();

  Future<void> _check(HealthSleepCheckEvent event, Emitter<HealthSleepState> emit) async{
    emit(HealthSleepLoadingState());

    final isAuth = await healthService.isAuthHealthFit();

    var fitValue;

    if (isAuth) {
      DateTime startDate = DateTime(event.date.year, event.date.month, event.date.day - 1, 19, 0);
      DateTime endDate = DateTime(event.date.year, event.date.month, event.date.day, 19, 0);

      fitValue = await healthController.getSleep(startDate, endDate);
    }

    final response = await service.getSensorsForDay(ClientSensorDayRequest(
      healthSensorId: 5,
      dateEnd: DateFormat("yyyy-MM-dd").format(event.date),
      dateStart: DateFormat("yyyy-MM-dd").format(event.date),
    ));


    if (response.result && response.value != null && response.value?.clientSensors != null) {
      bool noErrorForCreateSensor = true;
      // проверка были ли данные с фита отправлены на сервер
      bool fitValueWasSend = false;


      if (fitValue != null && fitValue.isNotEmpty) {
        for (var fitElement in fitValue) {
          num fitElementVal = fitElement.end.difference(fitElement.start).inMinutes;
          bool dataFitInService = false;

          for (var serviceElement in response.value!.clientSensors!) {
            if (fitElementVal == serviceElement.healthSensorVal && DateFormat("yyyy-MM-dd HH:mm:ss").format(fitElement.end).toString() == serviceElement.dateSensor) {
              dataFitInService = true;
              break;
            }
          }

          // если конретного элемента fitElement из fitValue! нет на бэке, то отправляем его
          if (!dataFitInService) {
            final serviceCreate = await service.createSensorsMeasurement(CreateClientSensorsRequest(
              healthSensorId: 5,
              healthSensorVal: fitElementVal,
              dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(fitElement.end),
            ));
            fitValueWasSend = true;
            if (serviceCreate.result == true) {
              // если все отлично и result == true то ничего не делаем
              // ничего не вкладываем потому что отправок на бэк новой даты может быть несколько
              // и каждая из них должна быть удачной
              null;
            } else {
              // если хоть в одной отправке все плохо, параметр noErrorForCreateSensor (нет ошибок)
              // выставляем false и break функцию перебора потому данные будут не верны
              noErrorForCreateSensor = false;
              break;
            }
          }
        }
      }

      if (noErrorForCreateSensor) {
        final responseSecond = fitValueWasSend
        // еслм fitValue было отправлено на сервер, то запрашиваем данные о сне снова, так они поменялись
        ? await service.getSensorsForDay(ClientSensorDayRequest(
          healthSensorId: 5,
          dateEnd: DateFormat("yyyy-MM-dd").format(event.date),
          dateStart: DateFormat("yyyy-MM-dd").format(event.date),
        ))
        // еслм fitValue не было отправлено, то берем данные заново
        : response;

        if (responseSecond.result && responseSecond.value != null && responseSecond.value?.clientSensors != null) {

          // в этот лист складываем мапы из с датой начала и конца и value
          // нужно чтобы сложить с датами форамата DateTime а не String и позже по ним сортировать
          List<Map<String, dynamic>> sleepCycleList = [];

          for (var serviceSecondElement in responseSecond.value!.clientSensors!) {
            if (serviceSecondElement.dateSensor != null && serviceSecondElement.healthSensorVal != null) {

              // дата конца одно из циклов сна
              final DateTime endTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(serviceSecondElement.dateSensor!);

              // дата начала одно из циклов сна
              final DateTime startTime = endTime.subtract(Duration(minutes: serviceSecondElement.healthSensorVal!.toInt()));

              // формируем list из map чтобы было DateTime, а не String
              sleepCycleList.add(
                  {
                    'startTime': startTime,
                    'endTime': endTime,
                    'value': serviceSecondElement.healthSensorVal!.toDouble(),
                  }
              );
            }
          }

          // сортируем List из map по возрастанию на основе стартовой даты циклов
          sleepCycleList.sort((a,b) {
            var adate = a['startTime'];
            var bdate = b['startTime'];
            return -bdate.compareTo(adate);
          });

          num sleepValueInMin = 0;

          // спомагательная переменная для определения самой последней даты из всех циклов
          DateTime? lastTimeHelp;

          for (var sleepCycleElemet in sleepCycleList) {
            // если lastTimeHelp ничему не равно то это первый элемент списка
            if (lastTimeHelp == null) {
              lastTimeHelp = sleepCycleElemet['endTime'];
              sleepValueInMin = sleepCycleElemet['startTime'].difference(sleepCycleElemet['endTime']).inMinutes.abs();
            }
            // если startTime нашего елемента не позже lastTimeHelp
            // (сделал чтобы не считать часы когда человек встал в середине сна)
            //
            // и endTime нашего елемента позже lastTimeHelp
            // (сделал чтобы не считать часы когда цикл внутри более большого цикла)
            else if (!sleepCycleElemet['startTime'].isAfter(lastTimeHelp) && sleepCycleElemet['endTime'].isAfter(lastTimeHelp)) {

              // тогда разницу в минутах между концом предыдущих циклов и концом нового добавляем
              // к sleepValueInMin
              sleepValueInMin = sleepValueInMin + lastTimeHelp.difference(sleepCycleElemet['endTime']).inMinutes.abs();
              lastTimeHelp = sleepCycleElemet['endTime'];
            }

            // lastTimeHelp предыдщих циклов меньше startTime нового цикла
            // то был сна
            else if (sleepCycleElemet['startTime'].isAfter(lastTimeHelp)) {
              // lastTimeHelp выстовляем по новому циклу
              lastTimeHelp = sleepCycleElemet['endTime'];
              // к sleepValueInMin прибавляем время нового цикла
              sleepValueInMin = sleepValueInMin + sleepCycleElemet['startTime'].difference(sleepCycleElemet['endTime']).inMinutes.abs();
            }
          }


          final int minutes = (sleepValueInMin % 60).toInt();
          final int hour = sleepValueInMin ~/ 60;

          emit(HealthSleepLoadedState(
              minutes: minutes,
              hours: hour,
              date: response.value?.currentVal?.dateSensor,
              clientSensorId: response.value?.currentVal?.clientSensorId,
          ));
        }
        else {
          emit(HealthSleepErrorState());
        }
      }
      else {
        emit(HealthSleepErrorState());
      }

    }
    else {
      emit(HealthSleepErrorState());
    }
  }

  Future<void> _connected(HealthConnectedEvent event, Emitter<HealthSleepState> emit) async{

    final request = await flutterHealthFit.authorize();

    final isAuth = await healthService.isAuthHealthFit();

    if(isAuth){
      emit(HealthSleepLoadingState());

      DateTime startDate = DateTime(event.date.year, event.date.month, event.date.day - 1, 19, 0);
      DateTime endDate = DateTime(event.date.year, event.date.month, event.date.day, 19, 0);

      final fitValue = await healthController.getSleep(startDate, endDate);

      final response = await service.getSensorsForDay(ClientSensorDayRequest(
        healthSensorId: 5,
        dateEnd: DateFormat("yyyy-MM-dd").format(event.date),
        dateStart: DateFormat("yyyy-MM-dd").format(event.date),
      ));


      if (response.result && response.value != null && response.value?.clientSensors != null) {
        bool noErrorForCreateSensor = true;
        // проверка были ли данные с фита отправлены на сервер
        bool fitValueWasSend = false;


        if (fitValue != null && fitValue.isNotEmpty) {
          for (var fitElement in fitValue) {
            num fitElementVal = fitElement.end.difference(fitElement.start).inMinutes;
            bool dataFitInService = false;

            for (var serviceElement in response.value!.clientSensors!) {
              if (fitElementVal == serviceElement.healthSensorVal && DateFormat("yyyy-MM-dd HH:mm:ss").format(fitElement.end).toString() == serviceElement.dateSensor) {
                dataFitInService = true;
                break;
              }
            }

            // если конретного элемента fitElement из fitValue! нет на бэке, то отправляем его
            if (!dataFitInService) {
              final serviceCreate = await service.createSensorsMeasurement(CreateClientSensorsRequest(
                healthSensorId: 5,
                healthSensorVal: fitElementVal,
                dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(fitElement.end),
              ));
              fitValueWasSend = true;
              if (serviceCreate.result == true) {
                // если все отлично и result == true то ничего не делаем
                // ничего не вкладываем потому что отправок на бэк новой даты может быть несколько
                // и каждая из них должна быть удачной
                null;
              } else {
                // если хоть в одной отправке все плохо, параметр noErrorForCreateSensor (нет ошибок)
                // выставляем false и break функцию перебора потому данные будут не верны
                noErrorForCreateSensor = false;
                break;
              }
            }
          }
        }

        if (noErrorForCreateSensor) {
          final responseSecond = fitValueWasSend
          // еслм fitValue было отправлено на сервер, то запрашиваем данные о сне снова, так они поменялись
              ? await service.getSensorsForDay(ClientSensorDayRequest(
            healthSensorId: 5,
            dateEnd: DateFormat("yyyy-MM-dd").format(event.date),
            dateStart: DateFormat("yyyy-MM-dd").format(event.date),
          ))
          // еслм fitValue не было отправлено, то берем данные заново
              : response;

          if (responseSecond.result && responseSecond.value != null && responseSecond.value?.clientSensors != null) {

            // в этот лист складываем мапы из с датой начала и конца и value
            // нужно чтобы сложить с датами форамата DateTime а не String и позже по ним сортировать
            List<Map<String, dynamic>> sleepCycleList = [];

            for (var serviceSecondElement in responseSecond.value!.clientSensors!) {
              if (serviceSecondElement.dateSensor != null && serviceSecondElement.healthSensorVal != null) {

                // дата конца одно из циклов сна
                final DateTime endTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(serviceSecondElement.dateSensor!);

                // дата начала одно из циклов сна
                final DateTime startTime = endTime.subtract(Duration(minutes: serviceSecondElement.healthSensorVal!.toInt()));

                // формируем list из map чтобы было DateTime, а не String
                sleepCycleList.add(
                    {
                      'startTime': startTime,
                      'endTime': endTime,
                      'value': serviceSecondElement.healthSensorVal!.toDouble(),
                    }
                );
              }
            }

            // сортируем List из map по возрастанию на основе стартовой даты циклов
            sleepCycleList.sort((a,b) {
              var adate = a['startTime'];
              var bdate = b['startTime'];
              return -bdate.compareTo(adate);
            });

            num sleepValueInMin = 0;

            // спомагательная переменная для определения самой последней даты из всех циклов
            DateTime? lastTimeHelp;

            for (var sleepCycleElemet in sleepCycleList) {
              // если lastTimeHelp ничему не равно то это первый элемент списка
              if (lastTimeHelp == null) {
                lastTimeHelp = sleepCycleElemet['endTime'];
                sleepValueInMin = sleepCycleElemet['startTime'].difference(sleepCycleElemet['endTime']).inMinutes.abs();
              }
              // если startTime нашего елемента не позже lastTimeHelp
              // (сделал чтобы не считать часы когда человек встал в середине сна)
              //
              // и endTime нашего елемента позже lastTimeHelp
              // (сделал чтобы не считать часы когда цикл внутри более большого цикла)
              else if (!sleepCycleElemet['startTime'].isAfter(lastTimeHelp) && sleepCycleElemet['endTime'].isAfter(lastTimeHelp)) {

                // тогда разницу в минутах между концом предыдущих циклов и концом нового добавляем
                // к sleepValueInMin
                sleepValueInMin = sleepValueInMin + lastTimeHelp.difference(sleepCycleElemet['endTime']).inMinutes.abs();
                lastTimeHelp = sleepCycleElemet['endTime'];
              }

              // lastTimeHelp предыдщих циклов меньше startTime нового цикла
              // то был сна
              else if (sleepCycleElemet['startTime'].isAfter(lastTimeHelp)) {
                // lastTimeHelp выстовляем по новому циклу
                lastTimeHelp = sleepCycleElemet['endTime'];
                // к sleepValueInMin прибавляем время нового цикла
                sleepValueInMin = sleepValueInMin + sleepCycleElemet['startTime'].difference(sleepCycleElemet['endTime']).inMinutes.abs();
              }
            }
            sleepValueInMin = sleepValueInMin / 60;
            String testMin = sleepValueInMin.toStringAsFixed(2);

            var pos = testMin.lastIndexOf('.');
            String test = testMin.substring(pos);
            String finalMin = test.substring(1);

            final int minutes = int.parse(finalMin);
            final int hour = sleepValueInMin.toInt();

            emit(HealthSleepLoadedState(
                minutes: minutes,
                hours: hour,
                date: response.value?.currentVal?.dateSensor,
                clientSensorId: response.value?.currentVal?.clientSensorId,
            ));
          }
          else {
            emit(HealthSleepErrorState());
          }
        }
        else {
          emit(HealthSleepErrorState());
        }

      }
      else {
        emit(HealthSleepErrorState());
      }

    }
    else{
      emit(HealthSleepNotConnectedState());
    }


  }

}
