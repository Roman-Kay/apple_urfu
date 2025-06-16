
part of "client_additives_bloc.dart";

class ClientAdditivesEvent{}

class ClientAdditivesGetEvent extends ClientAdditivesEvent{
  int id;
  ClientAdditivesGetEvent(this.id);
}

class ClientAdditivesInitialEvent extends ClientAdditivesEvent{}