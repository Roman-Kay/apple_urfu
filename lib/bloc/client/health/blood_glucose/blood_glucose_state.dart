
part of "blood_glucose_bloc.dart";

class BloodGlucoseState{}

class BloodGlucoseInitialState extends BloodGlucoseState{}

class BloodGlucoseLoadingState extends BloodGlucoseState{}

class BloodGlucoseLoadedState extends BloodGlucoseState{
  ClientSensorsView? currentVal;
  List<ClientSensorsView>? list;
  DateTime date;
  bool isRequested;

  BloodGlucoseLoadedState({
    required this.currentVal,
    required this.list,
    required this.date,
    required this.isRequested
});
}

class BloodGlucoseErrorState extends BloodGlucoseState{}

class BloodGlucoseNotConnectedState extends BloodGlucoseState{}

