
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garnetbook/data/repository/token_repository.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController{

  Future<void> logout() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await TokenRepository.getInstance().saveToken(null);
    GetIt.I.get<ApiClientProvider>().authInterceptor.clearToken();
    //FlutterHealthFit().signOut();

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("FIRST_LAUNCH", true);
    prefs.setBool('isLogged', false);
    //await prefs.clear();

    final cachedImageManager = CachedImageBase64Manager.instance();
    await cachedImageManager.clearCache();

    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }
}