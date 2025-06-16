
part of 'client_claims_bloc.dart';

class ClientClaimsState{}

class ClientClaimsInitialState extends ClientClaimsState{}

class ClientClaimsLoadingState extends ClientClaimsState{}

class ClientClaimsLoadedState extends ClientClaimsState{
  List<ClientClaimView>? view;
  ClientClaimsLoadedState(this.view);
}

class ClientClaimsErrorState extends ClientClaimsState{}