import 'package:flutter_login_vk/flutter_login_vk.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';

class VkSingInAuth {

  Future<RequestResultModel> signInWithVk() async {

    // Create an instance of VKLogin
    final vk = VKLogin();

    // Initialize
    await vk.initSdk();

    // Log in
    final res = await vk.logIn(scope: [
      VKScope.email,
      VKScope.friends,
    ]);

    // Check result
    if (res.isValue) {
      // There is no error, but we don't know yet
      // if user logged in or not.
      // You should check isCanceled
      final VKLoginResult result = res.asValue!.value;

      if (result.isCanceled) {
        // User cancel log in
        return RequestResultModel(result: false, error: 'Вы отменили авторизацию');
      } else {
        // Logged in

        // Send access token to server for validation and auth
        final VKAccessToken? accessToken = result.accessToken;
        if (accessToken != null) {

          // Get profile data
          final profileRes = await vk.getUserProfile();
          final email = accessToken.email;

          if (profileRes.asValue != null && profileRes.asValue?.value != null) {
            return RequestResultModel(
              result: true, value: {
              'email': email,
              'name': profileRes.asValue!.value!.firstName + ' ' + profileRes.asValue!.value!.lastName,
              'userId': profileRes.asValue?.value!.userId.toString()
            });
          } else {
            return RequestResultModel(result: false, error: '');
          }

        } else {
          return RequestResultModel(result: false, error: '');
        }
      }
    } else {
      final errorRes = res.asError ?? '';
      return RequestResultModel(result: false, error: errorRes.toString());
    }

// final res = await vk.logIn(scope: [
//       VKScope.email,
//     ]);

    // if (res.isValue) {
    //   // Ошибки нет, но мы еще не знаем, вошел
    //   // пользователь или нет, он мог отменить вход.
    //   // Нужно проверить свойство isCanceled:
    //   final VKLoginResult result = res.asValue!.value;

    //   if (result.isCanceled) {
    //     return RequestResultModel(result: false, error: res.isError.toString());
    //     // Пользователь отменил вход
    //   } else {
    //     // Вход выполнен ?
    //     // Отправьте этот access token на сервер для валидации
    //     // и авторизации в вашем приложении
    //       // final VKAccessToken? accessToken = result.accessToken;
    //       // debugPrint('token: ${accessToken!.token}');

    //     // Получаем данные профиля
    //     final Result<VKUserProfile?> profile = await vk.getUserProfile();
    //     // Получаем email. Выше, при логине, мы запросили права,
    //     // поэтому можем прочитать электронную почту пользователя
    //     final email = await vk.getUserEmail();
    //              print(1);
    //          print(profile.asValue != null );
    //          print(profile.asValue!.value != null);
    //          print(_email);
    //          print(result.accessToken != null);
    //     if (profile.asValue != null && profile.asValue!.value != null && email != null && result.accessToken != null) {


    //       return RequestResultModel(
    //         result: true, value: {
    //         'email': email,
    //         'name': profile.asValue!.value!.firstName + ' ' + profile.asValue!.value!.lastName,
    //         'userId': result.accessToken!.userId,

    //       });

    //     } else {
    //       return RequestResultModel(result: false);
    //     }
    //   }
    // } else {
    //   // Ошибка входа
    //   return RequestResultModel(result: false, error: res.asError.toString());
    // }

  }

  // Future<void> initSdk() async {

  //   await vk.initSdk();
  //   _sdkInitialized = true;
  //   await updateLoginInfo();
  // }

  // Future<void> updateLoginInfo() async {

  //   if (!_sdkInitialized) return;

  //   final plugin = vk;
  //   final token = await plugin.accessToken;
  //   final profileRes = token != null ? await plugin.getUserProfile() : null;
  //   final email = token != null ? await plugin.getUserEmail() : null;

  //   _token = token;
  //   _profile = profileRes?.asValue?.value;
  //   _email = email;
  // }
}
