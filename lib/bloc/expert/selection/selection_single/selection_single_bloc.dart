
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/survey/selection_model.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';

part 'selection_single_event.dart';
part 'selection_single_state.dart';

class SelectionSingleBloc extends Bloc<SelectionSingleEvent, SelectionSingleState>{
  SelectionSingleBloc() : super(SelectionSingleInitialState()){
    on<SelectionSingleGetEvent>(_get);
  }

  final service = SurveyServices();

  Future<void> _get(SelectionSingleGetEvent event, Emitter<SelectionSingleState> emit) async{
    emit(SelectionSingleLoadingState());

    final response = await service.getOneSelectionList(event.id);

    if(response.result){
      emit(SelectionSingleLoadedState(response.value));
    }
    else{
      emit(SelectionSingleErrorState());
    }
  }
}