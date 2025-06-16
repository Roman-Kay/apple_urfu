
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/survey/quiz_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState>{
  SurveyBloc() : super(SurveyInitialState()){
    on<SurveyGetEvent>(_get);
    on<SurveyNewEvent>(_initial);
  }

  final service = SurveyServices();
  final storage = SharedPreferenceData.getInstance();

  Future<void> _initial(SurveyNewEvent event, Emitter<SurveyState> emit) async{
    emit(SurveyInitialState());
  }

  Future<void> _get(SurveyGetEvent event, Emitter<SurveyState> emit) async{
    emit(SurveyLoadingState());

    var response;

    if(event.id == 32 || event.id == 33 || event.id == 34){
      final gender = await storage.getItem(SharedPreferenceData.userGenderKey);

      if(gender != ""){
        String userGender = gender == "male" ? "m" : "w";
        response = await service.getOneSurvey(event.id, userGender);
      }
    }
    else{
      response = await service.getOneSurvey(event.id, null);
    }

    if(response.result){
      emit(SurveyLoadedState(response.value));
    }
    else{
      emit(SurveyErrorState());
    }
  }
}