
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/food_diary/food_diary_model.dart';
import 'package:garnetbook/domain/services/client/food_diary/food_diary_service.dart';


part 'client_food_diary_whole_data_event.dart';
part 'client_food_diary_whole_data_state.dart';

class ClientFoodDiaryWholeDataBloc extends Bloc<ClientFoodDiaryWholeDataEvent, ClientFoodDiaryWholeDataState>{
  ClientFoodDiaryWholeDataBloc() : super(ClientFoodDiaryWholeDataInitialState()){
    on<ClientFoodDiaryWholeDataGetEvent>(_get);
    on<ClientFoodDiaryWholeDataInitialEvent>(_initial);
  }

  final service = FoodDiaryService();

  Future<void> _initial(ClientFoodDiaryWholeDataInitialEvent event, Emitter<ClientFoodDiaryWholeDataState> emit) async{
    emit(ClientFoodDiaryWholeDataInitialState());
  }

  Future<void> _get(ClientFoodDiaryWholeDataGetEvent event, Emitter<ClientFoodDiaryWholeDataState> emit) async{
    emit(ClientFoodDiaryWholeDataLoadingState());

    final response = await service.getFoodDiaryForExpert(event.id, event.date);

    if(response.result){
      if(response.value != [] && response.value != null && response.value!.isNotEmpty){
        emit(ClientFoodDiaryWholeDataLoadedState(response.value, response.value?.first.dayCalories ?? 0));
      }
      else{
        emit(ClientFoodDiaryWholeDataLoadedState(response.value, 0));
      }
    }
    else{
      emit(ClientFoodDiaryWholeDataErrorState());
    }
  }
}