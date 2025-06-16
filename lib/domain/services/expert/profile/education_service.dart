
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/expert/profile/education_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class EducationService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<ExpertEducationView>?>> getExpertEducation() async{
    try{
      final response = await client.getExpertEducation();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.educations
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

  Future<RequestResultModel<List<ExpertEducationView>?>> addExpertEducation(ExpertEducationRequest request) async{
    try{
      final response = await client.addExpertEducation(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.educations
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

  Future<RequestResultModel> deleteEducation(int id) async{
    try{
      final response = await client.deleteExpertEducation(id);
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