

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/survey/physical_survey/physical_survey_model.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';

part 'physical_survey_event.dart';
part 'physical_survey_state.dart';

class PhysicalSurveyBloc extends Bloc<PhysicalSurveyEvent, PhysicalSurveyState>{
  PhysicalSurveyBloc() : super(PhysicalSurveyInitialState()){
    on<PhysicalSurveyGetEvent>(_get);
  }

  final service = SurveyServices();

  Future<void> _get(PhysicalSurveyGetEvent event, Emitter<PhysicalSurveyState> emit) async{
    emit(PhysicalSurveyLoadingState());

    final response = await service.getOnePhysicalSurvey(event.id);

    if(response.result){
      emit(PhysicalSurveyLoadedState(response.value));
    }
    else{
      emit(PhysicalSurveyErrorState());
    }
  }
}