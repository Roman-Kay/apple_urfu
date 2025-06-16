
part of 'notification_list_cubit.dart';

class NotificationListState{}

class NotificationListInitialState extends NotificationListState{}

class NotificationListLoadingState extends NotificationListState{}

class NotificationListLoadedState extends NotificationListState{
  List<NotificationModelType>? list;
  NotificationListLoadedState(this.list);
}

class NotificationListErrorState extends NotificationListState{}