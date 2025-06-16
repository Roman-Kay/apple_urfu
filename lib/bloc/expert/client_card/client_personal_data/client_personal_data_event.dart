
part of "client_personal_data_bloc.dart";

class ClientCardPersonalDataEvent{}

class ClientCardPersonalDataGetEvent extends ClientCardPersonalDataEvent{
  int id;
  ClientCardPersonalDataGetEvent(this.id);
}