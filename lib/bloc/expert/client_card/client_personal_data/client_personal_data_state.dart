
part of "client_personal_data_bloc.dart";

class ClientCardPersonalDataState{}

class ClientCardPersonalDataInitialState extends ClientCardPersonalDataState{}

class ClientCardPersonalDataLoadingState extends ClientCardPersonalDataState{}

class ClientCardPersonalDataLoadedState extends ClientCardPersonalDataState{
  CardClientInfoResponse? client;
  ClientCardPersonalDataLoadedState(this.client);
}

class ClientCardPersonalDataErrorState extends ClientCardPersonalDataState{}