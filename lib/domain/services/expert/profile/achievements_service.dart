
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/expert/profile/achieves_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class AchievementsService{

  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<ExpertAchievesView>?>> getExpertAchieves() async{
    try{
      final response = await client.getExpertAchieves();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.achieves
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

  Future<RequestResultModel<List<ExpertAchievesView>?>> addExpertAchieves(ExpertAchievesRequest request) async{
    var response;
    try{
      response = await client.addExpertAchieves(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.achieves
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

  Future<RequestResultModel> deleteAchieves(int id) async{
    try{
      final response = await client.deleteExpertAchieves(id);
      if(response.code == 0){
        return RequestResultModel(result: true);
      }
      else{
        return RequestResultModel(result: false);
      }
    }
    catch(error){
      return RequestResultModel(result: false);
    }
  }
}