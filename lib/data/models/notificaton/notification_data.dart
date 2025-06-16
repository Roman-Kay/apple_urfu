
import 'package:garnetbook/data/models/notificaton/notification_message_model.dart';
import 'package:json_annotation/json_annotation.dart';

part "notification_data.g.dart";

@JsonSerializable()
class NotificationData {
  NotificationData({
    required this.event,
    required this.data,
  });

  final String? event;
  dynamic data;

  factory NotificationData.fromJson(Map<String, dynamic> json) => _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);

}


@JsonSerializable()
class NotificationMessage{
  NotificationMessage({
    required this.data,
    required this.event
});

  final String? event;
  final NotificationMessageData? data;

  factory NotificationMessage.fromJson(Map<String, dynamic> json) => _$NotificationMessageFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationMessageToJson(this);
}
