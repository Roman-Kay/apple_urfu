
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';

part "client_pressure_event.dart";
part "client_pressure_state.dart";

class ClientPressureBloc extends Bloc<ClientPressureEvent, ClientPressureState>{
  ClientPressureBloc() : super(ClientPressureInitialState()){
    on<ClientPressureGetEvent>(_get);
  }

  final service = SensorsService();

  Future<void> _get(ClientPressureGetEvent event, Emitter<ClientPressureState> emit) async{
    emit(ClientPressureLoadingState());

    final response = await service.getSensorsForHours(ClientSensorHoursRequest(
        clientId: event.clientId,
        date: DateFormat("yyyy-MM-dd").format(event.startDate),
        healthSensorId: 7
    ));

    if(response.result){
      emit(ClientPressureLoadedState(response.value?.clientSensors));
    }
    else{
      emit(ClientPressureErrorState());
    }
  }
}