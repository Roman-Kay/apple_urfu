
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/expert/recommendation/recommendation_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class RecommendationService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<ExpertRecommendationsView>?>> getExpertRecommendation() async{
    try{
      final response = await client.getExpertRecommendations();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.recommendations
        );
      }
      else{
        return RequestResultModel(
            result: false
        );
      }

    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  Future<RequestResultModel<List<ExpertRecommendationsView>?>> addExpertRecommendation(ExpertRecommendationsRequest request) async{
    try{
      final response = await client.addExpertRecommendations(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.recommendations
        );
      }
      else{
        return RequestResultModel(
            result: false
        );
      }

    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }
}