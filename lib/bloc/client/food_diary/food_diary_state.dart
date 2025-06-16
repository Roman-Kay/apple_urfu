

part of 'food_diary_bloc.dart';

class FoodDiaryState{}

class FoodDiaryInitialState extends FoodDiaryState{}

class FoodDiaryLoadingState extends FoodDiaryState{}

class FoodDiaryErrorState extends FoodDiaryState{
  String error;
  FoodDiaryErrorState(this.error);
}

class FoodDiaryGetState extends FoodDiaryState{
  List<ClientFoodView>? food;
  int dayCalorie;
  FoodDiaryGetState(this.food, this.dayCalorie);
}

