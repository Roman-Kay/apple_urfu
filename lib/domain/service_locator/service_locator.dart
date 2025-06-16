
import 'package:garnetbook/data/repository/user_storage.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => UserService());
  sl.registerLazySingleton(() => SecureTokenStorage());
  sl.registerLazySingleton(() => ApiClientProvider());
  sl.registerLazySingleton(() => ServiceAnalytics());
}

Future<void> reInit() async {
  await sl.unregister<UserService>();
  sl.registerLazySingleton(() => UserService());

  await sl.unregister<SecureTokenStorage>();
  sl.registerLazySingleton(() => SecureTokenStorage());
}