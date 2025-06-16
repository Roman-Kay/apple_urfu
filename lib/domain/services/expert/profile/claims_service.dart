
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/expert/client_claims/claims_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class ClaimsService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<ClientClaimView>?>> getExpertClaims(ClaimForExpertRequest request) async{
    try{
      final response = await client.getListOfClaims(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.claims
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