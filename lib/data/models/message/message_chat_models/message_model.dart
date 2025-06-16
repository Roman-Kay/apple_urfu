
import 'package:json_annotation/json_annotation.dart';

part "message_model.g.dart";

@JsonSerializable()
class Message{
  Message({
    this.authorId,
    this.type,
    this.text,
    this.chatId,
    this.timestamp,
    this.readed,
    this.id,
    this.fileId,
    this.filename
});


  String? id;
  String? filename;
  String? fileId;
  String? authorId;
  String? chatId;
  String? type;
  String? text;
  bool? readed;
  int? timestamp;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}


@JsonSerializable()
class CreateMessage{
  CreateMessage({
    this.text,
    this.chatId,
});

  String? text;

  @JsonKey(name: 'chatId')
  String? chatId;

  factory CreateMessage.fromJson(Map<String, dynamic> json) => _$CreateMessageFromJson(json);
  Map<String, dynamic> toJson() => _$CreateMessageToJson(this);
}


@JsonSerializable()
class UpdateMessage{
  UpdateMessage({
    this.text
});

  String? text;

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => _$UpdateMessageFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateMessageToJson(this);
}


@JsonSerializable()
class LastMessagesRequest{
  LastMessagesRequest({
    required this.count,
    required this.timestamp
});

  int count;
  int timestamp;

  factory LastMessagesRequest.fromJson(Map<String, dynamic> json) => _$LastMessagesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LastMessagesRequestToJson(this);

}


@JsonSerializable()
class MessageReadModel{
  MessageReadModel({
  this.messageIds
});

  List<String>? messageIds;

  factory MessageReadModel.fromJson(Map<String, dynamic> json) => _$MessageReadModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageReadModelToJson(this);
}