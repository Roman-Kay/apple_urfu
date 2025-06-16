
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/analysis/analysis.dart';
import 'package:garnetbook/domain/services/analysis/analysis_service.dart';

part 'analysis_full_event.dart';
part 'analysis_full_state.dart';

class AnalysisFullBloc extends Bloc<AnalysisFullEvent, AnalysisFullState>{
  AnalysisFullBloc() : super(AnalysisFullInitialState()){
    on<AnalysisFullGetEvent>(_get);
    on<AnalysisFullInitialEvent>(_initial);
  }

  final service = AnalysisService();

  Future<void> _initial(AnalysisFullInitialEvent event, Emitter<AnalysisFullState> emit) async{
    emit(AnalysisFullInitialState());
  }

  Future<void> _get(AnalysisFullGetEvent event, Emitter<AnalysisFullState> emit) async{
    emit(AnalysisFullLoadingState());

    final response = await service.getAnalysisById(event.analysisId);

    if(response.result){
      emit(AnalysisFullLoadedState(response.value));
    }
    else{
      emit(AnalysisFullErrorState());
    }
  }
}