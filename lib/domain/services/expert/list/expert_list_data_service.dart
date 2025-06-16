
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/expert/list/expert_data.dart';
import 'package:garnetbook/data/models/expert/list/expert_list.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class ExpertListDataService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<ExpertShortCardResponse?>> getExpertList(int page) async{
    try{
      final response = await client.getExpertList(page, 7);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response
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

  Future<RequestResultModel<ExpertShortCardResponse?>> getMyExpertList() async{
    try{
      final response = await client.getMyExpertList();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response
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

  Future<RequestResultModel<ExpertFullCardView?>> getExpertData(int expertId) async{
    try{
      final response = await client.getExpertData(expertId);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.fullCard
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