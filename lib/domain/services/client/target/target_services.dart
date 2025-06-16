
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/target/create_target_model.dart';
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class TargetNetworkServices{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<ClientTargetsView>?>> getClientTargets() async{
    try{
      final storage = SharedPreferenceData.getInstance();
      final response = await client.getClientTarget();

      final targetKey = await storage.getItem(SharedPreferenceData.userTargetKey);

      if(response.isNotEmpty && targetKey != response.first.target?.name.toString()){
        storage.setItem(SharedPreferenceData.userTargetKey, response.first.target?.name.toString());
      }

      return RequestResultModel(
          result: true,
          value: response
      );
    }on DioException catch(error){

      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  Future<RequestResultModel<ClientTargetsView?>> addClientTargets(ClientTargetsUpdateRequest request) async{
    try{
      final response = await client.addTarget(request);

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