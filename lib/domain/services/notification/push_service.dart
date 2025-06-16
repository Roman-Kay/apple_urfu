
import 'package:flutter/material.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/notificaton/push_list_model.dart';
import 'package:garnetbook/data/models/notificaton/push_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class PushService{
  final message = GetIt.I.get<ApiClientProvider>().messageClient;
  final storage = SharedPreferenceData.getInstance();

  Future<RequestResultModel<PushSendView?>> sendPush(String text, String clientId) async {
    try{

      debugPrint("AAAAAAAAAAAAAAAAA");
      debugPrint(text);
      debugPrint(clientId);

      final response = await message.sendPush(PushSendModel(
          readed: false,
          text: text,
          userId: clientId
      ));

      return RequestResultModel(result: true, value: response);
    } catch(error){
      return RequestResultModel(result: false);
    }
  }

  Future<RequestResultModel<PushSendView?>> readPush(String id) async {
    try{
      final response = await message.readPush(id, PushReadView(readed: true));

      return RequestResultModel(result: true, value: response);
    } catch(error){
      return RequestResultModel(result: false);
    }
  }

  Future<RequestResultModel<PushSendView?>> getPush(String id) async {
    try{
      final response = await message.getPush(id);

      return RequestResultModel(result: true, value: response);
    } catch(error){
      return RequestResultModel(result: false);
    }
  }

  Future<RequestResultModel<PushListView?>> getPushList() async {
    try{
      final response = await message.getPushList();

      return RequestResultModel(result: true, value: response);
    } catch(error){
      return RequestResultModel(result: false);
    }
  }
}