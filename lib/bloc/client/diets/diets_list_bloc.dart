
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/food_diary/diets_model.dart';
import 'package:garnetbook/domain/services/client/food_diary/food_diary_service.dart';

part 'diets_list_event.dart';
part 'diets_list_state.dart';

class DietListBloc extends Bloc<DietsListEvent, DietsListState>{
  DietListBloc() : super(DietsListInitialState()){
    on<DietsListGetEvent>(_get);
    on<DietsListExpertGetEvent>(_expertGet);
    on<DietsListInitialEvent>(_initial);
  }

  final service = FoodDiaryService();

  Future<void> _initial(DietsListInitialEvent event, Emitter<DietsListState> emit) async{
    emit(DietsListInitialState());
  }


  Future<void> _get(DietsListGetEvent event, Emitter<DietsListState> emit) async{
    emit(DietsListLoadingState());

    final response = await service.getListOfDiets();

    if(response.result){
      emit(DietsListLoadedState(response.value));
    }
    else{
      emit(DietsListErrorState());
    }
  }


  Future<void> _expertGet(DietsListExpertGetEvent event, Emitter<DietsListState> emit) async{
    emit(DietsListLoadingState());

    final response = await service.getClientDiets(event.clientId);

    if(response.result){
      emit(DietsListLoadedState(response.value));
    }
    else{
      emit(DietsListErrorState());
    }
  }
}