
part of 'client_pressure_bloc.dart';

class ClientPressureEvent{}

class ClientPressureGetEvent extends ClientPressureEvent{
  int clientId;
  DateTime startDate;
  ClientPressureGetEvent(this.clientId, this.startDate);
}