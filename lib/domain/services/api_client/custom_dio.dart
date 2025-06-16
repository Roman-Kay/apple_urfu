import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/config/environment.dart';
import 'package:garnetbook/domain/interactor/message_interceptor.dart';
import 'package:garnetbook/domain/interactor/token_interceptor.dart';
import 'package:garnetbook/domain/service_locator/service_locator.dart';
import 'package:garnetbook/domain/services/api_client/analysis.dart';
import 'package:garnetbook/domain/services/api_client/client.dart';
import 'package:garnetbook/domain/services/api_client/message_client.dart';
import 'package:garnetbook/domain/services/api_client/survey_client.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';


class SecureTokenStorage implements TokenStorage<String> {
  final _storage = const FlutterSecureStorage();
  static const tokenKey = "token_key";

  @override
  Future<void> delete() async {
    await _storage.delete(key: tokenKey);
  }

  @override
  Future<void> write(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  @override
  Future<String?> read() async {
    var token = await _storage.read(key: tokenKey);
    debugPrint("access: $token");

    if (token == null) {
      return null;
    }
    return token;
  }
}



class ApiClientProvider {
  AuthenticationStatus _status = AuthenticationStatus.initial;

  final authInterceptor = Fresh<String>(
      tokenHeader: (tokens) {
        return {
          'authorization': 'Basic ' + base64Encode(utf8.encode('gadget:fbKwDiwkEGQhX6gp')),
        };
      },
      tokenStorage: GetIt.instance.get<SecureTokenStorage>(),
      refreshToken: (String? token, Dio httpClient) {
        if (token == null) {
          throw RevokeTokenException();
        }
        return SharedPreferenceData.getInstance().getToken();
      },
     );

  late Dio dio;
  late Dio surveyDio;
  late Dio messageDio;
  late Dio analysisDio;

  ApiClientProvider() {
    dio = Dio(
      BaseOptions(contentType: 'application/json; charset=UTF-8',
      headers: {
        'Accept': 'application/json',
        'authorization': 'Basic ' + base64Encode(utf8.encode('gadget:fbKwDiwkEGQhX6gp'))
      }),
    )..interceptors.add(authInterceptor);

    dio.interceptors.addAll([
      TokenInterceptor(),
    ]);

    surveyDio = Dio(
      BaseOptions(contentType: 'application/json; charset=UTF-8',
          headers: {
            'Accept': 'application/json'
          }),
    );

    messageDio = Dio(
      BaseOptions(contentType: 'application/json; charset=UTF-8',
          headers: {
            'Accept': 'application/json'
          }),
    );

    messageDio.interceptors.addAll([MessageInterceptor()]);

    analysisDio = Dio(
      BaseOptions(contentType: 'application/json; charset=UTF-8',
          headers: {
            'Accept': 'application/json'
          }),
    );

    analysisDio.interceptors.addAll([TokenInterceptor()]);

  }

  RestClient get client => RestClient(dio, baseUrl: Environment().config.apiHost);

  RestSurveyClient get surveyClient => RestSurveyClient(surveyDio, baseUrl: Environment().config.apiSurveyHost);

  RestMessageClient get messageClient => RestMessageClient(messageDio, baseUrl: Environment().config.apiMessageHost);

  RestMessageUserClient get messageUserClient => RestMessageUserClient(surveyDio, baseUrl: Environment().config.apiMessageHost);

  RestAnalysis get analysisClient => RestAnalysis(analysisDio, baseUrl: Environment().config.apiAnalysisHost);


  Future<void> saveToken(String tokens) async {
    await authInterceptor.setToken(tokens);
  }

  setApiClientProvider(){
    GetIt.I.get<ApiClientProvider>().authInterceptor.authenticationStatus.listen((event) async {
      if (_status == event && _status != AuthenticationStatus.authenticated && event != AuthenticationStatus.authenticated) return;
      final previousStatus = _status;
      _status = event;
      if (previousStatus == AuthenticationStatus.initial) return;
      await reInit();
    });
  }
 }

