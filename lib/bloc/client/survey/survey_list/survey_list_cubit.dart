
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_response.dart';
import 'package:garnetbook/domain/services/survey/questionnarie_service.dart';

part "survey_list_state.dart";

class SurveyListCubit extends Cubit<SurveyListState> {
  SurveyListCubit() : super(SurveyListInitialState());

  final service = QuestionnaireService();

  check() async{
    emit(SurveyListLoadingState());

    final response = await service.getListOfClientsSurvey();

    if(response.result){
      emit(SurveyListLoadedState(response.value));
    }
    else{
      emit(SurveyListErrorState());
    }
  }
}