
part of 'recipes_today_cubit.dart';

class RecipesTodayState{}

class RecipesTodayInitialState extends RecipesTodayState{}

class RecipesTodayLoadingState extends RecipesTodayState{}

class RecipesTodayLoadedState extends RecipesTodayState{
  List<RecipesView>? view;
  RecipesTodayLoadedState(this.view);
}

class RecipesTodayErrorState extends RecipesTodayState{}