
part of "client_steps_bloc.dart";

abstract class ClientStepsState{}

class ClientStepsInitialState extends ClientStepsState{}

class ClientStepsLoadingState extends ClientStepsState{}

class ClientStepsLoadedState extends ClientStepsState{
  List<ClientSensorsView>? list;

  ClientStepsLoadedState(this.list);
}

class ClientStepsErrorState extends ClientStepsState{}