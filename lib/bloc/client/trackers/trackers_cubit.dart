
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/trackers/tracker_request.dart';
import 'package:garnetbook/data/models/client/trackers/tracker_response.dart';
import 'package:garnetbook/domain/services/client/trackers/trackers_service.dart';

part "trackers_state.dart";

class TrackersCubit extends Cubit<TrackersState> {
  TrackersCubit() : super(TrackersInitialState());

  final service = TrackersService();

  check() async{
    emit(TrackersLoadingState());

    final response = await service.getTracker();

    if(response.result){
      bool isEdit = false;

      if(response.value != null && response.value!.isNotEmpty){
        response.value!.forEach((element) async{
          if(element.trackerStatus?.id != null &&
              element.slots != null &&
              element.slots!.isNotEmpty &&
              element.slots?.last.needChecked != null &&
              element.clientTrackerId != null){

            if(element.trackerStatus?.id == 2){
              DateTime lastDate = DateTime.parse(element.slots!.last.needChecked!);
              int difference = lastDate.difference(DateTime.now()).inDays;

              if(difference.isNegative){

                bool isNotFull = element.slots!.any((item) => item.checked == false);

                if(isNotFull){
                  await service.setTracker(ClientTrackerRequest(
                      trackerStatusId: 3,
                      clientTrackerId: element.clientTrackerId
                  )).then((value) => isEdit = true);
                }
                else{
                  await service.setTracker(ClientTrackerRequest(
                      trackerStatusId: 5,
                      clientTrackerId: element.clientTrackerId
                  )).then((value) => isEdit = true);
                }
              }
            }

            if(element.trackerStatus?.id != 4){
              DateTime lastDate = DateTime.parse(element.slots!.last.needChecked!);
              int difference = DateTime.now().difference(lastDate).inDays;

              if(difference > 13){
                await service.setTracker(ClientTrackerRequest(
                    trackerStatusId: 4 ,
                    clientTrackerId: element.clientTrackerId
                )).then((value) => isEdit = true);
              }
            }
          }
        });
      }

      if(isEdit){
        final response2 = await service.getTracker();
        if(response2.result){
          emit(TrackersLoadedState(response2.value));
        }
        else{
          emit(TrackersErrorState());
        }
      }
      else{
        emit(TrackersLoadedState(response.value));
      }


    }
    else{
      emit(TrackersErrorState());
    }
  }
}