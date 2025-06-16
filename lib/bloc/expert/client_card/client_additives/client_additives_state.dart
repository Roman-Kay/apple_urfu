
part of "client_additives_bloc.dart";

class ClientAdditivesState{}

class ClientAdditivesInitialState extends ClientAdditivesState{}

class ClientAdditivesLoadingState extends ClientAdditivesState{}

class ClientAdditivesLoadedState extends ClientAdditivesState{
  ClientAdditivesResponse? view;
  ClientAdditivesLoadedState(this.view);
}

class ClientAdditivesErrorState extends ClientAdditivesState{}