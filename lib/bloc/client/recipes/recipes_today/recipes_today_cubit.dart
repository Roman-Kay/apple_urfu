
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/recipes/recipes_response.dart';
import 'package:garnetbook/domain/services/client/recipes/recipes_service.dart';

part 'recipes_today_state.dart';

class RecipesTodayCubit extends Cubit<RecipesTodayState>{
  RecipesTodayCubit() : super(RecipesTodayInitialState());

  final networkService = RecipesService();

  check() async{
    emit(RecipesTodayLoadingState());
    final response = await networkService.getRecipesForToday();
    if(response.result){
      emit(RecipesTodayLoadedState(response.value));
    }
    else{
      emit(RecipesTodayErrorState());
    }
  }
}