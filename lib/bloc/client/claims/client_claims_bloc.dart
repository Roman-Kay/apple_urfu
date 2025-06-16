
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/claims/claims_model.dart';
import 'package:garnetbook/data/models/expert/client_claims/claims_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/client/claims/claims_service.dart';

part 'client_claims_event.dart';
part 'client_claims_state.dart';

class ClientClaimsBloc extends Bloc<ClientClaimsEvent, ClientClaimsState>{
  ClientClaimsBloc() : super(ClientClaimsInitialState()){
    on<ClientClaimsGetEvent>(_get);
    on<ClientClaimsCreateEvent>(_create);
  }

  final networkService = ClaimsService();
  final storage = SharedPreferenceData.getInstance();

  Future<void> _get(ClientClaimsGetEvent event, Emitter<ClientClaimsState> emit) async{
    emit(ClientClaimsLoadingState());

    final clientId = await storage.getItem(SharedPreferenceData.clientIdKey);
    if(clientId != ""){
      final request = ClientClaimRequest(clientId: int.parse(clientId));
      final response = await networkService.getClaims(request);
      if(response.result){
        emit(ClientClaimsLoadedState(response.value));
      }else{
        emit(ClientClaimsErrorState());
      }
    }
    else{
      emit(ClientClaimsErrorState());
    }

  }

  Future<void> _create(ClientClaimsCreateEvent event, Emitter<ClientClaimsState> emit) async{
    emit(ClientClaimsLoadingState());
    final response = await networkService.createClaims(event.request);
    if(response.result){
      emit(ClientClaimsLoadedState(response.value));
    }else{
      emit(ClientClaimsErrorState());
    }
  }
}