

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/expert/profile/achieves_model.dart';
import 'package:garnetbook/domain/services/expert/profile/achievements_service.dart';

part 'achievement_event.dart';
part 'achievement_state.dart';

class AchievementsExpertBloc extends Bloc<AchievementsExpertEvent, AchievementsExpertState>{
  AchievementsExpertBloc() : super(AchievementsExpertInitialState()){
    on<AchievementsExpertGetEvent>(_get);
    on<AchievementsExpertAddEvent>(_add);
    on<AchievementsExpertDeleteEvent>(_delete);
  }

  final networkService = AchievementsService();

  Future<void> _get(AchievementsExpertGetEvent event, Emitter<AchievementsExpertState> emit) async{
    emit(AchievementsExpertLoadingState());
    final response = await networkService.getExpertAchieves();
    if(response.result){
      emit(AchievementsExpertLoadedState(response.value));
    }else{
      emit(AchievementsExpertErrorState());
    }
  }

  Future<void> _add(AchievementsExpertAddEvent event, Emitter<AchievementsExpertState> emit) async{
    emit(AchievementsExpertLoadingState());
    final response = await networkService.addExpertAchieves(event.request);
    if(response.result){
      emit(AchievementsExpertLoadedState(response.value));
    }else{
      emit(AchievementsExpertErrorState());
    }
  }

  Future<void> _delete(AchievementsExpertDeleteEvent event, Emitter<AchievementsExpertState> emit) async{
    emit(AchievementsExpertLoadingState());
    final deleteResponse = await AchievementsService().deleteAchieves(event.id);
    if(deleteResponse.result){
      final response = await networkService.getExpertAchieves();
      if(response.result){
        emit(AchievementsExpertLoadedState(response.value));
      }else{
        emit(AchievementsExpertErrorState());
      }
    }else{
      emit(AchievementsExpertErrorState());
    }
  }
}