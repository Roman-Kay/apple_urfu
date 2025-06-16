
part of 'activated_sensors_bloc.dart';

class ActivatedSensorsState{}

class ActivatedSensorsInitialState extends ActivatedSensorsState{}

class ActivatedSensorsLoadingState extends ActivatedSensorsState{}

class ActivatedSensorsLoadedState extends ActivatedSensorsState{
  List<ClientActivatedSensorsView>? view;
  ActivatedSensorsLoadedState(this.view);
}

class ActivatedSensorsErrorState extends ActivatedSensorsState{}