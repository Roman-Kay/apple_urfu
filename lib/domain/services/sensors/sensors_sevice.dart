
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/activity/activity_request.dart';
import 'package:garnetbook/data/models/client/activity/activity_response.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';


class SensorsService {
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<ClientSensorsResponse?>> getClientSensors() async {
    try {
      final response = await client.getClientSensors();

      if(response.code == 0){
        return RequestResultModel(result: true, value: response);
      }
      else{
        return RequestResultModel(result: false);
      }


    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<ClientSensorsResponse?>> createSensorsMeasurement(CreateClientSensorsRequest request) async {
    try {
      final response = await client.createSensorMeasurement(request);

      if(response.code == 0){
        return RequestResultModel(result: true, value: response);
      }
      else{
        return RequestResultModel(result: false);
      }


    } catch (e) {
      return RequestResultModel(result: false, error: e.toString());
    }
  }

  Future<RequestResultModel<ClientSensorsResponse?>> getSensorsForDay(ClientSensorDayRequest request) async {
    try {
      final response = await client.getSensorsForDay(request);

      if(response.code == 0){
        return RequestResultModel(result: true, value: response);
      }
      else{
        return RequestResultModel(result: false);
      }

      return RequestResultModel(result: true, value: response);
    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<ClientSensorsResponse?>> getSensorsForHours(ClientSensorHoursRequest request) async {
    try {
      final response = await client.getSensorsForHours(request);

      if(response.code == 0){
        return RequestResultModel(result: true, value: response);
      }
      else{
        return RequestResultModel(result: false);
      }


    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<List<ClientActivityView>?>> getSensorsActivity(PeriodDateRequest request) async {
    try {
      final response = await client.getActivity(request);

      if(response.code == 0){
        return RequestResultModel(result: true, value: response.activities);
      }
      else{
        return RequestResultModel(result: false);
      }


    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<List<ClientActivityView>?>> getSensorsActivityForExpert(int id, PeriodDateRequest request) async {
    try {
      final response = await client.getActivityForExpert(id, request);

      if(response.code == 0){
        return RequestResultModel(result: true, value: response.activities);
      }
      else{
        return RequestResultModel(result: false);
      }


    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<List<ClientActivityView>?>> setSensorsActivity(ClientActivityRequest request) async {
    try {
      final response = await client.createActivityMeasurement(request);

      if(response.code == 0){
        return RequestResultModel(result: true, value: response.activities);
      }
      else{
        return RequestResultModel(result: false);
      }


    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }
}
