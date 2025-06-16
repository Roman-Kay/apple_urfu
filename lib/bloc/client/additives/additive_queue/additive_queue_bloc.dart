

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/additives/additives_model.dart';
import 'package:garnetbook/domain/services/client/additives/additives_service.dart';

part "additive_queue_event.dart";
part "additive_queue_state.dart";

class AdditiveQueueBloc extends Bloc<AdditiveQueueEvent, AdditiveQueueState>{
  AdditiveQueueBloc() : super(AdditiveQueueInitialState()){
    on<AdditiveQueueGetEvent>(_get);
  }

  final service = AdditivesNetworkService();

  Future<void> _get(AdditiveQueueGetEvent event, Emitter<AdditiveQueueState> emit) async{
    emit(AdditiveQueueLoadingState());

    final response = await service.getQueueAdditives(event.request);

    if(response.result){
      emit(AdditiveQueueLoadedState(response.value));
    }
    else{
      emit(AdditiveQueueErrorState());
    }
  }
}