
part of "list_chat_cubit.dart";

class ListChatState{}

class ListChatInitialState extends ListChatState{}

class ListChatLoadingState extends ListChatState{}

class ListChatLoadedState extends ListChatState{
  List<MessageChatModel>? list;
  ListChatLoadedState(this.list);
}

class ListChatErrorState extends ListChatState{}