
part of 'client_sensors_water_bloc.dart';

class ClientSensorWaterEvent{}

class ClientSensorWaterGetEvent extends ClientSensorWaterEvent{
  int id;
  int month;
  int year;
  ClientSensorWaterGetEvent(this.id, this.month, this.year);
}