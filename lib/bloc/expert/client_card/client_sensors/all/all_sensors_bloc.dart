
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/activity/activity_request.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/data/models/expert/card_info/food_diary.dart';
import 'package:garnetbook/domain/services/expert/client_card_info/client_card_info.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';

part 'all_sensors_event.dart';
part 'all_sensors_state.dart';

class AllSensorsBloc extends Bloc<AllSensorsEvent, AllSensorsState>{
  AllSensorsBloc() : super(AllSensorsInitialState()){
    on<AllSensorsGetEvent>(_get);
  }

  final service = SensorsService();
  final waterService = ClientCardInfoService();

  Future<void> _get(AllSensorsGetEvent event, Emitter<AllSensorsState> emit) async{
    emit(AllSensorsLoadingState());

    String date = DateFormat("yyyy-MM-dd").format(event.date);


    final stepsResponse = await service.getSensorsForDay(ClientSensorDayRequest(healthSensorId: 1, clientId: event.clientId, dateStart: date, dateEnd: date));

    final sleepResponse = await service.getSensorsForDay(ClientSensorDayRequest(healthSensorId: 5, clientId: event.clientId, dateStart: date, dateEnd: date));

    final weightResponse = await service.getSensorsForDay(ClientSensorDayRequest(healthSensorId: 9, clientId: event.clientId, dateStart: date, dateEnd: date));

    final bloodSugarResponse = await service.getSensorsForDay(ClientSensorDayRequest(healthSensorId: 6, clientId: event.clientId, dateStart: date, dateEnd: date));

    final saturationResponse = await service.getSensorsForDay(ClientSensorDayRequest(healthSensorId: 4, clientId: event.clientId, dateStart: date, dateEnd: date));

    final pressureResponse = await service.getSensorsForDay(ClientSensorDayRequest(healthSensorId: 7, clientId: event.clientId, dateStart: date, dateEnd: date));

    final pulseResponse = await service.getSensorsForDay(ClientSensorDayRequest(healthSensorId: 3, clientId: event.clientId, dateStart: date, dateEnd: date));

    final waterResponse =  await waterService.getClientCardInfoWaterDiary(ClientFoodRequestExpert(dateBy: date, dateFrom: date, clientId: event.clientId));

    final workoutResponse = await service.getSensorsActivityForExpert(event.clientId, PeriodDateRequest(dateStart: date, dateEnd: date));

    int calories = 0;
    int water = 0;
    int waterGoal = 0;
    int sleep = 0;

    if(sleepResponse.result && sleepResponse.value?.clientSensors != null && sleepResponse.value!.clientSensors!.isNotEmpty){
      sleepResponse.value!.clientSensors!.forEach((element){
        if(element.healthSensorVal != null){
          sleep = sleep + element.healthSensorVal!.toInt();
        }
      });
    }

    if(workoutResponse.result && workoutResponse.value != null && workoutResponse.value!.isNotEmpty){
      workoutResponse.value!.forEach((element){
        if(element.calories != null){
          calories = calories + element.calories!;
        }
      });
    }

    if(waterResponse.result && waterResponse.value != null && waterResponse.value!.isNotEmpty){
      waterResponse.value?.forEach((element){
        if(element.dayVal != null){
          water = water + element.dayVal!;
        }
      });
    }

    emit(AllSensorsLoadedState(
        steps: stepsResponse.result && stepsResponse.value?.currentVal?.healthSensorVal != null ? stepsResponse.value!.currentVal!.healthSensorVal!.toInt() : 0,
        weight: weightResponse.result && weightResponse.value?.currentVal?.healthSensorVal != null ? weightResponse.value!.currentVal!.healthSensorVal!.toInt() : 0,
        water: water,
        pressure: pressureResponse.result && pressureResponse.value?.currentVal?.healthSensorVal != null ? pressureResponse.value!.currentVal!.healthSensorVal!.toDouble() : 0,
        saturation: saturationResponse.result && saturationResponse.value?.currentVal?.healthSensorVal != null ? saturationResponse.value!.currentVal!.healthSensorVal!.toInt() : 0,
        workout: calories,
        sleep: sleep,
        bloodSugar: bloodSugarResponse.result && bloodSugarResponse.value?.currentVal?.healthSensorVal != null ? bloodSugarResponse.value!.currentVal!.healthSensorVal!.toDouble() : 0,
        dateBloodSugar: bloodSugarResponse.result && bloodSugarResponse.value?.currentVal?.dateSensor != null ? bloodSugarResponse.value!.currentVal!.dateSensor : null,
        dateSleep: sleepResponse.result && sleepResponse.value?.currentVal?.dateSensor != null ? sleepResponse.value!.currentVal!.dateSensor : null,
        pressureDate: pressureResponse.result && pressureResponse.value?.currentVal?.dateSensor != null ? pressureResponse.value!.currentVal!.dateSensor : null,
        pulse: pulseResponse.result && pulseResponse.value?.currentVal?.healthSensorVal != null ? pulseResponse.value!.currentVal!.healthSensorVal!.toInt() : null,
        workoutDate: workoutResponse.result && workoutResponse.value != null && workoutResponse.value!.isNotEmpty && workoutResponse.value?.last.activityDate != null ? workoutResponse.value?.last.activityDate : null,
    ));



  }
}