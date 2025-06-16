
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/expert/tariffs/tarrifs_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/expert/profile/tariffs_service.dart';

part 'tariffs_event.dart';
part 'tariffs_state.dart';

class TariffsExpertBloc extends Bloc<TariffsExpertEvent, TariffsExpertState>{
  TariffsExpertBloc() : super(TariffsExpertInitialState()){
    on<TariffsExpertGetEvent>(_get);
    on<TariffsExpertAddEvent>(_add);
  }

  final service = TariffsExpertService();
  final storage = SharedPreferenceData.getInstance();

  Future<void> _get(TariffsExpertGetEvent event, Emitter<TariffsExpertState> emit) async{
    emit(TariffsExpertLoadingState());
    final id = await storage.getItem(SharedPreferenceData.expertIdKey);
    if(id != ""){
      final response = await service.getExpertTariffs(int.parse(id));
      if(response.result){
        emit(TariffsExpertLoadedState(response.value));
      }
      else{
        emit(TariffsExpertErrorState());
      }
    }
    else{
      emit(TariffsExpertErrorState());
    }

  }

  Future<void> _add(TariffsExpertAddEvent event, Emitter<TariffsExpertState> emit) async{
    emit(TariffsExpertLoadingState());
    final response = await service.addExpertTariffs(event.request);
    if(response.result){
      emit(TariffsExpertLoadedState(response.value));
    }
    else{
      emit(TariffsExpertErrorState());
    }
  }
}