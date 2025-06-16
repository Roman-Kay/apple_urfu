
part of 'client_pressure_bloc.dart';

class ClientPressureState{}

class ClientPressureInitialState extends ClientPressureState{}

class ClientPressureLoadingState extends ClientPressureState{}

class ClientPressureLoadedState extends ClientPressureState{
  List<ClientSensorsView>? currentVal;
  ClientPressureLoadedState(this.currentVal);
}

class ClientPressureErrorState extends ClientPressureState{}