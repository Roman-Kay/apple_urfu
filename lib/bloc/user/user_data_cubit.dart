
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/user/user_model.dart';
import 'package:garnetbook/domain/services/auth/user_data.dart';

part "user_data_state.dart";

class UserDataCubit extends Cubit<UserDataState>{
  UserDataCubit() : super(UserDataInitialState());

  final service = UserDataService();

  check() async{
    emit(UserDataLoadingState());

    final response = await service.getUserData();

    if(response.result){
      emit(UserDataLoadedState(response.value));
    }
    else{
      emit(UserDataErrorState());
    }
  }
}