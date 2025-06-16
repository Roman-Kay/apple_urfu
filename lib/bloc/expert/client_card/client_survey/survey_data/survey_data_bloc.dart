
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_response.dart';
import 'package:garnetbook/domain/services/survey/questionnarie_service.dart';

part "survey_data_event.dart";
part "survey_data_state.dart";

class SurveyDataBloc extends Bloc<SurveyDataEvent, SurveyDataState>{
  SurveyDataBloc() : super(SurveyDataInitialState()){
    on<SurveyDataGetEvent>(_get);
    on<SurveyDataInitialEvent>(_initial);
  }

  final service = QuestionnaireService();


  Future<void> _initial(SurveyDataInitialEvent event, Emitter<SurveyDataState> emit) async{
    emit(SurveyDataInitialState());
  }


  Future<void> _get(SurveyDataGetEvent event, Emitter<SurveyDataState> emit) async{
    emit(SurveyDataLoadingState());

    final response = await service.getSurveyData(event.surveyId);

    final reportResponse = await service.getSurveyReport(event.surveyId);

    if(response.result && reportResponse.result){
      emit(SurveyDataLoadedState(response.value, reportResponse.value));
    }
    else{
      emit(SurveyDataErrorState());
    }
  }
}