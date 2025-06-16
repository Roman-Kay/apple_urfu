
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/analysis/family_member.dart';
import 'package:garnetbook/domain/services/analysis/analysis_service.dart';

part 'client_family_list_event.dart';
part 'client_family_list_state.dart';

class ClientFamilyListBloc extends Bloc<ClientFamilyListEvent, ClientFamilyListState>{
  ClientFamilyListBloc() : super(ClientFamilyListInitialState()){
    on<ClientFamilyListGetEvent>(_get);
  }

  final service = AnalysisService();

  Future<void> _get(ClientFamilyListGetEvent event, Emitter<ClientFamilyListState> emit) async{
    emit(ClientFamilyListLoadingState());

    final response = await service.getClientFamilyMember(event.clientId);

    if(response.result){
      emit(ClientFamilyListLoadedState(response.value));
    }
    else{
      emit(ClientFamilyListErrorState());
    }
  }
}