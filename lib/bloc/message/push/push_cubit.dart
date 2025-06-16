
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/notificaton/push_list_model.dart';
import 'package:garnetbook/domain/services/notification/push_service.dart';

part "push_state.dart";

class PushCubit extends Cubit<PushState>{
  PushCubit() : super(PushInitialState());

  final service = PushService();

  check() async{
    emit(PushLoadingState());

    final response = await service.getPushList();

    if(response.result){
     emit(PushLoadedState(response.value));
    }
    else{
      emit(PushErrorState());
    }
  }
}