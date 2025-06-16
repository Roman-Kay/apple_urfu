
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';

part "client_weight_event.dart";
part 'client_weight_state.dart';

class ClientWeightBloc extends Bloc<ClientWeightEvent, ClientWeightState>{
  ClientWeightBloc() : super(ClientWeightInitialState()){
    on<ClientWeightGetEvent>(_get);
  }

  final service = SensorsService();

  Future<void> _get(ClientWeightGetEvent event, Emitter<ClientWeightState> emit) async{
    emit(ClientWeightLoadingState());

    int value = event.dayQuantity == 7 ? 6 : event.dayQuantity;

    final response = await service.getSensorsForDay(ClientSensorDayRequest(
      healthSensorId: 9,
      clientId: event.id,
      dateStart: DateFormat("yyyy-MM-dd").format(event.startDate.subtract(Duration(days: value))),
      dateEnd: DateFormat("yyyy-MM-dd").format(event.startDate),
    ));

    if(response.result){
      emit(ClientWeightLoadedState(
        currentVal: response.value?.currentVal,
        targetView: response.value?.target,
        list: response.value?.clientSensors
      ));
    }
    else{
      emit(ClientWeightErrorState());
    }
  }
}