import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:garnetbook/data/models/base/base_response.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/recipes/recipes_favorites.dart';
import 'package:garnetbook/data/models/client/recipes/recipes_response.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';


class RecipesService{
  final client = GetIt.I.get<ApiClientProvider>().client;
  final storage = SharedPreferenceData.getInstance();

  Future<RequestResultModel<List<RecipesView>?>> getRecipes() async{
    try{
      final response = await client.getAllRecipes();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.recipes
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

  Future<RequestResultModel<List<RecipesView>?>> getRecipesForToday() async{
    try{
      final response = await client.getRecipesForDay();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.recipes
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

  Future<RequestResultModel<List<RecipeFavoritesView>?>> getRecipesFavorites() async{
    try{
      final response = await client.getFavoritesRecipes();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.recipeFavorite
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

  Future<RequestResultModel<List<RecipeFavoritesView>?>> addRecipesFavorites(int? recipeId) async{
    try{
      final storage = SharedPreferenceData.getInstance();
      final userId = await storage.getUserId();

      final response = await client.addFavoritesRecipes(RecipeFavoritesRequest(
        userToId: userId != "" ? int.parse(userId) : null,
        recipeId: recipeId
      ));

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.recipeFavorite
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

  Future<RequestResultModel<BaseResponse?>> deleteRecipesFavorites(int id) async{
    try{
      final token = await storage.getToken();

      String basicAuth = 'Basic ' + base64Encode(utf8.encode('admin:1pMxpPsYOFUJYD9U'));
      final dio = Dio();
      final response = await dio.delete(
          'https://api.garnetbook.ru:20485/main/ll/recipes/favorites/$id',
          options: Options(
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'authorization': basicAuth,
              'token': token
            },
          ));
      //final response = await client.deleteFavoritesRecipes(id);

      return RequestResultModel(result: true);
    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }
}