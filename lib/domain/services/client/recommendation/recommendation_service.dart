
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_models.dart';
import 'package:garnetbook/data/models/client/recommendation/update_recommendation_models.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class RecommendationService{

  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<ClientRecommendationsResponse?>> getRecommendation() async{
    try{

      final response = await client.getClientRecommendation();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response
        );
      }
      else{
        return RequestResultModel(result: false);
      }


    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  Future<RequestResultModel<ClientRecommendationView?>> getOneRecommendation(int id) async{
    try{

      final response = await client.getOneClientRecommendation(id);

      return RequestResultModel(
          result: true,
          value: response
      );

    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  Future<RequestResultModel<ClientRecommendationView?>> createRecommendation(UpdateClientRecommendationsRequest request) async{
    try{

      final response = await client.createClientRecommendation(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.recommendation
        );
      }
      else{
        return RequestResultModel(result: false);
      }


    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }
}