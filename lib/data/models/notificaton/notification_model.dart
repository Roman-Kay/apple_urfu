
import 'package:garnetbook/data/models/notificaton/notification_chat_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationMessageDataModel {
  NotificationMessageDataModel({
    required this.type,
    required this.message,
  });

  final String? type;
  final Message? message;

  factory NotificationMessageDataModel.fromJson(Map<String, dynamic> json) => _$NotificationMessageDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationMessageDataModelToJson(this);

}

@JsonSerializable()
class Message {
  Message({
    required this.data,
    required this.messageId,
    required this.mfTraceId,
  });

  final Payload? data;
  final String? messageId;
  final String? mfTraceId;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

}

