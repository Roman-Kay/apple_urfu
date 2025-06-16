
part of "chat_bloc.dart";

class ChatEvent{}

class ChatGetEvent extends ChatEvent{
  String chatId;
  int pageKey;

  ChatGetEvent({
    required this.chatId,
    required this.pageKey
});
}

class ChatDisposeEvent extends ChatEvent{}