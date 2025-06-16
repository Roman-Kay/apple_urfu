
part of 'client_pulse_bloc.dart';

class ClientPulseEvent{}

class ClientPulseGetEvent extends ClientPulseEvent{
  int clientId;
  DateTime startDate;
  ClientPulseGetEvent(this.clientId, this.startDate);
}