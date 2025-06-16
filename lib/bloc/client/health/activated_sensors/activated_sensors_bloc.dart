

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/activated_sensors.dart';
import 'package:garnetbook/domain/services/health/activated_sensors_service.dart';

part 'activated_sensors_state.dart';
part 'activated_sensors_event.dart';

class ActivatedSensorsBloc extends Bloc<ActivatedSensorsEvent, ActivatedSensorsState>{
  ActivatedSensorsBloc() : super(ActivatedSensorsInitialState()){
    on<ActivatedSensorsChangeEvent>(_change);
    on<ActivatedSensorsGetEvent>(_get);
  }

  final service = ActivatedSensorsService();

  Future<void> _get(ActivatedSensorsGetEvent event, Emitter<ActivatedSensorsState> emit) async{
    emit(ActivatedSensorsLoadingState());
    final response = await service.getActivatedSensorsList();
    if(response.result) {
      emit(ActivatedSensorsLoadedState(response.value));
    }
    else{
      emit(ActivatedSensorsErrorState());
    }
  }

  Future<void> _change(ActivatedSensorsChangeEvent event, Emitter<ActivatedSensorsState> emit) async{
    emit(ActivatedSensorsLoadingState());
    final response = await service.changeActivatedSensorsList(event.request);
    if(response.result){
      emit(ActivatedSensorsLoadedState(response.value));
    }
    else{
      emit(ActivatedSensorsErrorState());
    }
  }
}