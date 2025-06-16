import 'package:dio/dio.dart';
import 'package:garnetbook/data/models/auth/client_expert_auth.dart';
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:garnetbook/data/models/auth/login_social.dart';
import 'package:garnetbook/data/models/auth/sms_model.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterNetworkService {
  final client = GetIt.I.get<ApiClientProvider>().client;
  final storage = SharedPreferenceData.getInstance();


  Future<RequestResultModel> registerClientByExpert(AddClientExpertRequest request) async{
    try{
      final response = await client.createClientByExpert(request);

      if(response.code == 0){
        return RequestResultModel(result: true);
      }
      else{
        return RequestResultModel(result: false);
      }
    }
    catch(e){
      return RequestResultModel(result: false);
    }
  }


  Future<RequestResultModel> registerSocialMedia(RegisterSocialRequest request) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await client.registerBySocial(request);

      if (response.code == 0) {
        final token = response.user?.token;
        final name = response.user?.firstName;
        final bday = response.user?.birthDate;
        final email = response.user?.email;
        final gender = response.user?.gender?.name;
        final role = response.user?.role?.id;
        final phone = response.user?.phone;
        final profileId = response.user?.profileId;
        final userId = response.user?.id;

        if (userId != null) {
          await storage.setUserId(userId.toString());
        }

        if (role != null) {
          await storage.setItem(SharedPreferenceData.role, role.toString());

          if (role.toString() == "1") {
            await storage.setItem(SharedPreferenceData.clientIdKey, profileId.toString());
          } else if (role.toString() == "2") {
            await storage.setItem(SharedPreferenceData.expertIdKey, profileId.toString());
          }
        }

        if (name != null) {
          await storage.setItem(SharedPreferenceData.userNameKey, name);
        }

        if (email != null) {
          await storage.setItem(SharedPreferenceData.userEmailKey, email);
        }

        if (bday != null) {
          await storage.setItem(SharedPreferenceData.userBdayKey, bday);
        }

        if (phone != null) {
          await storage.setItem(SharedPreferenceData.userPhoneKey, phone);
        }

        if (gender != null) {
          await storage.setItem(SharedPreferenceData.userGenderKey, gender);
        }

        if (token != null) {
          ApiClientProvider().saveToken(token);
          await storage.setToken(token);

          prefs.setBool('isLogged', true);
          ApiClientProvider().setApiClientProvider();
        }

        return RequestResultModel(result: true, value: response.user);
      }
      else {
        return RequestResultModel(result: false);
      }
    } on DioException catch (error) {
      final errorMessage = await error.response?.data['message'];
      return RequestResultModel(result: false, error: errorMessage);
    }
  }


  Future<RequestResultModel> createNewUser(UserCreateRequest request) async {
    try {

      final response = await client.createNewUser(request);

      if (response.code == 0) {
        int? id = response.id;
        String? token = response.token;

        if (id != null) {
          await storage.setUserId(id.toString());
        }

        if (token != null) {
          await storage.setToken(token);
        }

        return RequestResultModel(result: true, value: response);
      }
      else {
        return RequestResultModel(result: false, error: response.message);
      }
    } on DioException catch (error) {
      final errorMessage = await error.response?.data['message'];

      return RequestResultModel(result: false, error: errorMessage);
    }
  }


  Future<RequestResultModel<SMSSendResponse>> sendSmsRegistration(String phone) async {
    try {
      final response = await client.sendSmsRegistration(phone);

      if (response.code == 0) {
        return RequestResultModel(result: true, value: response);
      } else {
        return RequestResultModel(result: false);
      }
    } catch (error) {
      return RequestResultModel(result: false);
    }
  }


  Future<RequestResultModel<SMSSendResponse>> sendSms(String phone) async {
    try {
      final response = await client.getSms(phone);

      if (response.code == 0) {
        return RequestResultModel(result: true, value: response);
      } else {
        return RequestResultModel(result: false);
      }
    } on DioException catch(error){
      final errorMessage = await error.response?.data['message'];
      return RequestResultModel(result: false, error: errorMessage);
    }
  }


  Future<RequestResultModel> checkUserPhoneNumber(String phone) async {
    try {
      final response = await client.findUserByPhone(phone);
      if (response.id == null) {
        return RequestResultModel(result: true);
      }
      else {
        return RequestResultModel(result: false, error: "Номер $phone уже зарегистрирован!");
      }
    } on DioException catch (error) {

      final errorMessage = await error.response?.data['message'];

      if(errorMessage == "Пользователь не найден"){
        return RequestResultModel(result: true);
      }
      else{
        return RequestResultModel(result: false);
      }
    }
  }

}
