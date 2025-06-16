
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/survey/q_type_view/subsribe_view.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';

part 'survey_branching_event.dart';
part 'survey_branching_state.dart';

class SurveyBranchingBloc extends Bloc<SurveyBranchingEvent, SurveyBranchingState>{
  SurveyBranchingBloc() : super(SurveyBranchingInitialState()){
    on<SurveyBranchingGeEvent>(_get);
  }

  final service = SurveyServices();

  Future<void> _get(SurveyBranchingGeEvent event, Emitter<SurveyBranchingState> emit) async{
    emit(SurveyBranchingLoadingState());

    final response = await service.getSubscribe(event.stepId);

    if(response.result){
      List<NextStep> stepsList = [];

      if(response.value?.nextSteps != null && response.value!.nextSteps!.isNotEmpty){
        response.value!.nextSteps!.forEach((element){
          if(element.title != null && element.id != null && element.type != null){
            stepsList.add(element);
          }
        });
      }

      if(stepsList.isNotEmpty){
        emit(SurveyBranchingLoadedState(stepsList, response.value?.message));
      }
      else{
        emit(SurveyBranchingErrorState());
      }

    }
    else{
      emit(SurveyBranchingErrorState());
    }
  }
}