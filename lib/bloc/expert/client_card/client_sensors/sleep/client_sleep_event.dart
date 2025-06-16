
part of "client_sleep_bloc.dart";

abstract class ClientSleepEvent{}

class ClientSleepGetEvent extends ClientSleepEvent{
  int id;
  int dayQuantity;
  DateTime startDate;
  ClientSleepGetEvent(this.id, this.dayQuantity, this.startDate);
}