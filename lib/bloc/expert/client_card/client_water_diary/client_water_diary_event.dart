
part of "client_water_diary_bloc.dart";

class ClientsCardWaterDiaryEvent{}

class ClientsCardWaterDiaryGetEvent extends ClientsCardWaterDiaryEvent{
  int id;
  int dayQuantity;
  DateTime startDate;
  ClientsCardWaterDiaryGetEvent(this.id, this.dayQuantity, this.startDate);
}

class ClientsCardWaterDiaryForFoodDiaryEvent extends ClientsCardWaterDiaryEvent{
  int id;
  DateTime date;
  ClientsCardWaterDiaryForFoodDiaryEvent(this.id, this.date);
}

class ClientsCardWaterDiaryInitialEvent extends ClientsCardWaterDiaryEvent{}