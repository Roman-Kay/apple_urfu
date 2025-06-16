
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/message/message_chat_models/message_model.dart';
import 'package:garnetbook/domain/services/message/message_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState>{
  ChatBloc() : super(ChatInitialState()){
    on<ChatGetEvent>(_get);
    on<ChatDisposeEvent>(_dispose);
  }

  final service = MessageService();
  int count = 20;

  Future<void> _dispose(ChatDisposeEvent event, Emitter<ChatState> emit) async{
    emit(ChatState(
        error: null,
        nextPageKey: null,
        nextTimeStamp: null,
        list: null
    ));
  }

  Future<void> _get(ChatGetEvent event, Emitter<ChatState> emit) async{
    final lastListingState = state;

    int todayTimeStamp = DateTime.now().add(Duration(hours: 10)).millisecondsSinceEpoch;
    int timeStamp = event.pageKey == 0 ? todayTimeStamp : lastListingState.nextTimeStamp ?? todayTimeStamp;

    final response = await service.getLastChatMessages(event.chatId, LastMessagesRequest(
        count: count,
        timestamp: timeStamp
    ));


    if(response.result){
      int? nextTimeStamp;


      if(response.value != null && response.value!.isNotEmpty){
        if(response.value?.last.timestamp != null){
          if(response.value!.last.timestamp! != timeStamp){
            nextTimeStamp = response.value!.last.timestamp!;
          }
        }
      }

      if(timeStamp != todayTimeStamp) {
        response.value?.removeAt(0);
      }

      emit(ChatState(
        error: null,
        nextPageKey: nextTimeStamp == null ? null : event.pageKey + 1,
        nextTimeStamp: nextTimeStamp,
        list: event.pageKey == 0 ? response.value ?? [] :
            [...lastListingState.list ?? [], ...response.value ?? []]
      ));
    }
    else{
      emit(ChatState(
        error: "ERROR",
        nextPageKey: lastListingState.nextPageKey,
        nextTimeStamp: null,
        list: lastListingState.list
      ));
    }
  }
}