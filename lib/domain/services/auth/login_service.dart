import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garnetbook/data/models/auth/login_request.dart';
import 'package:garnetbook/data/models/auth/login_social.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/user/user_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginNetworkService {
  final client = GetIt.I.get<ApiClientProvider>().client;
  final storage = SharedPreferenceData.getInstance();


  Future<RequestResultModel<GoogleSignInAccount>> googleRequest() async{
    try{

      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if(gUser != null) {
        final GoogleSignInAuthentication gAuth = await gUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);

        return RequestResultModel(result: true, value: gUser);
      }
      else{
        return RequestResultModel(result: false);
      }

    }catch(error){
      debugPrint("QQQQQQQQQQQQQQQQ $error");
      return RequestResultModel(result: false);
    }
  }


  Future<RequestResultModel<UserView?>> socialMediaLogin(user) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      int roleId = int.parse(await storage.getItem("auth_role"));

      final response = await client.loginBySocial(
        LoginSocialRequest(
          roleId: roleId,
          email: user.runtimeType == GoogleSignInAccount ? user.email : user['email'],
          providerId: user.runtimeType == GoogleSignInAccount ? 1 : 2,
          socProviderId: user.runtimeType == GoogleSignInAccount ? user.id : user['userId'],
          userName: user.runtimeType == GoogleSignInAccount ? user.displayName : user['name'],
        ),
      );

      if (response.code == 0) {
        final token = response.user?.token;
        final name = response.user?.firstName;
        final bday = response.user?.birthDate;
        final email = response.user?.email;
        final phone = response.user?.phone;
        final gender = response.user?.gender?.name;
        final role = response.user?.role?.id;
        final profileId = response.user?.profileId;
        final userId = response.user?.id;

        if (userId != null) {
          storage.setUserId(userId.toString());
        }

        if (role != null) {
          storage.setItem(SharedPreferenceData.role, role.toString());

          if (role.toString() == "1") {
            storage.setItem(SharedPreferenceData.clientIdKey, profileId.toString());
          } else if (role.toString() == "2") {
            storage.setItem(SharedPreferenceData.expertIdKey, profileId.toString());
          }
        }

        if (name != null) {
          storage.setItem(SharedPreferenceData.userNameKey, name);
        }

        if (email != null) {
          storage.setItem(SharedPreferenceData.userEmailKey, email);
        }

        if (bday != null) {
          storage.setItem(SharedPreferenceData.userBdayKey, bday);
        }

        if (phone != null) {
          storage.setItem(SharedPreferenceData.userPhoneKey, phone);
        }

        if (gender != null) {
          storage.setItem(SharedPreferenceData.userGenderKey, gender);
        }

        if (token != null) {
           storage.setToken(token);

          if (gender != null && bday != null && name != null) {
            ApiClientProvider().saveToken(token);
            prefs.setBool('isLogged', true);
            ApiClientProvider().setApiClientProvider();
          }
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


  Future<RequestResultModel<UserView?>> makeLoginRequest(String login, String password) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final roleId = await storage.getItem("auth_role");

    try {
      final res = await client.loginByPassword(
        LoginPasswordRequest(
          roleId: int.parse(roleId), login: login, password: password
        ));

      if(res.code == 0){
        final token = res.user?.token;
        final name = res.user?.firstName;
        final bday = res.user?.birthDate;
        final email = res.user?.email;
        final phone = res.user?.phone;
        final gender = res.user?.gender?.name;
        final role = res.user?.role?.id;
        final profileId = res.user?.profileId;
        final userId = res.user?.id;

        if (userId != null) {
          await storage.setUserId(userId.toString());
        }

        if (role != null) {
          await storage.setItem(SharedPreferenceData.role, role.toString());

          if (role == 1 && profileId != null) {
            await storage.setItem(SharedPreferenceData.clientIdKey, profileId.toString());
          } else if (role == 2 && profileId != null) {
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

        await storage.setItem(SharedPreferenceData.userPasswordKey, password);

        if (token != null && role != null) {
          await storage.setToken(token);

          if (gender != null && bday != null && name != null) {
            ApiClientProvider().saveToken(token);
            prefs.setBool('isLogged', true);
            ApiClientProvider().setApiClientProvider();
          }
        }

        return RequestResultModel(result: true, value: res.user);
      }
      else{
        return RequestResultModel(result: false);
      }

    } on DioException catch(error){
      final errorMessage = await error.response?.data['message'];
      return RequestResultModel(result: false, error: errorMessage);
    }
  }

  Future<RequestResultModel> checkTokenAlive() async{
    try{
      final userId = await storage.getUserId();

      if(userId != ""){
        final response = await client.checkTokenAlive(int.parse(userId));

        if(response.code == 0){
          return RequestResultModel(result: true);
        }
        else{
          return RequestResultModel(result: false);
        }
      }
      else{
        return RequestResultModel(result: false);
      }
    }
    catch(error){
      return RequestResultModel(
        result: false,
        error: error.toString(),
      );
    }
  }
}
