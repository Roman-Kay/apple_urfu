
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';

part "client_sleep_event.dart";
part 'client_sleep_state.dart';

class ClientSleepBloc extends Bloc<ClientSleepEvent, ClientSleepState>{
  ClientSleepBloc() : super(ClientSleepInitialState()){
    on<ClientSleepGetEvent>(_get);
  }

  final service = SensorsService();

  Future<void> _get(ClientSleepGetEvent event, Emitter<ClientSleepState> emit) async{
    emit(ClientSleepLoadingState());

    int value = event.dayQuantity == 7 ? 6 : event.dayQuantity;

    final response = await service.getSensorsForDay(ClientSensorDayRequest(
      clientId: event.id,
      healthSensorId: 5,
      dateStart: DateFormat("yyyy-MM-dd").format(event.startDate.subtract(Duration(days: value))),
      dateEnd: DateFormat("yyyy-MM-dd").format(event.startDate),
    ));

    if(response.result){
      emit(ClientSleepLoadedState(response.value?.clientSensors));
    }
    else{
      emit(ClientSleepErrorState());
    }
  }
}