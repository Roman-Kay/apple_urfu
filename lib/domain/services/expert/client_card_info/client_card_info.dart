
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/additives/additives_model.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_event_model.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_models.dart';
import 'package:garnetbook/data/models/client/trackers/tracker_request.dart';
import 'package:garnetbook/data/models/client/trackers/tracker_response.dart';
import 'package:garnetbook/data/models/expert/card_info/additives.dart';
import 'package:garnetbook/data/models/expert/card_info/card_info.dart';
import 'package:garnetbook/data/models/expert/card_info/food_diary.dart';
import 'package:garnetbook/data/models/expert/client_claims/claims_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class ClientCardInfoService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<CardClientInfoResponse?>> getClientCardInfo(int id) async{
    try{
      final response = await client.getClientCardInfo(id);

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

  Future<RequestResultModel<List<ClientFoodOfDayView>?>> getClientCardInfoFoodDiary(ClientFoodRequestExpert request) async{
    try{
      final response = await client.getClientCardInfoFoodDiary(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.foods
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

  Future<RequestResultModel<List<ClientWaterOfDayView>?>> getClientCardInfoWaterDiary(ClientFoodRequestExpert request) async{
    try{
      final response = await client.getClientCardInfoWaterDiary(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.waters
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

  Future<RequestResultModel<List<ClientTrackerView>?>> getClientCardInfoTrackers(int id) async{
    try{
      final response = await client.getClientTrackerFromExpert(id);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.trackers
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

  Future<RequestResultModel<List<ClientTrackerView>?>> setClientCardInfoTrackers(ClientTrackerRequest request) async{
    try{
      final response = await client.setClientTrackerFromExpert(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.trackers
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

  Future<RequestResultModel<CardClientInfoResponse?>> setClientAnamnesis(EditFieldRequest request) async{
    try{
      final response = await client.setClientAnamnesis(request);

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

  Future<RequestResultModel<CardClientInfoResponse?>> setClientDiagnosis(EditFieldRequest request) async{
    try{
      final response = await client.setClientDiagnosis(request);

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

  Future<RequestResultModel<CardClientInfoResponse?>> setClientReason(EditFieldRequest request) async{
    try{
      final response = await client.setClientReason(request);

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

  Future<RequestResultModel<ClientAdditivesResponse?>> getClientCardInfoAdditives(int id) async{
    try{
      final response = await client.getClientAdditivesByExpert(id);

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

  Future<RequestResultModel<List<ClientRecommendationShortView>?>> getClientCardRecommendation(int id) async{
    try{
      final response = await client.getClientCardRecommendation(id);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.recommendations
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