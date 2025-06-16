
import 'package:garnetbook/data/models/auth/notification_model.dart';
import 'package:garnetbook/data/models/base/base_response.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/user/user_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class UserDataService{
  final client = GetIt.I.get<ApiClientProvider>().client;
  final storage = SharedPreferenceData.getInstance();

  Future<RequestResultModel<UserView>> getUserData() async{
    try{
      final userId = await storage.getUserId();


      if(userId != ""){
        final response = await client.getUserInformation(int.parse(userId));

        if(response.code == 0){

          storage.setItem(SharedPreferenceData.userNameKey, response.user?.firstName ?? "");
          storage.setItem(SharedPreferenceData.userEmailKey, response.user?.email ?? "");
          storage.setItem(SharedPreferenceData.userBdayKey, response.user?.birthDate ?? "");
          storage.setItem(SharedPreferenceData.userGenderKey, response.user?.gender?.name ?? "");

          if(response.user?.role?.id == 1){
            storage.setItem(SharedPreferenceData.clientIdKey, response.user?.profileId.toString() ?? "");
          }
          else{
            storage.setItem(SharedPreferenceData.expertIdKey, response.user?.profileId.toString() ?? "");
          }

          return RequestResultModel(
              result: true,
              value: response.user
          );
        }
        else{
          return RequestResultModel(result: false);
        }
      }
      else{
        return RequestResultModel(result: false);
      }

    }catch(error){
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<BaseResponse>> notificationControl(NotificationRequest request) async{
    try{

      final response = await client.notificationControl(request);

      if(response.code == 0){

        return RequestResultModel(result: true);
      }
      else{
        return RequestResultModel(result: false);
      }

    }catch(error){
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<List<NotificationModelType>>> getNotificationUserList() async{
    try{

      final response = await client.getUserNotificationList();

      return RequestResultModel(result: true, value: response);

    }catch(error){
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<List<NotificationTypeView>>> getNotificationReferenceList() async{
    try{

      final response = await client.getNotificationReferenceList();

      return RequestResultModel(result: true, value: response);

    }catch(error){
      return RequestResultModel(result: false, error: error.toString());
    }
  }

}