

import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/sensors/activated_sensors.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class ActivatedSensorsService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<ClientActivatedSensorsView>?>> getActivatedSensorsList() async{
    try{
      final response = await client.getActivatedSensors();
      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.activatedSensors
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

  Future<RequestResultModel<List<ClientActivatedSensorsView>?>> changeActivatedSensorsList(UpdateClientActivatedSensorsRequest request) async{
    try{
      final response = await client.changeActivatedSensors(request);
      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.activatedSensors
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