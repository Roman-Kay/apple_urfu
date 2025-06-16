
part of "client_food_diary_whole_data_bloc.dart";

class ClientFoodDiaryWholeDataEvent{}

class ClientFoodDiaryWholeDataGetEvent extends ClientFoodDiaryWholeDataEvent{
  int id;
  DateTime date;
  ClientFoodDiaryWholeDataGetEvent(this.id, this.date);
}

class ClientFoodDiaryWholeDataInitialEvent extends ClientFoodDiaryWholeDataEvent{}