
part of 'client_family_list_bloc.dart';

class ClientFamilyListEvent{}

class ClientFamilyListGetEvent extends ClientFamilyListEvent{
  int clientId;
  ClientFamilyListGetEvent(this.clientId);
}