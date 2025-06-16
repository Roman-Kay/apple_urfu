
part of "weight_bloc.dart";

class WeightState{}

class WeightInitialState extends WeightState{}

class WeightLoadingState extends WeightState{}

class WeightLoadedState extends WeightState{
  ClientSensorsView? currentVal;
  List<ClientSensorsView>? list;
  ClientTargetsView? targetView;

  WeightLoadedState({
    required this.currentVal,
    required this.list,
    required this.targetView
});
}

class WeightErrorState extends WeightState{}

class WeightNotConnectedState extends WeightState{
  ClientSensorsView? currentVal;
  List<ClientSensorsView>? list;
  ClientTargetsView? targetView;

  WeightNotConnectedState({
    required this.currentVal,
    required this.list,
    required this.targetView
});
}

