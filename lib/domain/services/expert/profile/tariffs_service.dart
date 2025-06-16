
import 'package:garnetbook/data/models/base/base_response.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/expert/tariffs/tarrifs_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class TariffsExpertService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<ExpertTariffView>?>> getExpertTariffs(int id) async{
    try{
      final response = await client.getExpertTariff(id);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.expertTariffs
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

  Future<RequestResultModel<List<ExpertTariffView>?>> addExpertTariffs(ExpertTariffCreateRequest request) async{
    try{
      final response = await client.addExpertsTariff(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.expertTariffs
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

  Future<RequestResultModel<BaseResponse?>> deleteExpertTariffs(int id) async{
    try{
      final response = await client.deleteExpertTariff(id);

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
}