
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_event_model.dart';
import 'package:garnetbook/data/models/expert/card_info/food_diary.dart';
import 'package:garnetbook/domain/services/expert/client_card_info/client_card_info.dart';
import 'package:intl/intl.dart';

part 'client_water_diary_event.dart';
part 'client_water_diary_state.dart';

class ClientsCardWaterDiaryBloc extends Bloc<ClientsCardWaterDiaryEvent, ClientsCardWaterDiaryState>{
  ClientsCardWaterDiaryBloc() : super(ClientsCardWaterDiaryInitialState()){
    on<ClientsCardWaterDiaryGetEvent>(_get);
    on<ClientsCardWaterDiaryForFoodDiaryEvent>(_getForFoodDiary);
    on<ClientsCardWaterDiaryInitialEvent>(_initial);
  }

  final service = ClientCardInfoService();

  Future<void> _initial(ClientsCardWaterDiaryInitialEvent event, Emitter<ClientsCardWaterDiaryState> emit) async{
    emit(ClientsCardWaterDiaryInitialState());
  }

  Future<void> _getForFoodDiary(ClientsCardWaterDiaryForFoodDiaryEvent event, Emitter<ClientsCardWaterDiaryState> emit) async{
    emit(ClientsCardWaterDiaryLoadingState());

    DateTime date = event.date;

    DateTime endDate = DateTime(date.year, date.month, date.day + 1);
    DateTime startDate = DateTime(date.year, date.month, date.day);

    final response = await service.getClientCardInfoWaterDiary(ClientFoodRequestExpert(
        dateBy: DateFormat("yyyy-MM-dd").format(endDate),
        dateFrom: DateFormat("yyyy-MM-dd").format(startDate),
        clientId: event.id
    ));

    if(response.result){
      emit(ClientsCardWaterDiaryLoadedState(response.value));
    }
    else{
      emit(ClientsCardWaterDiaryErrorState());
    }
  }

  Future<void> _get(ClientsCardWaterDiaryGetEvent event, Emitter<ClientsCardWaterDiaryState> emit) async{
    emit(ClientsCardWaterDiaryLoadingState());

    int value = event.dayQuantity == 7 ? 5 : event.dayQuantity;

    final response = await service.getClientCardInfoWaterDiary(ClientFoodRequestExpert(
        dateBy: DateFormat("yyyy-MM-dd").format(event.startDate),
        dateFrom: DateFormat("yyyy-MM-dd").format(event.startDate.subtract(Duration(days: value))),
        clientId: event.id
    ));

    if(response.result){
      emit(ClientsCardWaterDiaryLoadedState(response.value));
    }
    else{
      emit(ClientsCardWaterDiaryErrorState());
    }
  }
}