
part of "chat_bloc.dart";

class ChatState{
  List<Message>? list;
  dynamic error;
  int? nextTimeStamp;
  int? nextPageKey;

  ChatState({
    this.list,
    this.error,
    this.nextPageKey,
    this.nextTimeStamp
});
}

class ChatInitialState extends ChatState{}

class ChatLoadingState extends ChatState{}

class ChatLoadedState extends ChatState{}

class ChatErrorState extends ChatState{}
