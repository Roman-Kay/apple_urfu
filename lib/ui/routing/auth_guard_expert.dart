
// import 'package:auto_route/auto_route.dart';
// import 'package:fresh_dio/fresh_dio.dart';
// import 'package:garnetbook/data/repository/shared_preference_data.dart';
// import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
// import 'package:garnetbook/ui/routing/app_router.dart';
// import 'package:get_it/get_it.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthGuardExpert extends AutoRouteGuard{
//   final _authInterceptor = GetIt.I.get<ApiClientProvider>().authInterceptor;

//   @override
//   void onNavigation(NavigationResolver resolver, StackRouter router) async{
//     router.push(AuthWelcomeRoute());
//     final prefs = await SharedPreferences.getInstance();
//     final isLogged = prefs.getBool('isLogged') == null ? false : prefs.getBool('isLogged');

//     final storage = SharedPreferenceData.getInstance();
//     final token = await storage.getToken();
//     final roleId = await storage.getItem(SharedPreferenceData.role);

//     AuthenticationStatus isAuth = await _authInterceptor.authenticationStatus
//         .firstWhere((element) => element != AuthenticationStatus.initial);

//     Future.delayed(const Duration(seconds: 2), () {
//       if(isLogged == true && token != "" && roleId != ""){

//         if(roleId == "1"){
//           router.push(DashboardContainerRoute());
//           router.removeLast();
//         }
//         else if(roleId == "2"){
//           resolver.next(true);
//           router.removeLast();
//         }
//         else{
//           router.push(AuthContainerRoute());
//           router.removeLast();
//         }

//       }else{
//         router.push(AuthContainerRoute());
//         router.removeLast();
//       }
//     });
//   }

// }