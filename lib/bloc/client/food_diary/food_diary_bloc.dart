
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/food_diary/food_diary_model.dart';
import 'package:garnetbook/domain/services/client/food_diary/food_diary_service.dart';

part 'food_diary_state.dart';
part 'food_diary_event.dart';

class FoodDiaryBloc extends Bloc<FoodDiaryEvent,FoodDiaryState>{
  FoodDiaryBloc() : super(FoodDiaryLoadingState()){
    on<FoodDiaryGetEvent>(_getFoodDiary);
  }

  final networkService = FoodDiaryService();


  Future<void> _getFoodDiary(FoodDiaryGetEvent event, Emitter<FoodDiaryState> emit) async{
    emit(FoodDiaryLoadingState());
    final response = await networkService.getFoodDiary(event.date);

    if(response.result == true){
      if(response.value != null && response.value!.isNotEmpty){
        emit(FoodDiaryGetState(response.value, response.value?.first.dayCalories ?? 0));
      }
      else{
        emit(FoodDiaryGetState(response.value, 0));
      }
    }
    else if(response.error != null && response.error != ""){
      emit(FoodDiaryErrorState(response.error!));
    }
    else{
      emit(FoodDiaryInitialState());
    }
  }
}