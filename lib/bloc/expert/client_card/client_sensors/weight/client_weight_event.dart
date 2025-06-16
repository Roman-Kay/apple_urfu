
part of "client_weight_bloc.dart";

abstract class ClientWeightEvent{}

class ClientWeightGetEvent extends ClientWeightEvent{
  int id;
  int dayQuantity;
  DateTime startDate;
  ClientWeightGetEvent(this.id, this.dayQuantity, this.startDate);
}