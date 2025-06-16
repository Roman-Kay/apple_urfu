

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/expert/client_claims/claims_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/expert/profile/claims_service.dart';

part 'claims_state.dart';
part 'claims_event.dart';

class ClaimsExpertBloc extends Bloc<ClaimsExpertEvent, ClaimsExpertState>{
  ClaimsExpertBloc() : super(ClaimsExpertInitialState()){
    on<ClaimsExpertGetEvent>(_get);
  }

  final networkService = ClaimsService();
  final storage = SharedPreferenceData.getInstance();


  Future<void> _get(ClaimsExpertGetEvent event, Emitter<ClaimsExpertState> emit) async{
    emit(ClaimsExpertLoadingState());
    final response = await networkService.getExpertClaims(ClaimForExpertRequest());

    if(response.result){
      emit(ClaimsExpertLoadedState(response.value));
    }
    else{
      emit(ClaimsExpertErrorState());
    }
  }
}