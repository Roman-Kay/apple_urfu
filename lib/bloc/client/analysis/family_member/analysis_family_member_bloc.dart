
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/analysis/analysis.dart';
import 'package:garnetbook/domain/services/analysis/analysis_service.dart';

part 'analysis_family_member_event.dart';
part 'analysis_family_member_state.dart';

class AnalysisFamilyMemberBloc extends Bloc<AnalysisFamilyMemberEvent, AnalysisFamilyMemberState>{
  AnalysisFamilyMemberBloc() : super(AnalysisFamilyMemberInitialState()){
    on<AnalysisFamilyMemberGetEvent>(_get);
  }

  final service = AnalysisService();

  Future<void> _get(AnalysisFamilyMemberGetEvent event, Emitter<AnalysisFamilyMemberState> emit) async{
    emit(AnalysisFamilyMemberLoadingState());

    final response = await service.getOneFamilyMember(event.id);

    if(response.result){
      emit(AnalysisFamilyMemberLoadedState(response.value));
    }
    else{
      emit(AnalysisFamilyMemberErrorState());
    }
  }
}