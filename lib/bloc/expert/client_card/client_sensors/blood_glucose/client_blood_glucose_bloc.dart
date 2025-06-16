
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';

part 'client_blood_glucose_event.dart';
part 'client_blood_glucose_state.dart';

class ClientBloodGlucoseBloc extends Bloc<ClientBloodGlucoseEvent, ClientBloodGlucoseState>{
  ClientBloodGlucoseBloc() : super(ClientBloodGlucoseInitialState()){
    on<ClientBloodGlucoseGetEvent>(_get);
  }

  final service = SensorsService();

  Future<void> _get(ClientBloodGlucoseGetEvent event, Emitter<ClientBloodGlucoseState> emit) async{
    emit(ClientBloodGlucoseLoadingState());

    final response = await service.getSensorsForHours(ClientSensorHoursRequest(
      clientId: event.id,
      date: DateFormat("yyyy-MM-dd").format(event.startDate),
      healthSensorId: 6
    ));

    if(response.result){
      emit(ClientBloodGlucoseLoadedState(response.value?.clientSensors));
    }
    else{
      emit(ClientBloodGlucoseErrorState());
    }
  }
}