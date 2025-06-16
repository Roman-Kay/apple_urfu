
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_response.dart';
import 'package:garnetbook/domain/services/survey/questionnarie_service.dart';

part "client_survey_event.dart";
part "client_survey_state.dart";

class ClientCardSurveyBloc extends Bloc<ClientCardSurveyEvent, ClientCardSurveyState>{
  ClientCardSurveyBloc() : super(ClientCardSurveyInitialState()){
    on<ClientCardSurveyGetEvent>(_get);
    on<ClientCardSurveyInitialEvent>(_initial);
  }

  final service = QuestionnaireService();

  Future<void> _initial(ClientCardSurveyInitialEvent event, Emitter<ClientCardSurveyState> emit) async{
    emit(ClientCardSurveyInitialState());
  }

  Future<void> _get(ClientCardSurveyGetEvent event, Emitter<ClientCardSurveyState> emit) async{
    emit(ClientCardSurveyLoadingState());

    final response = await service.clientCardListOfSurvey(event.id);

    if(response.result){
      emit(ClientCardSurveyLoadedState(response.value));
    }
    else{
      emit(ClientCardSurveyErrorState());
    }
  }
}