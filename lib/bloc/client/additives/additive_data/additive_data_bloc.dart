
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/additives/additives_model.dart';
import 'package:garnetbook/domain/services/client/additives/additives_service.dart';

part "additive_data_event.dart";
part "additive_data_state.dart";

class AdditiveDataBloc extends Bloc<AdditiveDataEvent, AdditiveDataState>{
  AdditiveDataBloc() : super(AdditiveDataInitialState()){
    on<AdditiveDataGetEvent>(_get);
    on<AdditiveDataInitialEvent>(_initial);
  }

  final service = AdditivesNetworkService();

  Future<void> _initial(AdditiveDataInitialEvent event, Emitter<AdditiveDataState> emit) async{
    emit(AdditiveDataInitialState());
  }


  Future<void> _get(AdditiveDataGetEvent event, Emitter<AdditiveDataState> emit) async{
    emit(AdditiveDataLoadingState());

    final response = await service.getOneAdditives(event.id);

    if(response.result){
     emit(AdditiveDataLoadedState(response.value));
    }
    else{
      emit(AdditiveDataErrorState());
    }
  }

}