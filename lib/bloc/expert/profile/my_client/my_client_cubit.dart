
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/expert/my_clients/clients_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/expert/profile/my_clients_service.dart';

part 'my_client_state.dart';

class MyClientCubit extends Cubit<MyClientState>{
  MyClientCubit() : super(MyClientInitialState());

  final service = MyClientsService();
  final storage = SharedPreferenceData.getInstance();

  check() async{
    emit(MyClientLoadingState());

    final response = await service.getMyClient();
    if(response.result){
      emit(MyClientLoadedState(response.value));
    }
    else{
      emit(MyClientErrorState());
    }
  }
}