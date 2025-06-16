

part of 'activated_sensors_bloc.dart';

class ActivatedSensorsEvent{}

class ActivatedSensorsGetEvent extends ActivatedSensorsEvent{}

class ActivatedSensorsChangeEvent extends ActivatedSensorsEvent{
  UpdateClientActivatedSensorsRequest request;
  ActivatedSensorsChangeEvent(this.request);
}