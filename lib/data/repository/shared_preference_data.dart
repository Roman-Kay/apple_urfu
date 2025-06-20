import 'dart:convert';

import 'package:garnetbook/data/models/expert/recommendation/recommendation_model_store.dart';
import 'package:garnetbook/data/models/survey/survey_branching_store/survey_branching_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterService {
  static final CounterService _instance = CounterService._internal();

  factory CounterService() {
    return _instance;
  }

  CounterService._internal();

  final SharedPreferenceData _storage = SharedPreferenceData.getInstance();

  int _counter = 0;

  // Инициализация: загрузить значение из памяти
  Future<void> init() async {
    String? value = await _storage.getItem('welcomeDialogCounter');
    if (value == null) {
      _counter = 0;
    } else {
      _counter = int.tryParse(value) ?? 0;
    }
  }

  // Получить текущее значение
  int get counter => _counter;

  // Увеличить счетчик на 10 и сохранить
  Future<void> increment() async {
    _counter += 10;
    await _storage.setItem('welcomeDialogCounter', _counter.toString());
  }

  // Увеличить счетчик на 10 и сохранить
  Future<void> incrementBig() async {
    _counter += 30;
    await _storage.setItem('welcomeDialogCounter', _counter.toString());
  }
}

class SharedPreferenceData {
  static const tokenKey = "token_key";
  static const secretKey = "secret_key"; // token for message server
  static const userIdKey = "user_id_key";
  static const pushedToken = "pushed_token_key"; // token for notification server

  // user
  static const userNameKey = "user_name_key";
  static const userBdayKey = "user_bday_key";
  static const userPhoneKey = "user_phone_key";
  static const userEmailKey = "user_email_key";
  static const userHeightKey = "user_height_key";
  static const userWeightKey = "user_weight_key";
  static const userGenderKey = "user_gender_key";
  static const userTargetKey = "user_target_key";
  static const userPasswordKey = "user_password_key";

  static const clientIdKey = "client_id_key";
  static const expertIdKey = "expert_id_key";
  static const role = "role";

  static const selectedCalendar = "selected_calendar";

  static const isRegisterGoogleFit = "isRegisterGoogleFit";

  //survey
  static const surveyBranching = "surveyBranching";

  //recommendation
  static const recommendationBranching = "recommendationBranching";

  static SharedPreferenceData? _instance;
  factory SharedPreferenceData.getInstance() => _instance ??= SharedPreferenceData._internal();
  SharedPreferenceData._internal();

  Future<bool> setToken(final String? token) => setItem(tokenKey, token);

  Future<String> getToken() => getItem(tokenKey);

  Future<bool> setUserId(String? userId) => setItem(userIdKey, userId);

  Future<String> getUserId() => getItem(userIdKey);

  Future<bool> setItem(final String key, final String? item) async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.setString(key, item ?? '');
    return result;
  }

  Future<String> getItem(final String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(key) ?? '';
  }

  saveObject(value, String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(name, json.encode(value) ?? "");
  }

  //survey
  Future<SurveyBranchingList?> readObject() async {
    final prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(surveyBranching) ?? "";

    if (value != "") {
      return value != "" ? SurveyBranchingList.fromJson(json.decode(value.trim())) : null;
    }
    return null;
  }

  // recommendation
  Future<RecommendationItemStore?> readRecommendationObject() async {
    final prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(recommendationBranching) ?? "";

    if (value != "") {
      Map<String, dynamic> valueMap = json.decode(value.trim());
      return value != "" ? RecommendationItemStore.fromJson(valueMap) : null;
    }
    return null;
  }
}
