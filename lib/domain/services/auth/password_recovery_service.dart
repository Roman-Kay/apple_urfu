
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:garnetbook/data/models/auth/recovery_password.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class PasswordRecoveryService {
  final client = GetIt.I.get<ApiClientProvider>().client;
  final storage = SharedPreferenceData.getInstance();

  Future<RequestResultModel> changePassword(RecoveryPasswordRequest request) async {

    try{
      final response = await client.changePassword(request);

      if(response.code == 0){
        return RequestResultModel(result: true);
      }
      else{
        return RequestResultModel(result: false);
      }

    } on DioException catch(error){
      //final errorMessage = await error.response?.data['message'];
      return RequestResultModel(result: false);
    }

  }
}
