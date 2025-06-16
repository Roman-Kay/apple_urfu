
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';

part "client_pulse_event.dart";
part "client_pulse_state.dart";

class ClientPulseBloc extends Bloc<ClientPulseEvent, ClientPulseState>{
  ClientPulseBloc() : super(ClientPulseInitialState()){
    on<ClientPulseGetEvent>(_get);
  }

  final service = SensorsService();

  Future<void> _get(ClientPulseGetEvent event, Emitter<ClientPulseState> emit) async{
    emit(ClientPulseLoadingState());

    final response = await service.getSensorsForHours(ClientSensorHoursRequest(
        clientId: event.clientId,
        date: DateFormat("yyyy-MM-dd").format(event.startDate),
        healthSensorId: 3
    ));

    if(response.result){
      emit(ClientPulseLoadedState(response.value?.clientSensors));
    }
    else{
      emit(ClientPulseErrorState());
    }
  }
}