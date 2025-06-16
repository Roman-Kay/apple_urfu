
part of "client_weight_bloc.dart";

abstract class ClientWeightState{}

class ClientWeightInitialState extends ClientWeightState{}

class ClientWeightLoadingState extends ClientWeightState{}

class ClientWeightLoadedState extends ClientWeightState{
  ClientSensorsView? currentVal;
  List<ClientSensorsView>? list;
  ClientTargetsView? targetView;

  ClientWeightLoadedState({
    this.currentVal,
    this.list,
    this.targetView
});
}

class ClientWeightErrorState extends ClientWeightState{}