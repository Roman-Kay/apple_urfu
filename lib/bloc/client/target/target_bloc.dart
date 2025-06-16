
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/domain/services/auth/profile_data.dart';
import 'package:garnetbook/domain/services/client/target/target_services.dart';

part 'target_state.dart';
part 'target_event.dart';

class TargetBloc extends Bloc<TargetEvent, TargetState>{
  TargetBloc() : super(TargetLoadingState()){
    on<TargetSetEvent>(_set);
    on<TargetCheckEvent>(_check);
  }

  final targetService = TargetNetworkServices();

  Future<void> _set(TargetSetEvent event, Emitter<TargetState> emit) async{
    emit(TargetLoadingState());

    final service = ProfileDataService();

    final authResponse = await service.setProfileClient(event.weight, event.height);

    if(authResponse .result){
      final response = await targetService.getClientTargets();

      if(response.result){
        emit(TargetLoadedState(response.value));
      }
      else{
        emit(TargetErrorState());
      }
    }
    else{
      emit(TargetErrorState());
    }
  }

  Future<void> _check(TargetCheckEvent event, Emitter<TargetState> emit) async{
    emit(TargetLoadingState());
    final response = await targetService.getClientTargets();
    if(response.result){
      emit(TargetLoadedState(response.value));
    }
    else{
      emit(TargetErrorState());
    }
  }
}