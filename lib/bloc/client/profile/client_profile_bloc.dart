
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/profile/client_profile_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

part 'client_profile_state.dart';

class ClientProfileCubit extends Cubit<ClientProfileState>{
  ClientProfileCubit() : super(ClientProfileInitialState());

  final client = GetIt.I.get<ApiClientProvider>().client;
  final storage = SharedPreferenceData.getInstance();


  check() async{
    try{
      emit(ClientProfileLoadingState());
      final response = await client.getClientProfile();

      final storageWeight = await storage.getItem(SharedPreferenceData.userWeightKey);
      final storageHeight = await storage.getItem(SharedPreferenceData.userHeightKey);
      final storageRole = await storage.getItem(SharedPreferenceData.role);
      final storageUserId = await storage.getUserId();
      final storageClientId = await storage.getItem(SharedPreferenceData.clientIdKey);
      final storageTarget = await storage.getItem(SharedPreferenceData.userTargetKey);

      if(response.clientProfile != null){
        if(storageWeight == "" || (response.clientProfile?.weight != null && storageWeight != response.clientProfile!.weight.toString())){
          storage.setItem(SharedPreferenceData.userWeightKey, response.clientProfile!.weight!.toString());
        }

        if(storageHeight == "" || (response.clientProfile?.height != null && storageWeight != response.clientProfile!.height.toString())){
          storage.setItem(SharedPreferenceData.userHeightKey, response.clientProfile!.height!.toString());
        }

        if(storageUserId == "" || (response.clientProfile?.userId != null && storageWeight != response.clientProfile!.userId.toString())){
          storage.setUserId(response.clientProfile!.userId!.toString());
        }

        if(storageClientId == "" || (response.clientProfile?.id != null && storageWeight != response.clientProfile!.id.toString())){
          storage.setItem(SharedPreferenceData.clientIdKey, response.clientProfile!.id.toString());
        }

        if(storageTarget == "" || (response.clientProfile?.target != null && storageWeight != response.clientProfile!.target.toString())){
          storage.setItem(SharedPreferenceData.userTargetKey, response.clientProfile!.target.toString());
        }

        if(storageRole == "" || storageRole == "2"){
          storage.setItem(SharedPreferenceData.role, "1");
        }
      }


      emit(ClientProfileLoadedState(response.clientProfile));

    }catch(error){
      emit(ClientProfileErrorState());
    }
  }
}