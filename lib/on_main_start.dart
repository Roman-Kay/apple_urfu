import 'package:apple/domain/analytics/service_analytics.dart';
import 'package:apple/domain/config/environment.dart';
import 'package:apple/domain/service_locator/service_locator.dart';
import 'package:get_it/get_it.dart';

class OnMainStart {
  void main({bool isStartTracker = true}) async {
    const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: Environment.DEV);

    Environment().initConfig(environment);

    //Регистрация синглтонов
    init();
    if (isStartTracker) {
      await GetIt.I.get<ServiceAnalytics>().initTracker();
    }
  }
}
