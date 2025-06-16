
part of 'client_sensors_water_bloc.dart';

class ClientSensorWaterState{}

class ClientSensorWaterInitialState extends ClientSensorWaterState{}

class ClientSensorWaterLoadingState extends ClientSensorWaterState{}

class ClientSensorWaterLoadedState extends ClientSensorWaterState{
  List<ClientWaterOfDayView>? view;
  ClientSensorWaterLoadedState(this.view);
}

class ClientSensorWaterErrorState extends ClientSensorWaterState{}
