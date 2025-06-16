import 'package:dio/dio.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';

class MessageInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final storage = SharedPreferenceData.getInstance();
    final secret = await storage.getItem(SharedPreferenceData.secretKey);
    final role = await storage.getItem(SharedPreferenceData.role);

    if (role == "1") {
      final clientId = await storage.getItem(SharedPreferenceData.clientIdKey);
      if (secret != "" && clientId != "") {
        options.headers.addAll({"secret": secret, "userid": clientId});
      }
    } else if (role == "2") {
      final expertId = await storage.getItem(SharedPreferenceData.expertIdKey);

      if (secret != "" && expertId != "") {
        options.headers.addAll({"secret": secret, "userid": expertId});
      }
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    //debugPrint('');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final error = err.response?.data['error_code'];
    super.onError(err, handler);
  }
}
