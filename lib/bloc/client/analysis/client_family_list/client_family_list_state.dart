
part of 'client_family_list_bloc.dart';


class ClientFamilyListState{}

class ClientFamilyListInitialState extends ClientFamilyListState{}

class ClientFamilyListLoadingState extends ClientFamilyListState{}

class ClientFamilyListLoadedState extends ClientFamilyListState{
  List<FamilyProfile>? list;
  ClientFamilyListLoadedState(this.list);
}

class ClientFamilyListErrorState extends ClientFamilyListState{}