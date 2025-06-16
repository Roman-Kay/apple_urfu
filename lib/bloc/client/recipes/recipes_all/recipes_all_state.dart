
part of 'recipes_all_cubit.dart';

class RecipesAllState{}

class RecipesAllInitialState extends RecipesAllState{}

class RecipesAllLoadingState extends RecipesAllState{}

class RecipesAllLoadedState extends RecipesAllState{
  List<RecipesView>? view;
  RecipesAllLoadedState(this.view);
}

class RecipesAllErrorState extends RecipesAllState{}