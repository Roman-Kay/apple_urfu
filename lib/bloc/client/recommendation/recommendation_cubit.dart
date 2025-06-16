
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_models.dart';
import 'package:garnetbook/domain/services/client/recommendation/recommendation_service.dart';

part "recommendation_state.dart";

class RecommendationCubit extends Cubit<RecommendationState>{
  RecommendationCubit() : super(RecommendationInitialState());

  final service = RecommendationService();

  check() async{
    emit(RecommendationLoadingState());

    final response = await service.getRecommendation();

    if(response.result){
      emit(RecommendationLoadedState(response.value));
    }
    else{
      emit(RecommendationErrorState());
    }
  }
}