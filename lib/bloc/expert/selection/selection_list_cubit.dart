
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/survey/quiz_model.dart';
import 'package:garnetbook/data/models/survey/selection_model.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';

part 'selection_list_state.dart';

class SelectionListCubit extends Cubit<SelectionListState>{
  SelectionListCubit() : super(SelectionListInitialState());

  final service = SurveyServices();

  check() async{
    emit(SelectionListLoadingState());

    final response = await service.getAllSurvey();

    if(response.result){
      emit(SelectionListLoadedState(response.value));
    }
    else{
      emit(SelectionListErrorState());
    }
  }
}