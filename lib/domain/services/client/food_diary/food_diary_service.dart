import 'package:garnetbook/data/models/base/base_response.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/food_diary/diets_model.dart';
import 'package:garnetbook/data/models/client/food_diary/diets_request.dart';
import 'package:garnetbook/data/models/client/food_diary/food_create_model.dart';
import 'package:garnetbook/data/models/client/food_diary/food_diary_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';


class FoodDiaryService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<ClientFoodView?>> addFoodDiary(ClientFoodCreateRequest request) async{
    try{
      final response = await client.addFoodDiaryForToday(request);

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

  Future<RequestResultModel<List<ClientFoodView>?>> getFoodDiary(DateTime date) async{
    try{
      String stringDate = DateFormat('yyyy-MM-dd').format(date);

      final response = await client.getFoodDiaryForToday(
          ClientFoodRequest(
            dateFrom: stringDate,
            dateBy: stringDate
          ));

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

  Future<RequestResultModel<List<ClientFoodView>?>> getFoodDiaryForExpert(int id, DateTime date) async{
    try{
      String stringDate = DateFormat('yyyy-MM-dd').format(date);

      final response = await client.getFoodDiaryForToday(
          ClientFoodRequest(
              dateFrom: stringDate,
              dateBy: stringDate,
              clientId: id
          ));

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

  Future<RequestResultModel<BaseResponse?>> deleteFoodDiary(int id) async{
    try{

      final response = await client.deleteFoodDiary(id);

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

  Future<RequestResultModel<BaseResponse?>> writeCommentToFoodDiaryExpert(FoodEditCommentRequest request) async{
    try{

      final response = await client.writeCommentToFoodDiaryExpert(request);

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


  Future<RequestResultModel<List<Diets>?>> getListOfDiets() async{
    try{

      final response = await client.getListOfDiets();

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


  Future<RequestResultModel<Diets?>> getOneDiet(int id) async{
    try{

      final response = await client.getOneDiet(id);

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


  Future<RequestResultModel<BaseResponse?>> createClientDiet (DietsCreate request) async{
    try{

      final response = await client.createClientDiet(request);

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


  Future<RequestResultModel<List<Diets>?>> getClientDiets (int clientId) async{
    try{

      final response = await client.getClientDiet(clientId);

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

}