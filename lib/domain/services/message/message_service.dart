import 'dart:io';

import 'package:dio/dio.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/message/message_chat_models/file_models.dart';
import 'package:garnetbook/data/models/message/message_chat_models/list_chat_models.dart';
import 'package:garnetbook/data/models/message/message_chat_models/message_model.dart';
import 'package:garnetbook/data/models/message/message_user_models/create_user_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';


class MessageService{
  final message = GetIt.I.get<ApiClientProvider>().messageClient;
  final userMessage = GetIt.I.get<ApiClientProvider>().messageUserClient;
  final storage = SharedPreferenceData.getInstance();

  //user
  Future<RequestResultModel<CreateUserResponse?>> createUser(String token) async {
    try{
      final name = await storage.getItem(SharedPreferenceData.userNameKey);
      final role = await storage.getItem(SharedPreferenceData.role);

      if(role == "1"){
        final clientId = await storage.getItem(SharedPreferenceData.clientIdKey);

        if(name != "" && clientId != ""){
          final response = await userMessage.createUser(CreateUserRequest(
              clientToken: token,
              os: Platform.isIOS ? "IOS" : "ANDROID",
              serverSecret: "^&DF)EMSX__ASpw]--qncl",
              displayName: name ,
              id: clientId
          ));

          if(response.secret != null){
            await storage.setItem(SharedPreferenceData.secretKey, response.secret);
          }

          return RequestResultModel(result: true, value: response);
        }
      }
      else if(role == "2"){
        final expertId = await storage.getItem(SharedPreferenceData.expertIdKey);

        if(name != "" && expertId != ""){
          final response = await userMessage.createUser(CreateUserRequest(
              clientToken: token,
              os: Platform.isIOS ? "IOS" : "ANDROID",
              serverSecret: "^&DF)EMSX__ASpw]--qncl",
              displayName: name ,
              id: expertId
          ));

          if(response.secret != null){
            await storage.setItem(SharedPreferenceData.secretKey, response.secret);
          }

          return RequestResultModel(result: true, value: response);
        }
      }
      return RequestResultModel(result: false);
    } on DioException catch(error){

      String? secret = await error.response?.data['secret'];

      if(secret != null && secret != ""){
        await storage.setItem(SharedPreferenceData.secretKey, secret);

        updateUser(token, secret);
      }

      return RequestResultModel(result: false);
    }
  }

  Future<RequestResultModel<CreateUserResponse?>> updateUser(String token, String secret) async {
    try{
      final name = await storage.getItem(SharedPreferenceData.userNameKey);
      final role = await storage.getItem(SharedPreferenceData.role);

      if(role == "1"){
        final clientId = await storage.getItem(SharedPreferenceData.clientIdKey);

        if(name != "" && clientId != ""){
          final response = await userMessage.updateUser(clientId, UpdateUserRequest(
              secret: secret,
              clientToken: token,
              os: Platform.isIOS ? "IOS" : "ANDROID",
              serverSecret: "^&DF)EMSX__ASpw]--qncl",
              displayName: name ,
          ));

          if(response.secret != null){
            await storage.setItem(SharedPreferenceData.secretKey, response.secret);
            await storage.setItem(SharedPreferenceData.pushedToken, token);
          }

          return RequestResultModel(result: true, value: response);
        }
      }
      else if(role == "2"){
        final expertId = await storage.getItem(SharedPreferenceData.expertIdKey);

        if(name != "" && expertId != ""){
          final response = await userMessage.updateUser(expertId, UpdateUserRequest(
              secret: secret,
              clientToken: token,
              os: Platform.isIOS ? "IOS" : "ANDROID",
              serverSecret: "^&DF)EMSX__ASpw]--qncl",
              displayName: name ,
          ));

          if(response.secret != null){
            await storage.setItem(SharedPreferenceData.secretKey, response.secret);
            await storage.setItem(SharedPreferenceData.pushedToken, token);
          }

          return RequestResultModel(result: true, value: response);
        }
      }
      return RequestResultModel(result: false);
    } on DioException catch(error){
      return RequestResultModel(result: false);
    }
  }

