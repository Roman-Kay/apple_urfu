
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/expert/profile/education_model.dart';
import 'package:garnetbook/domain/services/expert/profile/education_service.dart';

part 'education_event.dart';
part 'education_state.dart';

class EducationExpertBloc extends Bloc<EducationExpertEvent, EducationExpertState>{
  EducationExpertBloc() : super(EducationExpertInitialState()){
    on<EducationExpertGetEvent>(_get);
    on<EducationExpertAddEvent>(_add);
    on<EducationExpertDeleteEvent>(_delete);
  }

  final service = EducationService();

  Future<void> _get(EducationExpertGetEvent event, Emitter<EducationExpertState> emit) async{
    emit(EducationExpertLoadingState());
    final response = await service.getExpertEducation();
    if(response.result){
      emit(EducationExpertLoadedState(response.value));
    }
    else{
      emit(EducationExpertErrorState());
    }
  }

  Future<void> _add(EducationExpertAddEvent event, Emitter<EducationExpertState> emit) async{
    emit(EducationExpertLoadingState());
    final response = await service.addExpertEducation(event.request);
    if(response.result){
      emit(EducationExpertLoadedState(response.value));
    }
    else{
      emit(EducationExpertErrorState());
    }
  }

  Future<void> _delete(EducationExpertDeleteEvent event, Emitter<EducationExpertState> emit) async{
    emit(EducationExpertLoadingState());
    final deleteResponse = await service.deleteEducation(event.id);
    if(deleteResponse.result){
      final response = await service.getExpertEducation();
      if(response.result){
        emit(EducationExpertLoadedState(response.value));
      }
      else{
        emit(EducationExpertErrorState());
      }
    }
    else{
      emit(EducationExpertErrorState());
    }
  }
}