
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_data.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';

part 'single_recommendation_event.dart';
part 'single_recommendation_state.dart';

class SingleRecommendationBloc extends Bloc<SingleRecommendationEvent, SingleRecommendationState>{
  SingleRecommendationBloc() : super(SingleRecommendationInitialState()){
    on<SingleRecommendationGetEvent>(_get);
  }

  final service = SurveyServices();

  Future<void> _get(SingleRecommendationGetEvent event, Emitter<SingleRecommendationState> emit) async{
    emit(SingleRecommendationLoadingState());

    if(event.type == "article"){
      final response = await service.getOneArticle(event.id);

      if(response.result){
        RecommendationData? data = response.value != null
            ? RecommendationData(
            id: response.value!.id,
            title: response.value!.title,
            image: response.value!.image,
            content: response.value!.content,
            pointsData: null,
            pointTitle: null
        )
            : null;
        emit(SingleRecommendationLoadedState(data));
      }
      else{
        emit(SingleRecommendationErrorState());
      }
    }
    else{
      final response = await service.getOneRecommendation(event.id);

      if(response.result){
        emit(SingleRecommendationLoadedState(response.value));
      }
      else{
        emit(SingleRecommendationErrorState());
      }
    }
  }
}