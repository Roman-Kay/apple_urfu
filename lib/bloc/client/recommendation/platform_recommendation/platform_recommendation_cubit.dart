
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/recommendation/platform_recommendation.dart';
import 'package:garnetbook/domain/services/survey/questionnarie_service.dart';

part 'platform_recommendation_state.dart';

class PlatformRecommendationCubit extends Cubit<PlatformRecommendationState>{
  PlatformRecommendationCubit() : super(PlatformRecommendationInitialState());

  final service = QuestionnaireService();

  check() async{
    emit(PlatformRecommendationLoadingState());

    final response = await service.getListOfPlatformRecommendations();

    if(response.result){
      emit(PlatformRecommendationLoadedState(response.value));
    }
    else{
      emit(PlatformRecommendationErrorState());
    }
  }
}