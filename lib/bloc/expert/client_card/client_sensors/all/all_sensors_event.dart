
part of 'all_sensors_bloc.dart';

class AllSensorsEvent{}

class AllSensorsGetEvent extends AllSensorsEvent{
  int clientId;
  DateTime date;
  AllSensorsGetEvent(this.date, this.clientId);
}