
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_models.dart';
import 'package:garnetbook/domain/services/expert/client_card_info/client_card_info.dart';

part "client_recommendation_event.dart";
part "client_recommendation_state.dart";

class ClientCardRecommendationBloc extends Bloc<ClientCardRecommendationEvent, ClientCardRecommendationState>{
  ClientCardRecommendationBloc() : super(ClientCardRecommendationInitialState()){
    on<ClientCardRecommendationGetEvent>(_get);
    on<ClientCardRecommendationInitialEvent>(_initial);
  }

  final service = ClientCardInfoService();

  Future<void> _initial(ClientCardRecommendationInitialEvent event, Emitter<ClientCardRecommendationState> emit) async{
    emit(ClientCardRecommendationInitialState());
  }

  Future<void> _get(ClientCardRecommendationGetEvent event, Emitter<ClientCardRecommendationState> emit) async{
    emit(ClientCardRecommendationLoadingState());

    final response = await service.getClientCardRecommendation(event.id);

    if(response.result){
      emit(ClientCardRecommendationLoadedState(response.value));
    }
    else{
      emit(ClientCardRecommendationErrorState());
    }
  }
}