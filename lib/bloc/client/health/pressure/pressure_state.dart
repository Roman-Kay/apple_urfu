
part of 'pressure_bloc.dart';

class PressureState{}

class PressureInitialState extends PressureState{}

class PressureLoadingState extends PressureState{}

class PressureLoadedState extends PressureState{
  ClientSensorsView? currentVal;
  List<ClientSensorsView>? list;
  DateTime date;
  bool isRequested;

  PressureLoadedState({
    this.currentVal,
    this.list,
    required this.isRequested,
    required this.date
});
}

class PressureErrorState extends PressureState{}

class PressureNotConnectedState extends PressureState{}
