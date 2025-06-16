import 'package:garnetbook/data/models/base/base_response.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/survey/balance_wheel/balance_wheel.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';


class BalanceWheelService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<BalanceWheel>?>> getBalanceWheel(BalanceWheelsRequest request) async{
    try{
      final response = await client.getBalanceWheel(request);

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

  Future<RequestResultModel<BaseResponse?>> addBalanceWheel(BalanceWheelsCreateRequest request) async{
    try{
      final response = await client.addBalanceWheelCategory(request);

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
}