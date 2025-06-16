
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/expert/profile/experience_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class ExperienceService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<ExpertExperienceView>?>> getExpertExperience() async{
    try{
      final response = await client.getExpertExperience();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.experiences
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

  Future<RequestResultModel<List<ExpertExperienceView>?>> addExpertExperience(ExpertExperienceRequest request) async{
    try{
      final response = await client.addExpertExperience(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.experiences
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

  Future<RequestResultModel> deleteExperience(int id) async{
    try{
      final response = await client.deleteExpertExperience(id);
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