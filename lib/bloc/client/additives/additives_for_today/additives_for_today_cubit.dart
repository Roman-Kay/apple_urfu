
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/additives/additives_slot_model.dart';
import 'package:garnetbook/domain/services/client/additives/additives_service.dart';

part 'additives_for_today_state.dart';

class AdditivesForTodayCubit extends Cubit<AdditivesForTodayState>{
  AdditivesForTodayCubit() : super(AdditivesForTodayInitialState());

  final service = AdditivesNetworkService();

  check() async{
    emit(AdditivesForTodayLoadingState());

    final response = await service.getAdditivesForToday();

    if(response.result){
      emit(AdditivesForTodayLoadedState(response.value));
    }
    else{
      emit(AdditivesForTodayErrorState());
    }

  }
}