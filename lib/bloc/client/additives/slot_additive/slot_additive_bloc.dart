
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/additives/additives_slot_model.dart';
import 'package:garnetbook/domain/services/client/additives/additives_service.dart';

part 'slot_additive_event.dart';
part 'slot_additive_state.dart';

class SlotAdditiveBloc extends Bloc<SlotAdditiveEvent, SlotAdditiveState>{
  SlotAdditiveBloc() : super(SlotAdditiveInitialState()){
    on<SlotAdditiveGetEvent>(_get);
    on<SlotAdditiveInitialEvent>(_initial);
  }

  final service = AdditivesNetworkService();

  Future<void> _get(SlotAdditiveGetEvent event, Emitter<SlotAdditiveState> emit) async{
    emit(SlotAdditiveLoadingState());

    final response = await service.getAdditiveSlot(event.id);

    if(response.result){
      emit(SlotAdditiveLoadedState(response.value));
    }
    else{
      emit(SlotAdditiveErrorState());
    }
  }

  Future<void> _initial(SlotAdditiveInitialEvent event, Emitter<SlotAdditiveState> emit) async{
    emit(SlotAdditiveInitialState());
  }
}