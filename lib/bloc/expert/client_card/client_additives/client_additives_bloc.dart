
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/additives/additives_model.dart';
import 'package:garnetbook/domain/services/expert/client_card_info/client_card_info.dart';

part "client_additives_event.dart";
part  "client_additives_state.dart";

class ClientAdditivesBloc extends Bloc<ClientAdditivesEvent, ClientAdditivesState>{
  ClientAdditivesBloc() : super(ClientAdditivesInitialState()){
    on<ClientAdditivesGetEvent>(_get);
    on<ClientAdditivesInitialEvent>(_initial);
  }

  final service = ClientCardInfoService();


  Future<void> _initial(ClientAdditivesInitialEvent event, Emitter<ClientAdditivesState> emit) async{
    emit(ClientAdditivesInitialState());
  }


  Future<void> _get(ClientAdditivesGetEvent event, Emitter<ClientAdditivesState> emit) async{
    emit(ClientAdditivesLoadingState());

    final response = await service.getClientCardInfoAdditives(event.id);

    if(response.result){
      emit(ClientAdditivesLoadedState(response.value));
    }
    else{
      emit(ClientAdditivesErrorState());
    }
  }
}