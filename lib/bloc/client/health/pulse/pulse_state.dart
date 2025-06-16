
part of "pulse_bloc.dart";

class PulseState{}

class PulseInitialState extends PulseState{}

class PulseLoadingState extends PulseState{}

class PulseLoadedState extends PulseState{
  ClientSensorsView? currentVal;
  List<ClientSensorsView>? list;
  DateTime date;

  PulseLoadedState({
    this.list,
    this.currentVal,
    required this.date
});
}

class PulseErrorState extends PulseState{}
