
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/expert/card_info/card_info.dart';
import 'package:garnetbook/domain/services/expert/client_card_info/client_card_info.dart';

part 'client_personal_data_event.dart';
part 'client_personal_data_state.dart';

class ClientCardPersonalDataBloc extends Bloc<ClientCardPersonalDataEvent, ClientCardPersonalDataState>{
  ClientCardPersonalDataBloc() : super(ClientCardPersonalDataInitialState()){
    on<ClientCardPersonalDataGetEvent>(_get);
  }

  final service = ClientCardInfoService();

  Future<void> _get(ClientCardPersonalDataGetEvent event, Emitter<ClientCardPersonalDataState> emit) async{
    emit(ClientCardPersonalDataLoadingState());

    final response = await service.getClientCardInfo(event.id);

    if(response.result){
      emit(ClientCardPersonalDataLoadedState(response.value));
    }
    else{
      emit(ClientCardPersonalDataErrorState());
    }
  }
}