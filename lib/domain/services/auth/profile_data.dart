import 'dart:async';

import 'package:dio/dio.dart';
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/profile/client_profile_update_model.dart';
import 'package:garnetbook/data/models/expert/profile/expert_profile.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileDataService{
  final client = GetIt.I.get<ApiClientProvider>().client;
  final storage = SharedPreferenceData.getInstance();

  Future<RequestResultModel> updateUser(UserUpdateRequest request) async {
    try {
      final response = await client.updateUser(request);

      if (response.code == 0) {
        if(response.id != null){
          await getUser(response.id!);
        }
        return RequestResultModel(result: true);
      }
      else {
        return RequestResultModel(result: false, error: response.message);
      }
    } on DioException catch (error) {
      final errorMessage = await error.response?.data['message'];
      return RequestResultModel(result: false, error: errorMessage);
    }
  }

  Future<RequestResultModel> getUser(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await client.getUserInformation(userId);

      if (response.code == 0) {
        final token = await response.user?.token;
        final role = await response.user?.role?.id;
        final profileId = await response.user?.profileId;
        final newUserId = await response.user?.id;
        final name = await response.user?.firstName;
        final gender = await response.user?.gender?.name;
        final email = await response.user?.email;
        final bday = await response.user?.birthDate;

        if (newUserId != null) {
          await storage.setUserId(newUserId.toString());
        }

        if (role != null) {
          await storage.setItem(SharedPreferenceData.role, role.toString());

          if (role == 1 && profileId != null) {
            await storage.setItem(SharedPreferenceData.clientIdKey, profileId.toString());
          } else if (role == 2 && profileId != null) {
            await storage.setItem(SharedPreferenceData.expertIdKey, profileId.toString());
          }
        }

        if (token != null) {
          ApiClientProvider().saveToken(token);
          await storage.setToken(token);

          if (name != null) {
            await storage.setItem(SharedPreferenceData.userNameKey, name);
          }

          if (email != null) {
            await storage.setItem(SharedPreferenceData.userEmailKey, email);
          }

          if (bday != null) {
            await storage.setItem(SharedPreferenceData.userBdayKey, bday);
          }

          if (gender != null) {
            await storage.setItem(SharedPreferenceData.userGenderKey, gender);
          }

          prefs.setBool('isLogged', true);
          ApiClientProvider().setApiClientProvider();
        }

        return RequestResultModel(result: true);
      }
      else {
        return RequestResultModel(result: false, error: response.message);
      }
    } on DioException catch (error) {
      final errorMessage = await error.response?.data['message'];
      return RequestResultModel(result: false, error: errorMessage);
    }
  }


  Future<RequestResultModel> setProfileExpert(ExpertProfileCreateRequest request) async {
    try {
      final response = await client.createProfileExpert(request);
      if (response.code == 0) {
        if(response.expertProfile != null && response.expertProfile?.id != null){
          await storage.setItem(SharedPreferenceData.expertIdKey, response.expertProfile?.id.toString());
        }
        return RequestResultModel(result: true);
      }
      else {
        return RequestResultModel(result: false);
      }
    } catch (error) {
      return RequestResultModel(result: false);
    }
  }


  Future<RequestResultModel> setProfileClient(String weight, String height) async {
    try {
      final userId = await storage.getUserId();

      int userHeightInt = int.parse(height);
      double userHeight = userHeightInt / 100;
      int userWeight = int.parse(weight);

      double imt = userWeight / (userHeight * userHeight);
      String target = "";

      if (imt <= 18.5) {
        target = "Набрать вес";
      } else if (imt >= 25.1) {
        target = "Сбросить вес";
      }else{
        target = "Удержать вес";
      }

      final response = await client.updateClientProfile(CreateClientRequest(
          height: int.parse(height),
          userId: userId != "" ? int.parse(userId) : null,
          weight: int.parse(weight),
          target: target));


      if(response.code == 0){
        if(response.id != null){
          await storage.setItem(SharedPreferenceData.clientIdKey, response.id!.toString());
          await storage.setItem(SharedPreferenceData.userTargetKey, target);
          await storage.setItem(SharedPreferenceData.userWeightKey, weight);
          await storage.setItem(SharedPreferenceData.userHeightKey, height);
        }
        return RequestResultModel(result: true);
      }
      else{
        return RequestResultModel(result: false);
      }
    } catch (error) {
      return RequestResultModel(result: false, error: error.toString());
    }
  }


  Future<RequestResultModel> updateClientProfile(String weight, String height) async {
    try{
      final clientId = await storage.getItem(SharedPreferenceData.clientIdKey) == "" ? "" : await storage.getItem(SharedPreferenceData.clientIdKey);

      final userId = await storage.getUserId();

      final response = await client.updateClientProfile(
          CreateClientRequest(
              clientId: int.parse(clientId),
              height: int.parse(height),
              weight: double.parse(weight).toInt(),
              userId: userId != "" ? int.parse(userId) : null,
          ));


      if(response.code == 0){
        storage.setItem(SharedPreferenceData.userWeightKey, weight);
        storage.setItem(SharedPreferenceData.userHeightKey, height);

        return RequestResultModel(result: true);
      }
      else{
        return RequestResultModel(result: false);
      }

    }catch(error){
      return RequestResultModel(result: false, error: error.toString());
    }
  }



  Future<RequestResultModel> changePassword(String newPassword) async {
    try{
      final response = await client.changeUserPassword(newPassword);

      if(response.code == 0){
        storage.setItem(SharedPreferenceData.userPasswordKey, newPassword);
        return RequestResultModel(result: true);
      }
      else{
        return RequestResultModel(result: false);
      }

    }catch(error){
      return RequestResultModel(result: false, error: error.toString());
    }
  }

}
