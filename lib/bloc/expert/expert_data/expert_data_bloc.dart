
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/expert/list/expert_data.dart';
import 'package:garnetbook/domain/services/expert/list/expert_list_data_service.dart';

part 'expert_data_event.dart';
part 'expert_data_state.dart';

class ExpertDataBloc extends Bloc<ExpertDataEvent, ExpertDataState>{
  ExpertDataBloc() : super(ExpertDataLoadingState()){
    on<ExpertDataGetEvent>(_get);
  }

  Future<void> _get(ExpertDataGetEvent event, Emitter<ExpertDataState> emit) async{
    emit(ExpertDataLoadingState());
    final service = ExpertListDataService();
    final response = await service.getExpertData(event.expertId);

    if(response.result){
      emit(ExpertDataLoadedState(response.value));
    }
    else{
      emit(ExpertDataErrorState());
    }
  }
}