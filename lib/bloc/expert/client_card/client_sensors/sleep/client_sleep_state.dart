
part of "client_sleep_bloc.dart";

abstract class ClientSleepState{}

class ClientSleepInitialState extends ClientSleepState{}

class ClientSleepLoadingState extends ClientSleepState{}

class ClientSleepLoadedState extends ClientSleepState{
  List<ClientSensorsView>? list;

  ClientSleepLoadedState(this.list);
}

class ClientSleepErrorState extends ClientSleepState{}