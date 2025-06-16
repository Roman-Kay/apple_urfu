
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/analysis/analysis.dart';
import 'package:garnetbook/domain/services/analysis/analysis_service.dart';

part 'analysis_list_event.dart';
part 'analysis_list_state.dart';

class AnalysisListBloc extends Bloc<AnalysisListEvent, AnalysisListState>{
  AnalysisListBloc() : super(AnalysisListInitialState()){
    on<AnalysisListGetEvent>(_get);
    on<AnalysisListInitialEvent>(_initial);
  }

  final service = AnalysisService();

  Future<void> _initial(AnalysisListInitialEvent event, Emitter<AnalysisListState> emit) async{
    emit(AnalysisListInitialState());
  }

  Future<void> _get(AnalysisListGetEvent event, Emitter<AnalysisListState> emit) async{
    emit(AnalysisListLoadingState());

    final response = await service.getClientAnalysis(event.clientId);

    if(response.result){
      emit(AnalysisListLoadedState(response.value));
    }
    else{
      emit(AnalysisListErrorState());
    }
  }
}