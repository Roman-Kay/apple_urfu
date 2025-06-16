
// class ApiEndPoints{
//   static const String apiHost = "https://api.garnetbook.ru:20485/main/";
//
//   static const String apiSurveyHost = "https://garnetbook.ru/api/";
//
//   static const String apiMessageHost = "https://s880323.srvape.com:3000";
//
//   static const String apiMessageWebsocket = "wss://s880323.srvape.com:3080";
//
//   static const String apiBitrixHost = "https://b24-lg28z0.bitrix24.ru/rest/1/ym1tp7ssfnnzwqjh/crm.contact.add";
//
//   static const String appMetricaApiKey = "";
// }

abstract class BaseConfig {
  String get apiHost;
  String get apiSurveyHost;
  String get apiMessageHost;
  String get apiAnalysisHost;
  String get apiMessageWebsocket;
  String get apiBitrixHost;
  String get appMetricaApiKey;
  String get liter;
}

class DevConfig implements BaseConfig {
  @override
  String get apiHost => "https://api.garnetbook.ru:20485/main/";
  @override
  String get apiSurveyHost => "https://garnetbook.ru/api/";
  @override
  String get liter => "D";
  @override
  String get apiMessageHost => "https://chat.garnetbook.ru:3000";
  @override
  String get apiBitrixHost => "https://b24-lg28z0.bitrix24.ru/rest/1/ym1tp7ssfnnzwqjh/crm.contact.add";
  @override
  String get apiAnalysisHost => "https://api.garnetbook.ru:20485/analysis/";

  @override
  String get appMetricaApiKey => "c9dca51c-30a7-4f63-95b6-72ab6587577d";

  @override
  String get apiMessageWebsocket => "wss://chat.garnetbook.ru:3080";
}

class ProdConfig implements BaseConfig {
  @override
  String get apiHost => "https://api.garnetbook.ru:20485/main/";
  @override
  String get apiSurveyHost => "https://garnetbook.ru/api/";
  @override
  String get liter => "P";
  @override
  String get apiMessageHost => "https://chat.garnetbook.ru:3000";
  @override
  String get apiAnalysisHost => "https://api.garnetbook.ru:20485/analysis/";
  @override
  String get apiBitrixHost => "https://b24-lg28z0.bitrix24.ru/rest/1/ym1tp7ssfnnzwqjh/crm.contact.add";
  @override
  String get apiMessageWebsocket => "wss://chat.garnetbook.ru:3080";

  @override
  String get appMetricaApiKey => "c9dca51c-30a7-4f63-95b6-72ab6587577d";
}

class PredProdConfig implements BaseConfig {
  @override
  String get apiHost => "https://api.garnetbook.ru:20485/main/";
  @override
  String get apiSurveyHost => "https://garnetbook.ru/api/";
  @override
  String get liter => "PP";
  @override
  String get apiMessageHost => "https://chat.garnetbook.ru:3000";
  @override
  String get apiAnalysisHost => "https://api.garnetbook.ru:20485/analysis/";
  @override
  String get apiBitrixHost => "https://b24-lg28z0.bitrix24.ru/rest/1/ym1tp7ssfnnzwqjh/crm.contact.add";
  @override
  String get apiMessageWebsocket => "wss://chat.garnetbook.ru:3080";

  @override
  String get appMetricaApiKey => "c9dca51c-30a7-4f63-95b6-72ab6587577d";
}