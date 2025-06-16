
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/food_diary/diets_model.dart';
import 'package:garnetbook/domain/services/client/food_diary/food_diary_service.dart';

part 'diets_full_data_event.dart';
part 'diets_full_data_state.dart';

class DietsFullDataBloc extends Bloc<DietsFullDataEvent, DietsFullDataState>{
  DietsFullDataBloc() : super(DietsFullDataInitialState()){
    on<DietsFullDataInitialEvent>(_initial);
    on<DietsFullDataGetEvent>(_get);
  }

  final service = FoodDiaryService();

  Future<void> _initial(DietsFullDataInitialEvent event, Emitter<DietsFullDataState> emit) async{
    emit(DietsFullDataInitialState());
  }

  Future<void> _get(DietsFullDataGetEvent event, Emitter<DietsFullDataState> emit) async{
    emit(DietsFullDataLoadingState());

    final response = await service.getOneDiet(event.id);

    if(response.result){
      emit(DietsFullDataLoadedState(response.value));
    }
    else{
      emit(DietsFullDataErrorState());
    }
  }
}