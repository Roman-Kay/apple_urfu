
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/additives/additives_model.dart';
import 'package:garnetbook/data/models/client/additives/additives_request.dart';
import 'package:garnetbook/domain/services/client/additives/additives_service.dart';

part 'additive_state.dart';

class AdditivesCubit extends Cubit<AdditivesState>{
  AdditivesCubit() : super(AdditivesInitialState());

  final service = AdditivesNetworkService();

  check() async{
    bool isEdit = false;
    emit(AdditivesLoadingState());

    final response = await service.getAdditives();

    if(response.result){

      if(response.value != null && response.value?.additives != null && response.value!.additives!.isNotEmpty){
        response.value!.additives!.forEach((element) async{
          if(element.additiveStatus?.additiveStatusId == 5){
            final response = await service.changeAdditivesStatus(ClientChangeStatusAdditivesRequest(
                additiveId: element.id,
                additiveStatusId: 6
            ));

            if(response.result){
              isEdit = true;
            }
          }

          if(element.finish != null && element.additiveStatus?.additiveStatusId != 6){
            DateTime lastDate = DateTime.parse(element.finish!);
            int difference = DateTime.now().difference(lastDate).inDays;

            if(difference > 7){
              final response = await service.changeAdditivesStatus(ClientChangeStatusAdditivesRequest(
                  additiveId: element.id,
                  additiveStatusId: 6
              ));

              if(response.result){
                isEdit = true;
              }
            }

            else if(difference > 1 && element.additiveStatus?.additiveStatusId != 4){
              final response = await service.changeAdditivesStatus(ClientChangeStatusAdditivesRequest(
                  additiveId: element.id,
                  additiveStatusId: 6
              ));

              if(response.result){
                isEdit = true;
              }
            }
          }
        });
      }

      if(response.value != null && response.value?.protocols != null && response.value!.protocols!.isNotEmpty){
        response.value!.protocols!.forEach((value){
          if(value.additivesViews != null && value.additivesViews!.isNotEmpty){
            value.additivesViews!.forEach((element) async{
              if(element.additiveStatus?.additiveStatusId == 5){
                final response = await service.changeAdditivesStatus(ClientChangeStatusAdditivesRequest(
                    additiveId: element.id,
                    additiveStatusId: 6
                ));

                if(response.result){
                  isEdit = true;
                }
              }

              if(element.finish != null && element.additiveStatus?.additiveStatusId != 6){
                DateTime lastDate = DateTime.parse(element.finish!);
                int difference = DateTime.now().difference(lastDate).inDays;

                if(difference > 7){
                  final response = await service.changeAdditivesStatus(ClientChangeStatusAdditivesRequest(
                      additiveId: element.id,
                      additiveStatusId: 6
                  ));

                  if(response.result){
                    isEdit = true;
                  }
                }

                else if(difference > 1 && element.additiveStatus?.additiveStatusId != 4){
                  final response = await service.changeAdditivesStatus(ClientChangeStatusAdditivesRequest(
                      additiveId: element.id,
                      additiveStatusId: 6
                  ));

                  if(response.result){
                    isEdit = true;
                  }
                }
              }
            });
          }
        });
      }

      if(isEdit){
        final response2 = await service.getAdditives();

        if(response2.result){
          emit(AdditivesLoadedState(response2.value));
        }
        else{
          emit(AdditivesErrorState());
        }
      }
      else{
        emit(AdditivesLoadedState(response.value));
        // final response2 = await service.getAdditives();
        //
        // if(response2.result){
        //   emit(AdditivesLoadedState(response2.value));
        // }
        // else{
        //   emit(AdditivesErrorState());
        // }
      }
    }
    else{
      emit(AdditivesErrorState());
    }
  }
}