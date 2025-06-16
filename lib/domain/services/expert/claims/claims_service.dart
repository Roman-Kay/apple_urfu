
import 'package:garnetbook/data/models/base/base_response.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/expert/client_claims/client_claim_operation.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class ExpertClaimsService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<BaseResponse?>> setClientClaimOperation(ClaimOperationRequest request) async{
    try{
      final response = await client.setClientClaimsOperation(request);

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