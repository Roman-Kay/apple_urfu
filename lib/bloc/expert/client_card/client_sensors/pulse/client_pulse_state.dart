
part of 'client_pulse_bloc.dart';

class ClientPulseState{}

class ClientPulseInitialState extends ClientPulseState{}

class ClientPulseLoadingState extends ClientPulseState{}

class ClientPulseLoadedState extends ClientPulseState{
  List<ClientSensorsView>? currentVal;
  ClientPulseLoadedState(this.currentVal);
}

class ClientPulseErrorState extends ClientPulseState{}