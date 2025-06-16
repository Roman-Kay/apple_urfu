
part of "client_food_diary_bloc.dart";

abstract class ClientsCardFoodDiaryEvent{}

class ClientsCardFoodDiaryGetEvent extends ClientsCardFoodDiaryEvent{
  int id;
  int dayQuantity;
  DateTime startDate;
  ClientsCardFoodDiaryGetEvent(this.id, this.dayQuantity, this.startDate);
}

class ClientCardFoodDiaryInitialEvent extends ClientsCardFoodDiaryEvent{}
