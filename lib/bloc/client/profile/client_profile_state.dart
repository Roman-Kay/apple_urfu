
part of 'client_profile_bloc.dart';

class ClientProfileState{}

class ClientProfileInitialState extends ClientProfileState{}

class ClientProfileLoadingState extends ClientProfileState{}

class ClientProfileLoadedState extends ClientProfileState{
  ClientProfileView? response;
  ClientProfileLoadedState(this.response);
}

class ClientProfileErrorState extends ClientProfileState{}
