import 'package:json_annotation/json_annotation.dart';

part "notification_chat_model.g.dart";

@JsonSerializable()
class NotificationChatData {
  NotificationChatData({
    required this.id,
    required this.status,
    required this.payload,
  });

  final String? id;
  final String? status;
  final Payload? payload;

  factory NotificationChatData.fromJson(Map<String, dynamic> json) => _$NotificationChatDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationChatDataToJson(this);

}

@JsonSerializable()
class Payload {
  Payload({
    this.users,
    this.messageCount,
    this.lastMessageTimestamp,
    this.lastMessage,
    this.id,
  });

  final List<String>? users;
  final int? messageCount;
  final int? lastMessageTimestamp;
  final LastMessage? lastMessage;
  final String? id;

  factory Payload.fromJson(Map<String, dynamic> json) => _$PayloadFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadToJson(this);

}

@JsonSerializable()
class LastMessage {
  LastMessage({
    required this.authorId,
    required this.type,
    required this.text,
    required this.id,
  });

  final String? authorId;
  final String? type;
  final String? text;
  final String? id;

  factory LastMessage.fromJson(Map<String, dynamic> json) => _$LastMessageFromJson(json);

  Map<String, dynamic> toJson() => _$LastMessageToJson(this);

}
