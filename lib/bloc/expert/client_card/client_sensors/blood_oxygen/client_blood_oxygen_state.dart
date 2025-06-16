
part of "client_blood_oxygen_bloc.dart";

abstract class ClientBloodOxygenState{}

class ClientBloodOxygenInitialState extends ClientBloodOxygenState{}

class ClientBloodOxygenLoadingState extends ClientBloodOxygenState{}

class ClientBloodOxygenLoadedState extends ClientBloodOxygenState{
  List<ClientSensorsView>? currentVal;
  ClientBloodOxygenLoadedState(this.currentVal);
}

class ClientBloodOxygenErrorState extends ClientBloodOxygenState{}