
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_event_model.dart';
import 'package:garnetbook/data/models/expert/card_info/food_diary.dart';
import 'package:garnetbook/domain/services/expert/client_card_info/client_card_info.dart';
import 'package:intl/intl.dart';

part "client_food_diary_state.dart";
part 'client_food_diary_event.dart';

class ClientsCardFoodDiaryBloc extends Bloc<ClientsCardFoodDiaryEvent, ClientsCardFoodDiaryState>{
  ClientsCardFoodDiaryBloc() : super(ClientFoodDiaryInitialState()){
    on<ClientsCardFoodDiaryGetEvent>(_get);
    on<ClientCardFoodDiaryInitialEvent>(_initial);
  }

  final service = ClientCardInfoService();

  Future<void> _initial(ClientCardFoodDiaryInitialEvent event, Emitter<ClientsCardFoodDiaryState> emit) async{
    emit(ClientFoodDiaryInitialState());
  }

  Future<void> _get(ClientsCardFoodDiaryGetEvent event, Emitter<ClientsCardFoodDiaryState> emit) async{
    emit(ClientFoodDiaryLoadingState());

    int value = event.dayQuantity == 7 ? 5 : event.dayQuantity;

    final response = await service.getClientCardInfoFoodDiary(ClientFoodRequestExpert(
      clientId: event.id,
      dateBy: DateFormat("yyyy-MM-dd").format(event.startDate),
      dateFrom: DateFormat("yyyy-MM-dd").format(event.startDate.subtract(Duration(days: value))),
    ));

    if(response.result){
      emit(ClientFoodDiaryLoadedState(response.value));
    }
    else{
      emit(ClientFoodDiaryErrorState());
    }
  }
}