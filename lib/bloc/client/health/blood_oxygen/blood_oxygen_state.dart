
part of "blood_oxygen_bloc.dart";

class BloodOxygenState{}

class BloodOxygenInitialState extends BloodOxygenState{}

class BloodOxygenLoadingState extends BloodOxygenState{}

class BloodOxygenLoadedState extends BloodOxygenState{
  ClientSensorsView? currentVal;
  List<ClientSensorsView>? list;
  DateTime date;
  bool isRequested;

  BloodOxygenLoadedState({
    required this.currentVal,
    required this.list,
    required this.date,
    required this.isRequested
  });
}

class BloodOxygenErrorState extends BloodOxygenState{}

class BloodOxygenNotConnectedState extends BloodOxygenState{}
