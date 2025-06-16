
part of "client_blood_oxygen_bloc.dart";

abstract class ClientBloodOxygenEvent{}

class ClientBloodOxygenGetEvent extends ClientBloodOxygenEvent{
  int id;
  DateTime startDate;
  ClientBloodOxygenGetEvent(this.id, this.startDate);
}