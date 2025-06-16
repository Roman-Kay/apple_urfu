
part of 'client_claims_bloc.dart';

class ClientClaimsEvent{}

class ClientClaimsCreateEvent extends ClientClaimsEvent{
  CreateClientClaimRequest request;
  ClientClaimsCreateEvent(this.request);
}

class ClientClaimsGetEvent extends ClientClaimsEvent{}