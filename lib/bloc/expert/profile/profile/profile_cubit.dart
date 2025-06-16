

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/expert/profile/profile_model.dart';
import 'package:garnetbook/domain/services/expert/profile/profile_service.dart';
import 'package:intl/intl.dart';

part 'profile_state.dart';

class ProfileExpertCubit extends Cubit<ProfileExpertState>{
  ProfileExpertCubit() : super(ProfileExpertInitialState());

  final service = ProfileExpertService();

  check() async{
    emit(ProfileExpertLoadingState());
    final response = await service.getExpertProfile();
    if(response.result){
      emit(ProfileExpertLoadedState(response.value));
    }else{
      emit(ProfileExpertErrorState());
    }
  }
}