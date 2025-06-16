
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/trackers/tracker_response.dart';
import 'package:garnetbook/domain/services/expert/client_card_info/client_card_info.dart';

part "client_trackers_event.dart";
part 'client_trackers_state.dart';

class ClientCardTrackersBloc extends Bloc<ClientCardTrackersEvent, ClientCardTrackersState>{
  ClientCardTrackersBloc() : super(ClientCardTrackersInitialState()){
    on<ClientCardTrackersGetEvent>(_get);
    on<ClientCardTrackersInitialEvent>(_initial);
  }

  final service = ClientCardInfoService();

  Future<void> _initial(ClientCardTrackersInitialEvent event, Emitter<ClientCardTrackersState> emit) async{
    emit(ClientCardTrackersInitialState());
  }

  Future<void> _get(ClientCardTrackersGetEvent event, Emitter<ClientCardTrackersState> emit) async{
    emit(ClientCardTrackersLoadingState());

    final response = await service.getClientCardInfoTrackers(event.id);

    if(response.result){
      emit(ClientCardTrackersLoadedState(response.value));
    }
    else{
      emit(ClientCardTrackersErrorState());
    }
  }
}