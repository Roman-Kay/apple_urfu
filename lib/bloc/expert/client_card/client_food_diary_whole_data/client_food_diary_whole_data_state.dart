
part of "client_food_diary_whole_data_bloc.dart";

abstract class ClientFoodDiaryWholeDataState{}

class ClientFoodDiaryWholeDataInitialState extends ClientFoodDiaryWholeDataState{}

class ClientFoodDiaryWholeDataLoadingState extends ClientFoodDiaryWholeDataState{}

class ClientFoodDiaryWholeDataLoadedState extends ClientFoodDiaryWholeDataState{
  List<ClientFoodView>? food;
  int dayCalorie;
  ClientFoodDiaryWholeDataLoadedState(this.food, this.dayCalorie);
}

class ClientFoodDiaryWholeDataErrorState extends ClientFoodDiaryWholeDataState{}