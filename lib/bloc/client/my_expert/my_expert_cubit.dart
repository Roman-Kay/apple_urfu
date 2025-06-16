
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/expert/list/expert_list.dart';
import 'package:garnetbook/domain/services/expert/list/expert_list_data_service.dart';

part 'my_expert_state.dart';

class MyExpertCubit extends Cubit<MyExpertState>{
  MyExpertCubit() : super(MyExpertInitialState());

  check() async{
    emit(MyExpertLoadingState());

    final service = ExpertListDataService();

    final response = await service.getMyExpertList();

    if(response.result){
      emit(MyExpertLoadedState(response.value?.expertCardList));
    }
    else{
      emit(MyExpertErrorState());
    }
  }
}