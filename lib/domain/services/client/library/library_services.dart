
import 'package:garnetbook/data/models/base/base_response.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/library/library_categories_model.dart';
import 'package:garnetbook/data/models/client/library/library_favorites_model.dart';
import 'package:garnetbook/data/models/client/library/library_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class LibraryNetworkServices{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<LibraryView>?>> getArticleByCategory(int id) async{
    try{
      final response = await client.getArticleByCategory(id);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.library
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

  Future<RequestResultModel<List<LibraryCategoriesView>?>> getCategories() async{
    try{
      final response = await client.getCategoriesLibrary();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.categories
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

  Future<RequestResultModel<LibraryFavoritesView?>> getFavorite(LibraryFavoritesRequest request) async{
    try{
      final response = await client.addFavoritesArticle(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.libraryFavorite
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

  Future<RequestResultModel<BaseResponse?>> deleteFavorites(int favoriteId) async{
    try{
      final response = await client.deleteFavoritesArticle(favoriteId);

      if(response.code == 0){
        return RequestResultModel(
            result: true
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