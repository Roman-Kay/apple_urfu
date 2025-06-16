import 'package:auto_route/auto_route.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/auth/login_service.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    router.push(AuthLoginRoute());
    final prefs = await SharedPreferences.getInstance();
    final isLogged = prefs.getBool('isLogged') == null ? false : prefs.getBool('isLogged');

    final storage = SharedPreferenceData.getInstance();
    final token = await storage.getToken();
    final roleId = await storage.getItem(SharedPreferenceData.role);

    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (isLogged == true && token != "" && roleId != "") {
        final response = await LoginNetworkService().checkTokenAlive();

        if (response.result) {
          if (roleId == "2") {
            router.push(DashboardContainerExpertRoute());
            router.removeLast();
          } else if (roleId == "1") {
            resolver.next(true);
            router.removeLast();
          } else {
            router.push(AuthContainerRoute());
            router.removeLast();
          }
        } else {
          router.push(AuthContainerRoute());
          router.removeLast();
        }
      } else {
        router.push(AuthContainerRoute());
        router.removeLast();
      }
    });
  }
}
