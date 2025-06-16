
part of "client_blood_glucose_bloc.dart";

abstract class ClientBloodGlucoseEvent{}

class ClientBloodGlucoseGetEvent extends ClientBloodGlucoseEvent{
  int id;
  DateTime startDate;
  ClientBloodGlucoseGetEvent(this.id, this.startDate);
}