
import 'package:garnetbook/data/models/base/base_response.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/water_diary/water_diary_model.dart';
import 'package:garnetbook/data/models/client/water_diary/water_update_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class WaterDiaryService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<ClientWaterView>?>> getWaterDiary(ClientWaterRequest request) async{
    try{

      final response = await client.getWaterDiary(request);

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

  Future<RequestResultModel<ClientWaterView?>> addWaterDiary(ClientWaterUpdateRequest request) async{
    try{

      final response = await client.addWaterToDiary(request);

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

  Future<RequestResultModel<BaseResponse?>> deleteWaterDiary(int id) async{
    try{

      final response = await client.deleteWaterDiary(id);

      if(response.code == 0){
        return RequestResultModel(result: true);
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