import 'package:json_annotation/json_annotation.dart';

part "notification_message_model.g.dart";

@JsonSerializable()
class NotificationMessageData2 {
  NotificationMessageData2({
    this.id,
    this.payload,
    this.status
  });

  final String? id;
  final Payload? payload;
  final String? status;

  factory NotificationMessageData2.fromJson(Map<String, dynamic> json) => _$NotificationMessageData2FromJson(json);

  Map<String, dynamic> toJson() => _$NotificationMessageData2ToJson(this);

}

@JsonSerializable()
class NotificationMessageData {
  NotificationMessageData({
    required this.data,
  });

  final Payload? data;

  factory NotificationMessageData.fromJson(Map<String, dynamic> json) => _$NotificationMessageDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationMessageDataToJson(this);

}

@JsonSerializable()
class Payload {
  Payload({
    this.authorId,
    this.chatId,
    this.type,
    // this.filename,
    // this.fileId,
    this.text,
    //this.timestamp,
    //this.v,
    //this.id,
    this.authorDisplayName,
    this.userId,
    this.readed
  });

  final String? authorId;
  final String? chatId;
  final String? type;
  //final String? filename;
  //final String? fileId;
  final String? text;
  //final int? timestamp;
  final String? authorDisplayName;
  final String? userId;
  final bool? readed;

  // @JsonKey(name: '__v')
  // final int? v;

  //@JsonKey(name: '_id')
  //final String? id;

  factory Payload.fromJson(Map<String, dynamic> json) => _$PayloadFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadToJson(this);

}
