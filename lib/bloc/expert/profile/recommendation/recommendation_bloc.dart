
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/expert/recommendation/recommendation_model.dart';
import 'package:garnetbook/domain/services/expert/profile/recommendation_service.dart';

part 'recommendation_event.dart';
part 'recommendation_state.dart';

class RecommendationExpertBloc extends Bloc<RecommendationExpertEvent, RecommendationExpertState>{
  RecommendationExpertBloc() : super(RecommendationExpertInitialState()){
    on<RecommendationAddEvent>(_add);
    on<RecommendationGetEvent>(_get);
  }

  final service = RecommendationService();

  Future<void> _get(RecommendationGetEvent event, Emitter<RecommendationExpertState> emit) async{
    emit(RecommendationExpertLoadingState());
    final response = await service.getExpertRecommendation();
    if(response.result){
      emit(RecommendationExpertLoadedState(response.value));
    }
    else{
      emit(RecommendationExpertErrorState());
    }
  }

  Future<void> _add(RecommendationAddEvent event, Emitter<RecommendationExpertState> emit) async{
    emit(RecommendationExpertLoadingState());
    final response = await service.addExpertRecommendation(event.request);
    if(response.result){
      emit(RecommendationExpertLoadedState(response.value));
    }
    else{
      emit(RecommendationExpertErrorState());
    }
  }
}