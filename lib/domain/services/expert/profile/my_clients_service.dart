
import 'package:flutter/material.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/expert/my_clients/clients_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class MyClientsService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<ExpertClientsView>?>> getMyClient() async{
    try{
      final response = await client.getListOfClients();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.expertClients
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