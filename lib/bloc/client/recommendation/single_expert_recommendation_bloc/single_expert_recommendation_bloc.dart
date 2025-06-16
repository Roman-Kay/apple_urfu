
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_models.dart';
import 'package:garnetbook/domain/services/client/recommendation/recommendation_service.dart';

part 'single_expert_recommendation_event.dart';
part 'single_expert_recommendation_state.dart';

class SingleExpertRecommendationBloc extends Bloc<SingleExpertRecommendationEvent, SingleExpertRecommendationState>{
  SingleExpertRecommendationBloc() : super(SingleExpertRecommendationInitialState()){
    on<SingleExpertRecommendationGetEvent>(_get);
    on<SingleExpertRecommendationInitialEvent>(_initial);
  }

  final service = RecommendationService();

  Future<void> _initial(SingleExpertRecommendationInitialEvent event, Emitter<SingleExpertRecommendationState> emit) async{
    emit(SingleExpertRecommendationInitialState());
  }

  Future<void> _get(SingleExpertRecommendationGetEvent event, Emitter<SingleExpertRecommendationState> emit) async{
    emit(SingleExpertRecommendationLoadingState());

    final response = await service.getOneRecommendation(event.id);

    if(response.result){
      emit(SingleExpertRecommendationLoadedState(response.value));
    }
    else{
      emit(SingleExpertRecommendationErrorState());
    }
  }
}