
part of 'claims_bloc.dart';

class ClaimsExpertState{}

class ClaimsExpertInitialState extends ClaimsExpertState{}

class ClaimsExpertLoadingState extends ClaimsExpertState{}

class ClaimsExpertLoadedState extends ClaimsExpertState{
  List<ClientClaimView>? view;
  ClaimsExpertLoadedState(this.view);
}

class ClaimsExpertErrorState extends ClaimsExpertState{}