  Future<RequestResultModel<CreateUserResponse?>> updateUserName(String newName) async {
    try{
      final secret = await storage.getItem(SharedPreferenceData.secretKey);
      final pushedToken = await storage.getItem(SharedPreferenceData.pushedToken);
      final role = await storage.getItem(SharedPreferenceData.role);

      if(role == "1"){
        final clientId = await storage.getItem(SharedPreferenceData.clientIdKey);

        if(pushedToken != "" && clientId != "" && secret != ""){
          final response = await userMessage.updateUser(clientId, UpdateUserRequest(
            secret: secret,
            clientToken: pushedToken,
            os: Platform.isIOS ? "IOS" : "ANDROID",
            serverSecret: "^&DF)EMSX__ASpw]--qncl",
            displayName: newName,
          ));

          if(response.secret != null){
            await storage.setItem(SharedPreferenceData.secretKey, response.secret);
          }

          return RequestResultModel(result: true, value: response);
        }
      }
      else if(role == "2"){
        final expertId = await storage.getItem(SharedPreferenceData.expertIdKey);

        if(pushedToken != "" && expertId != "" && secret != ""){
          final response = await userMessage.updateUser(expertId, UpdateUserRequest(
            secret: secret,
            clientToken: pushedToken,
            os: Platform.isIOS ? "IOS" : "ANDROID",
            serverSecret: "^&DF)EMSX__ASpw]--qncl",
            displayName: newName,
          ));

          if(response.secret != null){
            await storage.setItem(SharedPreferenceData.secretKey, response.secret);
          }

          return RequestResultModel(result: true, value: response);
        }
      }
      return RequestResultModel(result: false);
    } on DioException catch(error){
      return RequestResultModel(result: false);
    }
  }

  Future<RequestResultModel<UserDataResponse?>> getUser() async {
    try {
      final role = await storage.getItem(SharedPreferenceData.role);
      if(role == "1"){
        final clientId = await storage.getItem(SharedPreferenceData.clientIdKey);
        if(clientId != ""){
          final response = await userMessage.getUserData(clientId);

          return RequestResultModel(result: true, value: response);
        }
      }
      else if(role == "2"){
        final expertId = await storage.getItem(SharedPreferenceData.expertIdKey);
        if(expertId != ""){
          final response = await userMessage.getUserData(expertId);

          return RequestResultModel(result: true, value: response);
        }
      }

      return RequestResultModel(result: false);

    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<List<MessageChatModel>?>> getUserChatList() async {
    try {

      final role = await storage.getItem(SharedPreferenceData.role);
      String userId = "";

      if(role == "1"){
        userId = await storage.getItem(SharedPreferenceData.clientIdKey);
      }
      else{
        userId = await storage.getItem(SharedPreferenceData.expertIdKey);
      }


      if(userId != ""){
        final response = await message.getMessagesList(userId);

        return RequestResultModel(result: true, value: response.list);
      }

      return RequestResultModel(result: false);

    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel> changeClientToken() async {
    try {
      final role = await storage.getItem(SharedPreferenceData.role);

      if(role == "1"){
        final clientId = await storage.getItem(SharedPreferenceData.clientIdKey);

        if(clientId != ""){
          final response = await message.updateMessageClientToken(clientId);

          return RequestResultModel(result: true);
        }
      }
      else if(role == "2"){
        final expertId = await storage.getItem(SharedPreferenceData.expertIdKey);

        if(expertId != ""){
          final response = await message.updateMessageClientToken(expertId);

          return RequestResultModel(result: true);
        }
      }

      return RequestResultModel(result: false);

    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }



  //chat
  Future<RequestResultModel<MessageChatModel?>> getChatData(String id) async {
    try {
      final response = await message.getChatData(id);

      return RequestResultModel(result: true, value: response);
    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<CreateChatModel?>> createNewChat(CreateNewChatModel users) async {
    try {
      final response = await message.createNewChat(users);

      return RequestResultModel(result: true, value: response);
    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<MessageChatModel?>> updateChat(List<String> users) async {
    try {
      final response = await message.updateChat(users);

      return RequestResultModel(result: true, value: response);
    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<List<Message>?>> getLastChatMessages(String id, LastMessagesRequest request) async {
    try {
      final response = await message.getLastChatMessages(id, request);

      return RequestResultModel(result: true, value: response);
    } catch (error) {

      return RequestResultModel(result: false, error: error.toString());
    }
  }


  //message
  Future<RequestResultModel<Message?>> getMessage(String id) async {
    try {
      final response = await userMessage.getMessageData(id);

      return RequestResultModel(result: true, value: response);
    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<Message?>> createMessage(CreateMessage request) async {
    try {
      final response = await message.createMessage(request);

      return RequestResultModel(result: true, value: response);
    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<Message?>> updateMessage(UpdateMessage request) async {
    try {
      final response = await message.updateMessage(request);

      return RequestResultModel(result: true, value: response);
    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel> deleteMessage(String id) async {
    try {
      await message.deleteMessage(id);

      return RequestResultModel(result: true);
    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel> readMessage(MessageReadModel request) async {
    try {
      await message.readMessage(request);

      return RequestResultModel(result: true);
    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }


  //file
  Future<RequestResultModel> addFile(String id, MessageFileModels request) async {
    try {
      final response = await message.sendDocument(id, request);

      return RequestResultModel(result: true);

    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<MessageFileData>> getFile(String id) async {
    try {
      final response = await userMessage.getDocument(id);

      return RequestResultModel(result: true, value: response);

    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }
}