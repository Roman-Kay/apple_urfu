
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_event_model.dart';
import 'package:garnetbook/data/models/expert/card_info/food_diary.dart';
import 'package:garnetbook/domain/services/expert/client_card_info/client_card_info.dart';
import 'package:intl/intl.dart';

part 'client_sensors_water_event.dart';
part 'client_sensors_water_state.dart';

class ClientSensorsWaterBloc extends Bloc<ClientSensorWaterEvent, ClientSensorWaterState>{
  ClientSensorsWaterBloc(): super(ClientSensorWaterInitialState()){
    on<ClientSensorWaterGetEvent>(_get);
  }

  final service = ClientCardInfoService();

  Future<void> _get(ClientSensorWaterGetEvent event, Emitter<ClientSensorWaterState> emit) async{
    emit(ClientSensorWaterLoadingState());

    DateTime startedDate = DateTime(event.year, event.month, 1);
    DateTime endedDate = DateTime(event.year, event.month + 1, 1 - 1);

    final response = await service.getClientCardInfoWaterDiary(ClientFoodRequestExpert(
        dateBy: DateFormat("yyyy-MM-dd").format(endedDate),
        dateFrom: DateFormat("yyyy-MM-dd").format(startedDate),
        clientId: event.id
    ));

    if(response.result){
      emit(ClientSensorWaterLoadedState(response.value));
    }
    else{
      emit(ClientSensorWaterErrorState());
    }
  }
}