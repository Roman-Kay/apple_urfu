
import 'package:json_annotation/json_annotation.dart';

part "list_chat_models.g.dart";


@JsonSerializable()
class ListMessageChatModel{
  ListMessageChatModel({
    this.list
});
  List<MessageChatModel>? list;

  factory ListMessageChatModel.fromJson(Map<String, dynamic> json) => _$ListMessageChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListMessageChatModelToJson(this);
}


@JsonSerializable()
class CreateChatModel{
  CreateChatModel({
    required this.users,
    required this.messageCount,
    required this.lastMessageTimestamp,
    required this.id,
    required this.creatorId
});

  final List<String>? users;
  final int? messageCount;
  final int? lastMessageTimestamp;
  final String? id;
  final String? creatorId;

  factory CreateChatModel.fromJson(Map<String, dynamic> json) => _$CreateChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreateChatModelToJson(this);
}



@JsonSerializable()
class MessageChatModel {
  MessageChatModel({
    required this.users,
    required this.messageCount,
    required this.lastMessageTimestamp,
    required this.lastMessage,
    required this.id,
    required this.creatorDisplayName,
    required this.creatorId
  });

  final List<MessageUsers>? users;
  final int? messageCount;
  final int? lastMessageTimestamp;
  final LastMessage? lastMessage;
  final String? id;
  final String? creatorId;
  final String? creatorDisplayName;

  factory MessageChatModel.fromJson(Map<String, dynamic> json) => _$MessageChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageChatModelToJson(this);

}

@JsonSerializable()
class LastMessage {
  LastMessage({
    required this.authorId,
    required this.type,
    required this.text,
    required this.id,
    required this.readed,
  });

  final String? authorId;
  final String? type;
  final String? text;
  final String? id;
  final bool? readed;

  factory LastMessage.fromJson(Map<String, dynamic> json) => _$LastMessageFromJson(json);

  Map<String, dynamic> toJson() => _$LastMessageToJson(this);

}


@JsonSerializable()
class MessageUsers{
  MessageUsers({
    this.id,
    this.displayName
});

  String? displayName;
  String? id;


  factory MessageUsers.fromJson(Map<String, dynamic> json) => _$MessageUsersFromJson(json);

  Map<String, dynamic> toJson() => _$MessageUsersToJson(this);

}



@JsonSerializable()
class ChatDocumentResponse{
  ChatDocumentResponse({
    this.id
});

  String? id;

  factory ChatDocumentResponse.fromJson(Map<String, dynamic> json) => _$ChatDocumentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ChatDocumentResponseToJson(this);
}

@JsonSerializable()
class CreateNewChatModel{
  CreateNewChatModel({
    required this.users
});

  List<String> users;

  factory CreateNewChatModel.fromJson(Map<String, dynamic> json) => _$CreateNewChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreateNewChatModelToJson(this);
}