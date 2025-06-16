
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';

part "client_steps_event.dart";
part "client_steps_state.dart";

class ClientStepsBloc extends Bloc<ClientStepsEvent, ClientStepsState>{
  ClientStepsBloc() : super(ClientStepsInitialState()){
    on<ClientStepsGetEvent>(_get);
    on<ClientStepsInitialEvent>(_initial);
  }

  final service = SensorsService();

  Future<void> _initial(ClientStepsInitialEvent event, Emitter<ClientStepsState> emit) async{
    emit(ClientStepsInitialState());
  }


  Future<void> _get(ClientStepsGetEvent event, Emitter<ClientStepsState> emit) async{
    emit(ClientStepsLoadingState());

    DateTime startedDate = DateTime(event.year, event.month, 1);
    DateTime endedDate = DateTime(event.year, event.month + 1, 1 - 1);

    final response = await service.getSensorsForDay(ClientSensorDayRequest(
      healthSensorId: 1,
      clientId: event.id,
      dateStart: DateFormat("yyyy-MM-dd").format(startedDate),
      dateEnd: DateFormat("yyyy-MM-dd").format(endedDate),
    ));

    if(response.result){
      emit(ClientStepsLoadedState(response.value?.clientSensors));
    }
    else{
      emit(ClientStepsErrorState());
    }
  }
}