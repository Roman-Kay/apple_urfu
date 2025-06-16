
part of "client_blood_glucose_bloc.dart";

abstract class ClientBloodGlucoseState{}

class ClientBloodGlucoseInitialState extends ClientBloodGlucoseState{}

class ClientBloodGlucoseLoadingState extends ClientBloodGlucoseState{}

class ClientBloodGlucoseLoadedState extends ClientBloodGlucoseState{
  List<ClientSensorsView>? currentVal;
  ClientBloodGlucoseLoadedState(this.currentVal);
}

class ClientBloodGlucoseErrorState extends ClientBloodGlucoseState{}