
import 'package:garnetbook/domain/config/api_config.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  // ignore: constant_identifier_names
  static const String DEV = 'DEV';
  // ignore: constant_identifier_names
  static const String PROD = 'PROD';
  // ignore: constant_identifier_names
  static const String PREDPROD = 'PREDPROD';

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.DEV:
        return DevConfig();
      case Environment.PREDPROD:
        return PredProdConfig();
      case Environment.PROD:
        return ProdConfig();
      default:
        return ProdConfig();
    }
  }
}