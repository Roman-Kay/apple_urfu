
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/expert/profile/experience_model.dart';
import 'package:garnetbook/domain/services/expert/profile/experience_service.dart';

part 'experience_event.dart';
part 'experience_state.dart';

class ExperienceExpertBloc extends Bloc<ExperienceExpertEvent, ExperienceExpertState>{
  ExperienceExpertBloc() : super(ExperienceExpertInitialState()){
    on<ExperienceExpertAddEvent>(_add);
    on<ExperienceExpertGetEvent>(_get);
    on<ExperienceExpertDeleteEvent>(_delete);
  }

  final service = ExperienceService();

  Future<void> _get(ExperienceExpertGetEvent event, Emitter<ExperienceExpertState> emit) async{
    emit(ExperienceExpertLoadingState());
    final response = await service.getExpertExperience();
    if(response.result){
      emit(ExperienceExpertLoadedState(response.value));
    }else{
      emit(ExperienceExpertErrorState());
    }
  }

  Future<void> _add(ExperienceExpertAddEvent event, Emitter<ExperienceExpertState> emit) async{
    emit(ExperienceExpertLoadingState());
    final response = await service.addExpertExperience(event.request);
    if(response.result){
      emit(ExperienceExpertLoadedState(response.value));
    }else{
      emit(ExperienceExpertErrorState());
    }
  }

  Future<void> _delete(ExperienceExpertDeleteEvent event, Emitter<ExperienceExpertState> emit) async{
    emit(ExperienceExpertLoadingState());
    final deleteResponse = await service.deleteExperience(event.id);

    if(deleteResponse.result){
      final response = await service.getExpertExperience();
      if(response.result){
        emit(ExperienceExpertLoadedState(response.value));
      }else{
        emit(ExperienceExpertErrorState());
      }
    }else{
      emit(ExperienceExpertErrorState());
    }
  }
}