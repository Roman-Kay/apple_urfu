
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

part "pulse_state.dart";
part 'pulse_event.dart';

class PulseBloc extends Bloc<PulseEvent, PulseState>{
  PulseBloc() : super(PulseInitialState()){
    on<PulseGetEvent>(_get);
  }

  final service = SensorsService();


  Future<void> _get(PulseGetEvent event, Emitter<PulseState> emit) async{
    emit(PulseLoadingState());

    final response = await service.getSensorsForHours(ClientSensorHoursRequest(
      healthSensorId: 3,
      date: DateFormat("yyyy-MM-dd").format(event.date),
    ));


    if (response.result) {
      emit(PulseLoadedState(
          currentVal: response.value?.currentVal,
          list: response.value?.clientSensors,
          date: event.date
      ));
    }
    else {
      emit(PulseErrorState());
    }

  }
}