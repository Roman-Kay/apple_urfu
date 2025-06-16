
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/expert/profile/profile_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class ProfileExpertService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<ExpertProfileView?>> getExpertProfile() async{
    try{
      final response = await client.getExpertProfile();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.expertProfile
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