
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/message/message_chat_models/list_chat_models.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/message/message_service.dart';


part "list_chat_state.dart";

class ListChatCubit extends Cubit<ListChatState>{
  ListChatCubit() : super(ListChatInitialState());

  final service = MessageService();
  final storage = SharedPreferenceData.getInstance();


  check() async{
    final token = await storage.getItem(SharedPreferenceData.pushedToken);

    if(token != ""){
      emit(ListChatLoadingState());
      final user = await service.createUser(token);

      if(user.result){
        getChat();
      }
      else{
        final getUser = await service.getUser();

        if(getUser.result){
          getChat();
        }
        else{
          emit(ListChatErrorState());
        }
      }
    }
  }

  getChat() async{
    final chat = await service.getUserChatList();

    if(chat.result){
      emit(ListChatLoadedState(chat.value));
    }
    else{
      emit(ListChatErrorState());
    }
  }
}