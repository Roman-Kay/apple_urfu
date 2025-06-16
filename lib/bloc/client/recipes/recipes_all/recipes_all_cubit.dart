
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/recipes/recipes_response.dart';
import 'package:garnetbook/domain/services/client/recipes/recipes_service.dart';

part 'recipes_all_state.dart';

class RecipesAllCubit extends Cubit<RecipesAllState>{
  RecipesAllCubit() : super(RecipesAllInitialState());

  final networkService = RecipesService();

  check() async{
    emit(RecipesAllLoadingState());
    final response = await networkService.getRecipes();
    if(response.result){
      emit(RecipesAllLoadedState(response.value));
    }
    else{
      emit(RecipesAllErrorState());
    }
  }
}