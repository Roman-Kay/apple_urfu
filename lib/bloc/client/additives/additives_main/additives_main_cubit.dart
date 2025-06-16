import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/additives/additives_slot_model.dart';
import 'package:garnetbook/domain/services/client/additives/additives_service.dart';


part 'additives_main_state.dart';

class AdditivesMainCubit extends Cubit<AdditivesMainState>{
  AdditivesMainCubit() : super(AdditivesMainInitialState());

  final service = AdditivesNetworkService();

  check() async{
    emit(AdditivesMainLoadingState());

    final response = await service.getAdditivesForToday();

    if(response.result){
      emit(AdditivesMainLoadedState(response.value));
    }
    else{
      emit(AdditivesMainErrorState());
    }

  }
}