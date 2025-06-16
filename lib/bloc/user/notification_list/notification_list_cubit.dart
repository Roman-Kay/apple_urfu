
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/auth/notification_model.dart';
import 'package:garnetbook/domain/services/auth/user_data.dart';

part 'notification_list_state.dart';

class NotificationListCubit extends Cubit<NotificationListState>{
  NotificationListCubit() : super(NotificationListInitialState());

  final service = UserDataService();

  check() async{
    emit(NotificationListLoadingState());

    final list = await service.getNotificationReferenceList();

    final response = await service.getNotificationUserList();

    if(response.result && list.result){
      List<NotificationModelType> notificationList = [];

      if(list.value != null && list.value!.isNotEmpty){


        list.value!.forEach((element){
          if(response.value != null && response.value!.isNotEmpty){

            if(response.value!.any((data)=> data.type?.notificationTypeId != null && data.type?.notificationTypeId == element.notificationTypeId)){
              notificationList.add(NotificationModelType(
                  subscribe: true,
                  type: element
              ));
            }
            else{
              notificationList.add(NotificationModelType(
                  subscribe: false,
                  type: element
              ));
            }
          }
          else{
            notificationList.add(NotificationModelType(
              subscribe: false,
              type: element
            ));
          }
        });

        if(notificationList.isNotEmpty){
          emit(NotificationListLoadedState(notificationList));
        }
        else{
          emit(NotificationListErrorState());
        }
      }
      else{
        emit(NotificationListErrorState());
      }
    }
    else{
      emit(NotificationListErrorState());
    }

  }
}