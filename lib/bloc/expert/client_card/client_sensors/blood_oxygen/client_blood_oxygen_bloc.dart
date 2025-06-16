
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';

part 'client_blood_oxygen_event.dart';
part 'client_blood_oxygen_state.dart';

class ClientBloodOxygenBloc extends Bloc<ClientBloodOxygenEvent, ClientBloodOxygenState>{
  ClientBloodOxygenBloc() : super(ClientBloodOxygenInitialState()){
    on<ClientBloodOxygenGetEvent>(_get);
  }

  final service = SensorsService();

  Future<void> _get(ClientBloodOxygenGetEvent event, Emitter<ClientBloodOxygenState> emit) async{
    emit(ClientBloodOxygenLoadingState());

    final response = await service.getSensorsForHours(ClientSensorHoursRequest(
        clientId: event.id,
        date: DateFormat("yyyy-MM-dd").format(event.startDate),
        healthSensorId: 4
    ));

    if(response.result){
      emit(ClientBloodOxygenLoadedState(response.value?.clientSensors));
    }
    else{
      emit(ClientBloodOxygenErrorState());
    }
  }
}